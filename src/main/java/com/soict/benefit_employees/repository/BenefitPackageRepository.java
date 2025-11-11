package com.soict.benefit_employees.repository;

import com.soict.benefit_employees.entity.BenefitPackage;
import com.soict.benefit_employees.entity.BenefitType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BenefitPackageRepository extends JpaRepository<BenefitPackage, String> {
    Page<BenefitPackage> findByTypeAndIsActiveTrue(BenefitType type, Pageable pageable);
    Page<BenefitPackage> findByIsActiveTrue(Pageable pageable);
}