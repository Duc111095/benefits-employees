package com.soict.benefit_employees.service;

import com.soict.benefit_employees.dto.employee.CreateEmployeeRequest;
import com.soict.benefit_employees.dto.employee.EmployeeResponse;
import com.soict.benefit_employees.entity.EmployeeStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface EmployeeService {
    EmployeeResponse createEmployee(CreateEmployeeRequest request);
    EmployeeResponse getEmployee(String id);
    EmployeeResponse getEmployeeByEmail(String email);
    Page<EmployeeResponse> getAllEmployees(Pageable pageable);
    Page<EmployeeResponse> getEmployeesByDepartment(String department, Pageable pageable);
    Page<EmployeeResponse> getEmployeesByStatus(EmployeeStatus status, Pageable pageable);
    EmployeeResponse updateEmployee(String id, CreateEmployeeRequest request);
    EmployeeResponse updateEmployeeStatus(String id, EmployeeStatus status);
    void deleteEmployee(String id);
}