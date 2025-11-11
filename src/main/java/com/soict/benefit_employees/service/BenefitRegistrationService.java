package com.soict.benefit_employees.service;

import com.soict.benefit_employees.dto.registration.CreateRegistrationRequest;
import com.soict.benefit_employees.dto.registration.RegistrationResponse;
import com.soict.benefit_employees.dto.registration.UpdateRegistrationRequest;
import com.soict.benefit_employees.entity.RegistrationStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface BenefitRegistrationService {
    RegistrationResponse createRegistration(String employeeId, CreateRegistrationRequest request);
    RegistrationResponse getRegistration(String id);
    Page<RegistrationResponse> getAllRegistrations(Pageable pageable);
    Page<RegistrationResponse> getRegistrationsByEmployee(String employeeId, Pageable pageable);
    Page<RegistrationResponse> getRegistrationsByStatus(RegistrationStatus status, Pageable pageable);
    Page<RegistrationResponse> getRegistrationsByBenefit(String benefitId, Pageable pageable);
    RegistrationResponse approveRegistration(String id, UpdateRegistrationRequest request);
    RegistrationResponse rejectRegistration(String id, UpdateRegistrationRequest request);
    void deleteRegistration(String id);
}