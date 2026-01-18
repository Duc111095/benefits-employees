package com.benefits.module.employee.service;

import com.benefits.common.Constants;
import com.benefits.module.auth.repository.UserRepository;
import com.benefits.module.employee.entity.Employee;
import com.benefits.module.employee.repository.EmployeeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class EmployeeService {

    private final EmployeeRepository employeeRepository;
    private final UserRepository userRepository;

    public List<Employee> getAllEmployees() {
        return employeeRepository.findAll();
    }

    public Optional<Employee> getEmployeeById(Long id) {
        return employeeRepository.findById(id);
    }

    public Optional<Employee> getEmployeeByCode(String code) {
        return employeeRepository.findByEmployeeCode(code);
    }

    public List<Employee> getEmployeesByDepartment(Long departmentId) {
        return employeeRepository.findByDepartmentId(departmentId);
    }

    public List<Employee> searchEmployees(String keyword, Long departmentId, String position, String status) {
        return employeeRepository.searchEmployees(keyword, departmentId, position, status);
    }

    @Transactional
    public Employee createEmployee(Employee employee) {
        if (employeeRepository.existsByEmployeeCode(employee.getEmployeeCode())) {
            throw new IllegalArgumentException("Employee code already exists: " + employee.getEmployeeCode());
        }
        if (employeeRepository.existsByEmail(employee.getEmail())) {
            throw new IllegalArgumentException("Email already exists: " + employee.getEmail());
        }
        return employeeRepository.save(employee);
    }

    @Transactional
    public Employee updateEmployee(Long id, Employee employeeDetails) {
        Employee employee = employeeRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Employee not found with id: " + id));

        // Check if code/email is being changed and if new values already exist
        if (!employee.getEmployeeCode().equals(employeeDetails.getEmployeeCode()) &&
                employeeRepository.existsByEmployeeCode(employeeDetails.getEmployeeCode())) {
            throw new IllegalArgumentException("Employee code already exists: " + employeeDetails.getEmployeeCode());
        }

        if (!employee.getEmail().equals(employeeDetails.getEmail()) &&
                employeeRepository.existsByEmail(employeeDetails.getEmail())) {
            throw new IllegalArgumentException("Email already exists: " + employeeDetails.getEmail());
        }

        String oldStatus = employee.getStatus();

        employee.setEmployeeCode(employeeDetails.getEmployeeCode());
        employee.setFullName(employeeDetails.getFullName());
        employee.setEmail(employeeDetails.getEmail());
        employee.setPhone(employeeDetails.getPhone());
        employee.setDateOfBirth(employeeDetails.getDateOfBirth());
        employee.setHireDate(employeeDetails.getHireDate());
        employee.setDepartment(employeeDetails.getDepartment());
        employee.setPosition(employeeDetails.getPosition());
        employee.setGender(employeeDetails.getGender());
        employee.setAddress(employeeDetails.getAddress());
        employee.setBasicSalary(employeeDetails.getBasicSalary());
        employee.setStatus(employeeDetails.getStatus());

        Employee saved = employeeRepository.save(employee);

        // Lifecycle: If status changed to INACTIVE or TERMINATED, disable user account
        if ((Constants.EMPLOYEE_STATUS_INACTIVE.equals(saved.getStatus()) ||
                Constants.EMPLOYEE_STATUS_TERMINATED.equals(saved.getStatus())) &&
                !saved.getStatus().equals(oldStatus)) {
            userRepository.findByEmployeeId(saved.getId()).ifPresent(u -> {
                u.setActive(false);
                userRepository.save(u);
            });
        }

        return saved;
    }

    @Transactional
    public void deleteEmployee(Long id) {
        if (!employeeRepository.existsById(id)) {
            throw new IllegalArgumentException("Employee not found with id: " + id);
        }
        // Before deleting employee, handle associated user
        userRepository.findByEmployeeId(id).ifPresent(u -> {
            u.setEmployee(null);
            userRepository.save(u);
        });
        employeeRepository.deleteById(id);
    }
}
