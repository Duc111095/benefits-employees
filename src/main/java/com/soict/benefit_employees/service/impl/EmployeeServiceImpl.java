package com.soict.benefit_employees.service.impl;

import com.soict.benefit_employees.dto.employee.CreateEmployeeRequest;
import com.soict.benefit_employees.dto.employee.EmployeeResponse;
import com.soict.benefit_employees.entity.Employee;
import com.soict.benefit_employees.entity.EmployeeStatus;
import com.soict.benefit_employees.entity.Role;
import com.soict.benefit_employees.entity.User;
import com.soict.benefit_employees.repository.EmployeeRepository;
import com.soict.benefit_employees.repository.UserRepository;
import com.soict.benefit_employees.service.EmployeeService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class EmployeeServiceImpl implements EmployeeService {
    private final EmployeeRepository employeeRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    @Transactional
    public EmployeeResponse createEmployee(CreateEmployeeRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email is already in use");
        }

        User user = User.builder()
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .role(Role.ROLE_EMPLOYEE)
                .build();
        user = userRepository.save(user);

        Employee employee = Employee.builder()
                .user(user)
                .fullName(request.getFullName())
                .department(request.getDepartment())
                .position(request.getPosition())
                .phone(request.getPhone())
                .salary(request.getSalary())
                .status(EmployeeStatus.ACTIVE)
                .avatar(request.getAvatar())
                .employeeCode(request.getEmployeeCode())
                .build();
        
        employee = employeeRepository.save(employee);
        return mapToEmployeeResponse(employee);
    }

    @Override
    @Transactional(readOnly = true)
    public EmployeeResponse getEmployee(String id) {
        Employee employee = employeeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Employee not found"));
        return mapToEmployeeResponse(employee);
    }

    @Override
    @Transactional(readOnly = true)
    public EmployeeResponse getEmployeeByEmail(String email) {
        Employee employee = employeeRepository.findByUserEmail(email)
                .orElseThrow(() -> new RuntimeException("Employee not found"));
        return mapToEmployeeResponse(employee);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<EmployeeResponse> getAllEmployees(Pageable pageable) {
        return employeeRepository.findAll(pageable)
                .map(this::mapToEmployeeResponse);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<EmployeeResponse> getEmployeesByDepartment(String department, Pageable pageable) {
        return employeeRepository.findByDepartment(department, pageable)
                .map(this::mapToEmployeeResponse);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<EmployeeResponse> getEmployeesByStatus(EmployeeStatus status, Pageable pageable) {
        return employeeRepository.findByStatus(status, pageable)
                .map(this::mapToEmployeeResponse);
    }

    @Override
    @Transactional
    public EmployeeResponse updateEmployee(String id, CreateEmployeeRequest request) {
        Employee employee = employeeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Employee not found"));

        // Update user email if changed
        if (!employee.getUser().getEmail().equals(request.getEmail())) {
            if (userRepository.existsByEmail(request.getEmail())) {
                throw new RuntimeException("Email is already in use");
            }
            employee.getUser().setEmail(request.getEmail());
        }

        // Update password if provided
        if (request.getPassword() != null && !request.getPassword().isEmpty()) {
            employee.getUser().setPassword(passwordEncoder.encode(request.getPassword()));
        }

        employee.setFullName(request.getFullName());
        employee.setDepartment(request.getDepartment());
        employee.setPosition(request.getPosition());
        employee.setPhone(request.getPhone());
        employee.setSalary(request.getSalary());
        employee.setAvatar(request.getAvatar());
        employee.setEmployeeCode(request.getEmployeeCode());

        employee = employeeRepository.save(employee);
        return mapToEmployeeResponse(employee);
    }

    @Override
    @Transactional
    public EmployeeResponse updateEmployeeStatus(String id, EmployeeStatus status) {
        Employee employee = employeeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Employee not found"));
        employee.setStatus(status);
        employee = employeeRepository.save(employee);
        return mapToEmployeeResponse(employee);
    }

    @Override
    @Transactional
    public void deleteEmployee(String id) {
        Employee employee = employeeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Employee not found"));
        employeeRepository.delete(employee);
        userRepository.delete(employee.getUser());
    }

    private EmployeeResponse mapToEmployeeResponse(Employee employee) {
        return EmployeeResponse.builder()
                .id(employee.getId())
                .fullName(employee.getFullName())
                .email(employee.getUser().getEmail())
                .department(employee.getDepartment())
                .position(employee.getPosition())
                .phone(employee.getPhone())
                .salary(employee.getSalary())
                .status(employee.getStatus())
                .avatar(employee.getAvatar())
                .employeeCode(employee.getEmployeeCode())
                .createdAt(employee.getCreatedAt())
                .updatedAt(employee.getUpdatedAt())
                .build();
    }
}