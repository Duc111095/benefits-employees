package com.benefits.module.benefit.repository;

import com.benefits.module.benefit.entity.BenefitBalance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.Optional;

@Repository
public interface BenefitBalanceRepository extends JpaRepository<BenefitBalance, Long> {
    Optional<BenefitBalance> findByEmployeeIdAndBenefitTypeIdAndYear(Long employeeId, Long benefitTypeId, Integer year);

    @Query("SELECT b.remainingAmount FROM BenefitBalance b WHERE b.employee.id = :employeeId AND b.benefitType.id = :benefitTypeId")
    BigDecimal getRemainingBalance(Long employeeId, Long benefitTypeId);
}
