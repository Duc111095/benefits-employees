package com.soict.benefit_employees.service.impl;

import com.soict.benefit_employees.dto.benefit.BenefitPackageResponse;
import com.soict.benefit_employees.dto.benefit.CreateBenefitPackageRequest;
import com.soict.benefit_employees.entity.BenefitPackage;
import com.soict.benefit_employees.entity.BenefitType;
import com.soict.benefit_employees.repository.BenefitPackageRepository;
import com.soict.benefit_employees.service.BenefitPackageService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class BenefitPackageServiceImpl implements BenefitPackageService {
    private final BenefitPackageRepository benefitPackageRepository;

    @Override
    @Transactional
    public BenefitPackageResponse createBenefitPackage(CreateBenefitPackageRequest request) {
        BenefitPackage benefitPackage = BenefitPackage.builder()
                .name(request.getName())
                .type(request.getType())
                .description(request.getDescription())
                .maxAmount(request.getMaxAmount())
                .isActive(true)
                .build();

        benefitPackage = benefitPackageRepository.save(benefitPackage);
        return mapToBenefitPackageResponse(benefitPackage);
    }

    @Override
    @Transactional(readOnly = true)
    public BenefitPackageResponse getBenefitPackage(String id) {
        BenefitPackage benefitPackage = benefitPackageRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Benefit package not found"));
        return mapToBenefitPackageResponse(benefitPackage);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<BenefitPackageResponse> getAllBenefitPackages(Pageable pageable) {
        return benefitPackageRepository.findAll(pageable)
                .map(this::mapToBenefitPackageResponse);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<BenefitPackageResponse> getActiveBenefitPackages(Pageable pageable) {
        return benefitPackageRepository.findByIsActiveTrue(pageable)
                .map(this::mapToBenefitPackageResponse);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<BenefitPackageResponse> getBenefitPackagesByType(BenefitType type, Pageable pageable) {
        return benefitPackageRepository.findByTypeAndIsActiveTrue(type, pageable)
                .map(this::mapToBenefitPackageResponse);
    }

    @Override
    @Transactional
    public BenefitPackageResponse updateBenefitPackage(String id, CreateBenefitPackageRequest request) {
        BenefitPackage benefitPackage = benefitPackageRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Benefit package not found"));

        benefitPackage.setName(request.getName());
        benefitPackage.setType(request.getType());
        benefitPackage.setDescription(request.getDescription());
        benefitPackage.setMaxAmount(request.getMaxAmount());

        benefitPackage = benefitPackageRepository.save(benefitPackage);
        return mapToBenefitPackageResponse(benefitPackage);
    }

    @Override
    @Transactional
    public BenefitPackageResponse toggleBenefitPackageStatus(String id) {
        BenefitPackage benefitPackage = benefitPackageRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Benefit package not found"));
        
        benefitPackage.setActive(!benefitPackage.isActive());
        benefitPackage = benefitPackageRepository.save(benefitPackage);
        return mapToBenefitPackageResponse(benefitPackage);
    }

    @Override
    @Transactional
    public void deleteBenefitPackage(String id) {
        BenefitPackage benefitPackage = benefitPackageRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Benefit package not found"));
        benefitPackageRepository.delete(benefitPackage);
    }

    private BenefitPackageResponse mapToBenefitPackageResponse(BenefitPackage benefitPackage) {
        return BenefitPackageResponse.builder()
                .id(benefitPackage.getId())
                .name(benefitPackage.getName())
                .type(benefitPackage.getType())
                .description(benefitPackage.getDescription())
                .maxAmount(benefitPackage.getMaxAmount())
                .isActive(benefitPackage.isActive())
                .createdAt(benefitPackage.getCreatedAt())
                .updatedAt(benefitPackage.getUpdatedAt())
                .build();
    }
}