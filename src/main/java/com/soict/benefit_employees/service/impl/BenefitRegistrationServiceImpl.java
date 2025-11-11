package com.soict.benefit_employees.service.impl;

import com.soict.benefit_employees.dto.registration.CreateRegistrationRequest;
import com.soict.benefit_employees.dto.registration.RegistrationResponse;
import com.soict.benefit_employees.dto.registration.UpdateRegistrationRequest;
import com.soict.benefit_employees.entity.*;
import com.soict.benefit_employees.repository.BenefitPackageRepository;
import com.soict.benefit_employees.repository.BenefitRegistrationRepository;
import com.soict.benefit_employees.repository.EmployeeRepository;
import com.soict.benefit_employees.repository.UserRepository;
import com.soict.benefit_employees.service.BenefitRegistrationService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class BenefitRegistrationServiceImpl implements BenefitRegistrationService {
    private final BenefitRegistrationRepository registrationRepository;
    private final BenefitPackageRepository benefitPackageRepository;
    private final EmployeeRepository employeeRepository;
    private final UserRepository userRepository;

    @Override
    @Transactional
    public RegistrationResponse createRegistration(String employeeId, CreateRegistrationRequest request) {
        Employee employee = employeeRepository.findById(employeeId)
                .orElseThrow(() -> new RuntimeException("Employee not found"));

        BenefitPackage benefit = benefitPackageRepository.findById(request.getBenefitId())
                .orElseThrow(() -> new RuntimeException("Benefit package not found"));

        if (!benefit.isActive()) {
            throw new RuntimeException("This benefit package is not active");
        }

        if (request.getAmount().compareTo(benefit.getMaxAmount()) > 0) {
            throw new RuntimeException("Requested amount exceeds maximum allowed amount");
        }

        BenefitRegistration registration = BenefitRegistration.builder()
                .employee(employee)
                .benefit(benefit)
                .amount(request.getAmount())
                .status(RegistrationStatus.PENDING)
                .notes(request.getNotes())
                .build();

        registration = registrationRepository.save(registration);
        return mapToRegistrationResponse(registration);
    }

    @Override
    @Transactional(readOnly = true)
    public RegistrationResponse getRegistration(String id) {
        BenefitRegistration registration = registrationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Registration not found"));
        return mapToRegistrationResponse(registration);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<RegistrationResponse> getAllRegistrations(Pageable pageable) {
        return registrationRepository.findAll(pageable)
                .map(this::mapToRegistrationResponse);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<RegistrationResponse> getRegistrationsByEmployee(String employeeId, Pageable pageable) {
        return registrationRepository.findByEmployeeId(employeeId, pageable)
                .map(this::mapToRegistrationResponse);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<RegistrationResponse> getRegistrationsByStatus(RegistrationStatus status, Pageable pageable) {
        return registrationRepository.findByStatus(status, pageable)
                .map(this::mapToRegistrationResponse);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<RegistrationResponse> getRegistrationsByBenefit(String benefitId, Pageable pageable) {
        return registrationRepository.findByBenefitId(benefitId, pageable)
                .map(this::mapToRegistrationResponse);
    }

    @Override
    @Transactional
    public RegistrationResponse approveRegistration(String id, UpdateRegistrationRequest request) {
        BenefitRegistration registration = registrationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Registration not found"));

        if (registration.getStatus() != RegistrationStatus.PENDING) {
            throw new RuntimeException("Registration is not in pending state");
        }

        String currentUserEmail = SecurityContextHolder.getContext().getAuthentication().getName();
        User approver = userRepository.findByEmail(currentUserEmail)
                .orElseThrow(() -> new RuntimeException("Approver not found"));

        registration.setStatus(RegistrationStatus.APPROVED);
        registration.setNotes(request.getNotes());
        registration.setApprovedBy(approver);
        registration.setApprovedDate(LocalDateTime.now());

        registration = registrationRepository.save(registration);
        return mapToRegistrationResponse(registration);
    }

    @Override
    @Transactional
    public RegistrationResponse rejectRegistration(String id, UpdateRegistrationRequest request) {
        BenefitRegistration registration = registrationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Registration not found"));

        if (registration.getStatus() != RegistrationStatus.PENDING) {
            throw new RuntimeException("Registration is not in pending state");
        }

        String currentUserEmail = SecurityContextHolder.getContext().getAuthentication().getName();
        User approver = userRepository.findByEmail(currentUserEmail)
                .orElseThrow(() -> new RuntimeException("Approver not found"));

        registration.setStatus(RegistrationStatus.REJECTED);
        registration.setNotes(request.getNotes());
        registration.setApprovedBy(approver);
        registration.setApprovedDate(LocalDateTime.now());

        registration = registrationRepository.save(registration);
        return mapToRegistrationResponse(registration);
    }

    @Override
    @Transactional
    public void deleteRegistration(String id) {
        BenefitRegistration registration = registrationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Registration not found"));

        if (registration.getStatus() != RegistrationStatus.PENDING) {
            throw new RuntimeException("Only pending registrations can be deleted");
        }

        registrationRepository.delete(registration);
    }

    private RegistrationResponse mapToRegistrationResponse(BenefitRegistration registration) {
        return RegistrationResponse.builder()
                .id(registration.getId())
                .employee(mapToEmployeeResponse(registration.getEmployee()))
                .benefit(mapToBenefitPackageResponse(registration.getBenefit()))
                .amount(registration.getAmount())
                .requestDate(registration.getRequestDate())
                .status(registration.getStatus())
                .notes(registration.getNotes())
                .approvedBy(registration.getApprovedBy() != null ? registration.getApprovedBy().getEmail() : null)
                .approvedDate(registration.getApprovedDate())
                .createdAt(registration.getCreatedAt())
                .updatedAt(registration.getUpdatedAt())
                .build();
    }

    private com.soict.benefit_employees.dto.employee.EmployeeResponse mapToEmployeeResponse(Employee employee) {
        return com.soict.benefit_employees.dto.employee.EmployeeResponse.builder()
                .id(employee.getId())
                .fullName(employee.getFullName())
                .email(employee.getUser().getEmail())
                .department(employee.getDepartment())
                .position(employee.getPosition())
                .employeeCode(employee.getEmployeeCode())
                .status(employee.getStatus())
                .build();
    }

    private com.soict.benefit_employees.dto.benefit.BenefitPackageResponse mapToBenefitPackageResponse(BenefitPackage benefit) {
        return com.soict.benefit_employees.dto.benefit.BenefitPackageResponse.builder()
                .id(benefit.getId())
                .name(benefit.getName())
                .type(benefit.getType())
                .description(benefit.getDescription())
                .maxAmount(benefit.getMaxAmount())
                .isActive(benefit.isActive())
                .build();
    }
}