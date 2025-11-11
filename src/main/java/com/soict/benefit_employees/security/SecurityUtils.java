package com.soict.benefit_employees.security;

import com.soict.benefit_employees.repository.BenefitRegistrationRepository;
import com.soict.benefit_employees.repository.EmployeeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

@Component("securityUtils")
@RequiredArgsConstructor
public class SecurityUtils {
    private final EmployeeRepository employeeRepository;
    private final BenefitRegistrationRepository registrationRepository;

    public boolean isCurrentUser(String employeeId) {
        String currentUserEmail = SecurityContextHolder.getContext().getAuthentication().getName();
        return employeeRepository.findById(employeeId)
                .map(employee -> employee.getUser().getEmail().equals(currentUserEmail))
                .orElse(false);
    }

    public boolean isRegistrationOwner(String registrationId) {
        String currentUserEmail = SecurityContextHolder.getContext().getAuthentication().getName();
        return registrationRepository.findById(registrationId)
                .map(registration -> registration.getEmployee().getUser().getEmail().equals(currentUserEmail))
                .orElse(false);
    }
}