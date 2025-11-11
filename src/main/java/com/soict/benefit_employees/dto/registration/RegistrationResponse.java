package com.soict.benefit_employees.dto.registration;

import com.soict.benefit_employees.dto.benefit.BenefitPackageResponse;
import com.soict.benefit_employees.dto.employee.EmployeeResponse;
import com.soict.benefit_employees.entity.RegistrationStatus;
import lombok.Builder;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
public class RegistrationResponse {
    private String id;
    private EmployeeResponse employee;
    private BenefitPackageResponse benefit;
    private BigDecimal amount;
    private LocalDateTime requestDate;
    private RegistrationStatus status;
    private String notes;
    private String approvedBy;
    private LocalDateTime approvedDate;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}