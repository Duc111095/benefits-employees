package com.soict.benefit_employees.controller;

import com.soict.benefit_employees.dto.benefit.BenefitPackageResponse;
import com.soict.benefit_employees.dto.benefit.CreateBenefitPackageRequest;
import com.soict.benefit_employees.entity.BenefitType;
import com.soict.benefit_employees.service.BenefitPackageService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/benefits")
@RequiredArgsConstructor
public class BenefitPackageController {
    private final BenefitPackageService benefitPackageService;

    @PostMapping
    @PreAuthorize("hasRole('ADMIN') or hasRole('HR')")
    public ResponseEntity<BenefitPackageResponse> createBenefitPackage(
            @Valid @RequestBody CreateBenefitPackageRequest request) {
        return ResponseEntity.ok(benefitPackageService.createBenefitPackage(request));
    }

    @GetMapping("/{id}")
    public ResponseEntity<BenefitPackageResponse> getBenefitPackage(@PathVariable String id) {
        return ResponseEntity.ok(benefitPackageService.getBenefitPackage(id));
    }

    @GetMapping
    public ResponseEntity<Page<BenefitPackageResponse>> getAllBenefitPackages(Pageable pageable) {
        return ResponseEntity.ok(benefitPackageService.getAllBenefitPackages(pageable));
    }

    @GetMapping("/active")
    public ResponseEntity<Page<BenefitPackageResponse>> getActiveBenefitPackages(Pageable pageable) {
        return ResponseEntity.ok(benefitPackageService.getActiveBenefitPackages(pageable));
    }

    @GetMapping("/type/{type}")
    public ResponseEntity<Page<BenefitPackageResponse>> getBenefitPackagesByType(
            @PathVariable BenefitType type, Pageable pageable) {
        return ResponseEntity.ok(benefitPackageService.getBenefitPackagesByType(type, pageable));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('HR')")
    public ResponseEntity<BenefitPackageResponse> updateBenefitPackage(
            @PathVariable String id, @Valid @RequestBody CreateBenefitPackageRequest request) {
        return ResponseEntity.ok(benefitPackageService.updateBenefitPackage(id, request));
    }

    @PatchMapping("/{id}/toggle")
    @PreAuthorize("hasRole('ADMIN') or hasRole('HR')")
    public ResponseEntity<BenefitPackageResponse> toggleBenefitPackageStatus(@PathVariable String id) {
        return ResponseEntity.ok(benefitPackageService.toggleBenefitPackageStatus(id));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteBenefitPackage(@PathVariable String id) {
        benefitPackageService.deleteBenefitPackage(id);
        return ResponseEntity.ok().build();
    }
}