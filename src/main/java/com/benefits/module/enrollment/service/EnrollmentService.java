package com.benefits.module.enrollment.service;

import com.benefits.common.Constants;
import com.benefits.module.benefit.entity.BenefitBalance;
import com.benefits.module.benefit.entity.BenefitPlan;
import com.benefits.module.benefit.repository.BenefitBalanceRepository;
import com.benefits.module.benefit.repository.BenefitPlanRepository;
import com.benefits.module.employee.entity.Employee;
import com.benefits.module.employee.repository.EmployeeRepository;
import com.benefits.module.enrollment.entity.Enrollment;
import com.benefits.module.enrollment.entity.EnrollmentHistory;
import com.benefits.module.enrollment.repository.EnrollmentHistoryRepository;
import com.benefits.module.enrollment.repository.EnrollmentRepository;
import com.benefits.module.auth.entity.User;
import com.benefits.module.auth.repository.UserRepository;
import com.benefits.module.notification.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class EnrollmentService {

    private final EnrollmentRepository enrollmentRepository;
    private final EnrollmentHistoryRepository enrollmentHistoryRepository;
    private final EmployeeRepository employeeRepository;
    private final BenefitPlanRepository benefitPlanRepository;
    private final BenefitBalanceRepository benefitBalanceRepository;
    private final NotificationService notificationService;
    private final UserRepository userRepository;

    @Transactional
    public Enrollment requestEnrollment(Long employeeId, Long planId, String notes) {
        // ... existing logic (abbreviated for the tool)
        Employee employee = employeeRepository.findById(employeeId)
                .orElseThrow(() -> new IllegalArgumentException("Employee not found"));
        BenefitPlan plan = benefitPlanRepository.findById(planId)
                .orElseThrow(() -> new IllegalArgumentException("Benefit Plan not found"));

        if (!plan.getActive()) {
            throw new IllegalArgumentException("This benefit plan is currently inactive.");
        }

        boolean alreadyEnrolled = enrollmentRepository.findByEmployeeId(employeeId).stream()
                .anyMatch(e -> e.getBenefitPlan().getId().equals(planId) &&
                        (e.getStatus().equals(Constants.ENROLLMENT_STATUS_ACTIVE) ||
                                e.getStatus().equals(Constants.ENROLLMENT_STATUS_PENDING)));

        if (alreadyEnrolled) {
            throw new IllegalArgumentException("You are already enrolled in or have a pending request for this plan.");
        }

        Enrollment enrollment = new Enrollment();
        enrollment.setEmployee(employee);
        enrollment.setBenefitPlan(plan);
        enrollment.setEnrollmentDate(LocalDate.now());
        enrollment.setStatus(Constants.ENROLLMENT_STATUS_PENDING);
        enrollment.setCompanyContribution(plan.getCompanyContribution());
        enrollment.setEmployeeContribution(plan.getEmployeeContribution());
        enrollment.setNotes(notes);

        Enrollment saved = enrollmentRepository.save(enrollment);

        EnrollmentHistory history = new EnrollmentHistory();
        history.setEnrollment(saved);
        history.setChangeType(Constants.CHANGE_TYPE_CREATED);
        history.setNewValue("Status: " + saved.getStatus() + (notes != null ? " Notes: " + notes : ""));
        enrollmentHistoryRepository.save(history);

        List<User> hrManagers = userRepository.findAll().stream()
                .filter(u -> u.getRole().equals(Constants.ROLE_HR_MANAGER))
                .toList();
        for (User hr : hrManagers) {
            notificationService.sendNotification(hr, "New Enrollment Request",
                    "Employee " + employee.getFullName() + " requested to enroll in " + plan.getPlanName(),
                    Constants.NOTIFICATION_TYPE_INFO, Constants.NOTIFICATION_CAT_ENROLLMENT);
        }

        return saved;
    }

    @Transactional
    public void approveEnrollment(Long enrollmentId, User approver) {
        Enrollment enrollment = enrollmentRepository.findById(enrollmentId)
                .orElseThrow(() -> new IllegalArgumentException("Enrollment not found"));

        enrollment.setStatus(Constants.ENROLLMENT_STATUS_ACTIVE);
        enrollment.setEffectiveDate(LocalDate.now());
        enrollmentRepository.save(enrollment);

        // Update/Initialize Benefit Balance
        BenefitPlan plan = enrollment.getBenefitPlan();
        Employee employee = enrollment.getEmployee();
        int currentYear = LocalDate.now().getYear();

        BenefitBalance balance = benefitBalanceRepository.findByEmployeeIdAndBenefitTypeIdAndYear(
                employee.getId(), plan.getBenefitType().getId(), currentYear)
                .orElseGet(() -> {
                    BenefitBalance newBalance = new BenefitBalance();
                    newBalance.setEmployee(employee);
                    newBalance.setBenefitType(plan.getBenefitType());
                    newBalance.setYear(currentYear);
                    return newBalance;
                });

        // Calculate limit based on plan settings
        java.math.BigDecimal totalLimit = java.math.BigDecimal.ZERO;
        if ("AMOUNT".equals(plan.getLimitType()) && plan.getLimitValue() != null) {
            totalLimit = plan.getLimitValue();
        } else if ("PERCENTAGE".equals(plan.getLimitType()) && plan.getLimitValue() != null
                && employee.getBasicSalary() != null) {
            totalLimit = java.math.BigDecimal.valueOf(employee.getBasicSalary())
                    .multiply(plan.getLimitValue())
                    .divide(java.math.BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        } else if (plan.getBudget() != null) {
            totalLimit = plan.getBudget();
        }

        balance.setTotalLimit(totalLimit);
        balance.setRemainingAmount(totalLimit.subtract(balance.getUsedAmount()));
        benefitBalanceRepository.save(balance);

        // History
        EnrollmentHistory history = new EnrollmentHistory();
        history.setEnrollment(enrollment);
        history.setChangeType(Constants.CHANGE_TYPE_STATUS_CHANGED);
        history.setChangedBy(approver);
        history.setNewValue("Status: ACTIVE (Approved)");
        history.setNotes("Plan: " + plan.getPlanName() + " | Annual Limit: " + totalLimit);
        enrollmentHistoryRepository.save(history);

        // Notify Employee
        userRepository.findByEmployeeId(employee.getId()).ifPresent(u -> {
            notificationService.sendNotification(u, "Enrollment Approved",
                    "Your request for " + plan.getPlanName() + " has been approved.",
                    Constants.NOTIFICATION_TYPE_SUCCESS, Constants.NOTIFICATION_CAT_ENROLLMENT);
        });
    }

    @Transactional
    public void rejectEnrollment(Long enrollmentId, String reason, User approver) {
        Enrollment enrollment = enrollmentRepository.findById(enrollmentId)
                .orElseThrow(() -> new IllegalArgumentException("Enrollment not found"));

        enrollment.setStatus(Constants.ENROLLMENT_STATUS_REJECTED);
        enrollmentRepository.save(enrollment);

        // History
        EnrollmentHistory history = new EnrollmentHistory();
        history.setEnrollment(enrollment);
        history.setChangeType(Constants.CHANGE_TYPE_STATUS_CHANGED);
        history.setChangedBy(approver);
        history.setNewValue("Status: REJECTED");
        history.setNotes("Reason: " + reason);
        enrollmentHistoryRepository.save(history);

        // Notify Employee
        userRepository.findByEmployeeId(enrollment.getEmployee().getId()).ifPresent(u -> {
            notificationService.sendNotification(u, "Enrollment Rejected",
                    "Your request for " + enrollment.getBenefitPlan().getPlanName() + " was rejected. Reason: "
                            + reason,
                    Constants.NOTIFICATION_TYPE_DANGER, Constants.NOTIFICATION_CAT_ENROLLMENT);
        });
    }

    public List<Enrollment> searchEnrollments(String status, Long deptId, Long typeId,
            LocalDate startDate, LocalDate endDate, String keyword) {
        return enrollmentRepository.searchEnrollments(status, deptId, typeId, startDate, endDate, keyword);
    }

    public Enrollment getEnrollmentById(Long id) {
        return enrollmentRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Enrollment not found"));
    }

    public List<Enrollment> getAllEnrollments() {
        return enrollmentRepository.findAll();
    }

    public List<Enrollment> getEnrollmentsByEmployee(Long employeeId) {
        return enrollmentRepository.findByEmployeeId(employeeId);
    }
}
