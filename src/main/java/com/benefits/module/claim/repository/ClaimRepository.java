package com.benefits.module.claim.repository;

import com.benefits.module.claim.entity.BenefitClaim;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Repository
public interface ClaimRepository extends JpaRepository<BenefitClaim, Long> {
    List<BenefitClaim> findByEmployeeId(Long employeeId);

    List<BenefitClaim> findByStatus(String status);

    @Query("SELECT c FROM BenefitClaim c ")
    List<BenefitClaim> searchClaims(
            @Param("status") String status,
            @Param("deptId") Long deptId,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate,
            @Param("keyword") String keyword);

    @Query("SELECT FUNCTION('DATE_FORMAT', c.approvalDate, '%Y-%m'), SUM(c.claimAmount) " +
            "FROM BenefitClaim c WHERE c.status = 'APPROVED' " +
            "GROUP BY FUNCTION('DATE_FORMAT', c.approvalDate, '%Y-%m') " +
            "ORDER BY FUNCTION('DATE_FORMAT', c.approvalDate, '%Y-%m') ASC")
    List<Object[]> findMonthlyCostTrends();

    @Query("SELECT c.employee.department.name, SUM(c.claimAmount) " +
            "FROM BenefitClaim c WHERE c.status = 'APPROVED' " +
            "GROUP BY c.employee.department.name")
    List<Object[]> findCostByDepartment();

    @Query("SELECT c.status, COUNT(c) FROM BenefitClaim c GROUP BY c.status")
    List<Object[]> countByStatus();

    @Query("SELECT SUM(c.claimAmount) FROM BenefitClaim c WHERE c.status = 'APPROVED'")
    BigDecimal getTotalApprovedCost();
}
