package com.soict.benefit_employees.repository;

import com.soict.benefit_employees.entity.BenefitRegistration;
import com.soict.benefit_employees.entity.RegistrationStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BenefitRegistrationRepository extends JpaRepository<BenefitRegistration, String> {
    Page<BenefitRegistration> findByEmployeeId(String employeeId, Pageable pageable);
    Page<BenefitRegistration> findByStatus(RegistrationStatus status, Pageable pageable);
    Page<BenefitRegistration> findByBenefitId(String benefitId, Pageable pageable);
}