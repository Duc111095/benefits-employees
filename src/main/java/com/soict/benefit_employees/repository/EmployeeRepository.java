package com.soict.benefit_employees.repository;

import com.soict.benefit_employees.entity.Employee;
import com.soict.benefit_employees.entity.EmployeeStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface EmployeeRepository extends JpaRepository<Employee, String> {
    Optional<Employee> findByUserEmail(String email);
    Page<Employee> findByDepartment(String department, Pageable pageable);
    Page<Employee> findByStatus(EmployeeStatus status, Pageable pageable);
    Optional<Employee> findByEmployeeCode(String employeeCode);
    boolean existsByEmployeeCode(String employeeCode);
}