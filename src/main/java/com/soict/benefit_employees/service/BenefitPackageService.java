package com.soict.benefit_employees.service;

import com.soict.benefit_employees.dto.benefit.BenefitPackageResponse;
import com.soict.benefit_employees.dto.benefit.CreateBenefitPackageRequest;
import com.soict.benefit_employees.entity.BenefitType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface BenefitPackageService {
    BenefitPackageResponse createBenefitPackage(CreateBenefitPackageRequest request);
    BenefitPackageResponse getBenefitPackage(String id);
    Page<BenefitPackageResponse> getAllBenefitPackages(Pageable pageable);
    Page<BenefitPackageResponse> getActiveBenefitPackages(Pageable pageable);
    Page<BenefitPackageResponse> getBenefitPackagesByType(BenefitType type, Pageable pageable);
    BenefitPackageResponse updateBenefitPackage(String id, CreateBenefitPackageRequest request);
    BenefitPackageResponse toggleBenefitPackageStatus(String id);
    void deleteBenefitPackage(String id);
}