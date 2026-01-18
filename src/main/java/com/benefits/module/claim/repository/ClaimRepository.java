package com.benefits.module.claim.repository;

import com.benefits.module.claim.entity.BenefitClaim;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ClaimRepository extends JpaRepository<BenefitClaim, Long> {
    List<BenefitClaim> findByEmployeeId(Long employeeId);

    List<BenefitClaim> findByStatus(String status);
}
