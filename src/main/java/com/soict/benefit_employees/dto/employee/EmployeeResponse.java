package com.soict.benefit_employees.dto.employee;

import com.soict.benefit_employees.entity.EmployeeStatus;
import lombok.Builder;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
public class EmployeeResponse {
    private String id;
    private String fullName;
    private String email;
    private String department;
    private String position;
    private String phone;
    private BigDecimal salary;
    private EmployeeStatus status;
    private String avatar;
    private String employeeCode;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}