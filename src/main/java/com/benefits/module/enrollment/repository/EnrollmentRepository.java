package com.benefits.module.enrollment.repository;

import com.benefits.module.enrollment.entity.Enrollment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EnrollmentRepository extends JpaRepository<Enrollment, Long> {
    List<Enrollment> findByEmployeeId(Long employeeId);

    List<Enrollment> findByBenefitPlanId(Long benefitPlanId);

    List<Enrollment> findByStatus(String status);
}
