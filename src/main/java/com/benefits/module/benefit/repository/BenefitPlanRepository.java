package com.benefits.module.benefit.repository;

import com.benefits.module.benefit.entity.BenefitPlan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface BenefitPlanRepository extends JpaRepository<BenefitPlan, Long> {
    Optional<BenefitPlan> findByPlanCode(String planCode);

    List<BenefitPlan> findByBenefitTypeId(Long benefitTypeId);

    List<BenefitPlan> findByActiveTrue();

    Boolean existsByPlanCode(String planCode);
}
