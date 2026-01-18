package com.benefits.module.claim.service;

import com.benefits.common.Constants;
import com.benefits.module.auth.entity.User;
import com.benefits.module.auth.repository.UserRepository;
import com.benefits.module.benefit.entity.BenefitBalance;
import com.benefits.module.benefit.repository.BenefitBalanceRepository;
import com.benefits.module.claim.entity.BenefitClaim;
import com.benefits.module.claim.entity.ClaimHistory;
import com.benefits.module.claim.repository.ClaimHistoryRepository;
import com.benefits.module.claim.repository.ClaimRepository;
import com.benefits.module.enrollment.entity.Enrollment;
import com.benefits.module.enrollment.repository.EnrollmentRepository;
import com.benefits.module.notification.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ClaimService {

    private final ClaimRepository claimRepository;
    private final EnrollmentRepository enrollmentRepository;
    private final NotificationService notificationService;
    private final UserRepository userRepository;
    private final BenefitBalanceRepository benefitBalanceRepository;
    private final ClaimHistoryRepository claimHistoryRepository;

    public List<BenefitClaim> getAllClaims() {
        return claimRepository.findAll();
    }

    public List<BenefitClaim> getPendingClaims() {
        return claimRepository.findByStatus(Constants.CLAIM_STATUS_PENDING);
    }

    public BenefitClaim getClaimById(Long id) {
        return claimRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Claim not found"));
    }

    public List<BenefitClaim> searchClaims(String status, Long deptId, LocalDate startDate, LocalDate endDate,
            String keyword) {
        return claimRepository.searchClaims(status, deptId, startDate, endDate, keyword);
    }

    @Transactional
    public BenefitClaim submitClaim(BenefitClaim claim) {
        // Validation: Ensure enrollment exists and belongs to the employee
        Enrollment enrollment = enrollmentRepository.findById(claim.getEnrollment().getId())
                .orElseThrow(() -> new IllegalArgumentException("Enrollment not found"));

        if (!enrollment.getEmployee().getId().equals(claim.getEmployee().getId())) {
            throw new IllegalArgumentException("You are not authorized to submit a claim for this benefit.");
        }

        if (!enrollment.getStatus().equals(Constants.ENROLLMENT_STATUS_ACTIVE)) {
            throw new IllegalArgumentException("This benefit enrollment is not active.");
        }

        claim.setStatus(Constants.CLAIM_STATUS_PENDING);
        claim.setSubmissionDate(LocalDateTime.now());

        BenefitClaim saved = claimRepository.save(claim);

        // Notify Manager (Find all users with role MANAGER in the same department)
        List<User> managers = userRepository.findAll().stream()
                .filter(u -> u.getRole().equals(Constants.ROLE_MANAGER) &&
                        u.getEmployee() != null &&
                        u.getEmployee().getDepartment().getId()
                                .equals(enrollment.getEmployee().getDepartment().getId()))
                .toList();

        for (User manager : managers) {
            notificationService.sendNotification(manager, "New Benefit Claim",
                    "Employee " + enrollment.getEmployee().getFullName() + " submitted a claim for "
                            + enrollment.getBenefitPlan().getPlanName(),
                    Constants.NOTIFICATION_TYPE_INFO, Constants.NOTIFICATION_CAT_CLAIM);
        }

        // Log History
        saveClaimHistory(saved, Constants.CHANGE_TYPE_CLAIM_SUBMITTED, null, Constants.CLAIM_STATUS_PENDING,
                "Claim submitted by employee", claim.getSubmittedBy());

        return saved;
    }

    @Transactional
    public void approveClaim(Long id, User approver) {
        BenefitClaim claim = claimRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Claim not found"));

        if (!Constants.CLAIM_STATUS_PENDING.equals(claim.getStatus())) {
            throw new IllegalStateException("Only pending claims can be approved.");
        }

        // 1. Balance Validation & Update
        Enrollment enrollment = claim.getEnrollment();
        int year = claim.getClaimDate().getYear();
        BenefitBalance balance = benefitBalanceRepository
                .findByEmployeeIdAndBenefitTypeIdAndYear(
                        claim.getEmployee().getId(),
                        enrollment.getBenefitPlan().getBenefitType().getId(),
                        year)
                .orElseThrow(() -> new IllegalStateException("No benefit balance found for this employee/type/year."));

        if (balance.getRemainingAmount().compareTo(claim.getClaimAmount()) < 0) {
            throw new IllegalStateException("Insufficient benefit balance. Available: " + balance.getRemainingAmount());
        }

        // Deduct from balance
        balance.setUsedAmount(balance.getUsedAmount().add(claim.getClaimAmount()));
        balance.setRemainingAmount(balance.getRemainingAmount().subtract(claim.getClaimAmount()));
        benefitBalanceRepository.save(balance);

        // 2. Update Claim Status
        String oldStatus = claim.getStatus();
        claim.setStatus(Constants.CLAIM_STATUS_APPROVED);
        claim.setApprovalDate(LocalDateTime.now());
        claim.setApprovedBy(approver);
        claimRepository.save(claim);

        // 3. Log History
        saveClaimHistory(claim, Constants.CHANGE_TYPE_CLAIM_STATUS_CHANGED, oldStatus, Constants.CLAIM_STATUS_APPROVED,
                "Claim approved by manager", approver);

        // 4. Notify Employee
        userRepository.findByEmployeeId(claim.getEmployee().getId()).ifPresent(u -> {
            notificationService.sendNotification(u, "Claim Approved",
                    "Your claim for " + claim.getEnrollment().getBenefitPlan().getPlanName() + " has been approved.",
                    Constants.NOTIFICATION_TYPE_SUCCESS, Constants.NOTIFICATION_CAT_CLAIM);
        });
    }

    @Transactional
    public void rejectClaim(Long id, String reason, User approver) {
        BenefitClaim claim = claimRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Claim not found"));

        if (!Constants.CLAIM_STATUS_PENDING.equals(claim.getStatus())) {
            throw new IllegalStateException("Only pending claims can be rejected.");
        }

        String oldStatus = claim.getStatus();
        claim.setStatus(Constants.CLAIM_STATUS_REJECTED);
        claim.setRejectionReason(reason);
        claim.setApprovedBy(approver);
        claimRepository.save(claim);

        // Log History
        saveClaimHistory(claim, Constants.CHANGE_TYPE_CLAIM_STATUS_CHANGED, oldStatus, Constants.CLAIM_STATUS_REJECTED,
                "Claim rejected. Reason: " + reason, approver);

        // Notify Employee
        userRepository.findByEmployeeId(claim.getEmployee().getId()).ifPresent(u -> {
            notificationService.sendNotification(u, "Claim Rejected",
                    "Your claim for " + claim.getEnrollment().getBenefitPlan().getPlanName() + " was rejected. Reason: "
                            + reason,
                    Constants.NOTIFICATION_TYPE_DANGER, Constants.NOTIFICATION_CAT_CLAIM);
        });
    }

    private void saveClaimHistory(BenefitClaim claim, String changeType, String oldValue, String newValue, String notes,
            User user) {
        ClaimHistory history = new ClaimHistory();
        history.setClaim(claim);
        history.setChangeType(changeType);
        history.setOldValue(oldValue);
        history.setNewValue(newValue);
        history.setNotes(notes);
        history.setChangedBy(user);
        claimHistoryRepository.save(history);
    }
}
