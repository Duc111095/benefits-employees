package com.soict.benefit_employees.controller;

import com.soict.benefit_employees.dto.registration.CreateRegistrationRequest;
import com.soict.benefit_employees.dto.registration.RegistrationResponse;
import com.soict.benefit_employees.dto.registration.UpdateRegistrationRequest;
import com.soict.benefit_employees.entity.RegistrationStatus;
import com.soict.benefit_employees.service.BenefitRegistrationService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/registrations")
@RequiredArgsConstructor
public class BenefitRegistrationController {
    private final BenefitRegistrationService registrationService;

    @PostMapping("/employee/{employeeId}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('HR') or @securityUtils.isCurrentUser(#employeeId)")
    public ResponseEntity<RegistrationResponse> createRegistration(
            @PathVariable String employeeId,
            @Valid @RequestBody CreateRegistrationRequest request) {
        return ResponseEntity.ok(registrationService.createRegistration(employeeId, request));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('HR') or @securityUtils.isRegistrationOwner(#id)")
    public ResponseEntity<RegistrationResponse> getRegistration(@PathVariable String id) {
        return ResponseEntity.ok(registrationService.getRegistration(id));
    }

    @GetMapping
    @PreAuthorize("hasRole('ADMIN') or hasRole('HR')")
    public ResponseEntity<Page<RegistrationResponse>> getAllRegistrations(Pageable pageable) {
        return ResponseEntity.ok(registrationService.getAllRegistrations(pageable));
    }

    @GetMapping("/employee/{employeeId}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('HR') or @securityUtils.isCurrentUser(#employeeId)")
    public ResponseEntity<Page<RegistrationResponse>> getRegistrationsByEmployee(
            @PathVariable String employeeId, Pageable pageable) {
        return ResponseEntity.ok(registrationService.getRegistrationsByEmployee(employeeId, pageable));
    }

    @GetMapping("/status/{status}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('HR')")
    public ResponseEntity<Page<RegistrationResponse>> getRegistrationsByStatus(
            @PathVariable RegistrationStatus status, Pageable pageable) {
        return ResponseEntity.ok(registrationService.getRegistrationsByStatus(status, pageable));
    }

    @GetMapping("/benefit/{benefitId}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('HR')")
    public ResponseEntity<Page<RegistrationResponse>> getRegistrationsByBenefit(
            @PathVariable String benefitId, Pageable pageable) {
        return ResponseEntity.ok(registrationService.getRegistrationsByBenefit(benefitId, pageable));
    }

    @PatchMapping("/{id}/approve")
    @PreAuthorize("hasRole('ADMIN') or hasRole('HR')")
    public ResponseEntity<RegistrationResponse> approveRegistration(
            @PathVariable String id,
            @Valid @RequestBody UpdateRegistrationRequest request) {
        return ResponseEntity.ok(registrationService.approveRegistration(id, request));
    }

    @PatchMapping("/{id}/reject")
    @PreAuthorize("hasRole('ADMIN') or hasRole('HR')")
    public ResponseEntity<RegistrationResponse> rejectRegistration(
            @PathVariable String id,
            @Valid @RequestBody UpdateRegistrationRequest request) {
        return ResponseEntity.ok(registrationService.rejectRegistration(id, request));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('HR') or @securityUtils.isRegistrationOwner(#id)")
    public ResponseEntity<Void> deleteRegistration(@PathVariable String id) {
        registrationService.deleteRegistration(id);
        return ResponseEntity.ok().build();
    }
}