package com.benefits.module.benefit.repository;

import com.benefits.module.benefit.entity.BenefitPlan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface BenefitPlanRepository extends JpaRepository<BenefitPlan, Long> {
    Optional<BenefitPlan> findByPlanCode(String planCode);

    @Query("SELECT b FROM BenefitPlan b WHERE " +
            "(:keyword IS NULL OR LOWER(b.planName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(b.planCode) LIKE LOWER(CONCAT('%', :keyword, '%'))) AND "
            +
            "(:typeId IS NULL OR b.benefitType.id = :typeId) AND " +
            "(:active IS NULL OR b.active = :active)")
    List<BenefitPlan> searchPlans(String keyword, Long typeId, Boolean active);

    List<BenefitPlan> findByBenefitTypeId(Long benefitTypeId);

    List<BenefitPlan> findByActiveTrue();

    Boolean existsByPlanCode(String planCode);
}
