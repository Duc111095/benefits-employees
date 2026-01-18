package com.benefits.module.enrollment.repository;

import com.benefits.module.enrollment.entity.Enrollment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.List;

@Repository
public interface EnrollmentRepository extends JpaRepository<Enrollment, Long> {
    List<Enrollment> findByEmployeeId(Long employeeId);

    List<Enrollment> findByBenefitPlanId(Long benefitPlanId);

    List<Enrollment> findByStatus(String status);

    @Query("SELECT e FROM Enrollment e WHERE " +
            "(:status IS NULL OR e.status = :status) AND " +
            "(:deptId IS NULL OR e.employee.department.id = :deptId) AND " +
            "(:typeId IS NULL OR e.benefitPlan.benefitType.id = :typeId) AND " +
            "(:startDate IS NULL OR e.enrollmentDate >= :startDate) AND " +
            "(:endDate IS NULL OR e.enrollmentDate <= :endDate) AND " +
            "(:keyword IS NULL OR LOWER(e.employee.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "OR LOWER(e.employee.employeeCode) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
            "ORDER BY e.enrollmentDate DESC")
    List<Enrollment> searchEnrollments(
            @Param("status") String status,
            @Param("deptId") Long deptId,
            @Param("typeId") Long typeId,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate,
            @Param("keyword") String keyword);

    @Query("SELECT e.benefitPlan.benefitType.name, COUNT(e) FROM Enrollment e GROUP BY e.benefitPlan.benefitType.name")
    List<Object[]> countByBenefitType();

    @Query("SELECT e.status, COUNT(e) FROM Enrollment e GROUP BY e.status")
    List<Object[]> countByStatus();

    @Query("SELECT e.benefitPlan.planName, COUNT(e) FROM Enrollment e GROUP BY e.benefitPlan.planName ORDER BY COUNT(e) DESC")
    List<Object[]> findTopPlans();
}
