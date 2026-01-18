package com.benefits.module.enrollment.service;

import com.benefits.module.enrollment.entity.Enrollment;
import com.benefits.module.enrollment.entity.EnrollmentHistory;
import com.benefits.module.enrollment.repository.EnrollmentHistoryRepository;
import com.benefits.module.enrollment.repository.EnrollmentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class EnrollmentService {

    private final EnrollmentRepository enrollmentRepository;
    private final EnrollmentHistoryRepository enrollmentHistoryRepository;

    public List<Enrollment> getAllEnrollments() {
        return enrollmentRepository.findAll();
    }

    public List<Enrollment> getEnrollmentsByEmployee(Long employeeId) {
        return enrollmentRepository.findByEmployeeId(employeeId);
    }

    @Transactional
    public Enrollment createEnrollment(Enrollment enrollment) {
        Enrollment saved = enrollmentRepository.save(enrollment);

        // Log history
        EnrollmentHistory history = new EnrollmentHistory();
        history.setEnrollment(saved);
        history.setChangeType("CREATED");
        history.setNewValue("Status: " + saved.getStatus());
        enrollmentHistoryRepository.save(history);

        return saved;
    }
}
