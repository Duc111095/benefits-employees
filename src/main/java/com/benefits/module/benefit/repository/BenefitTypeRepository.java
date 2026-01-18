package com.benefits.module.benefit.repository;

import com.benefits.module.benefit.entity.BenefitType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface BenefitTypeRepository extends JpaRepository<BenefitType, Long> {
    Optional<BenefitType> findByCode(String code);

    List<BenefitType> findByActiveTrue();

    Boolean existsByCode(String code);
}
