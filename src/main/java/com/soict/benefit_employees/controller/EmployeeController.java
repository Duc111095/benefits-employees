package com.soict.benefit_employees.controller;

import com.soict.benefit_employees.dto.employee.CreateEmployeeRequest;
import com.soict.benefit_employees.dto.employee.EmployeeResponse;
import com.soict.benefit_employees.entity.EmployeeStatus;
import com.soict.benefit_employees.service.EmployeeService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/employees")
@RequiredArgsConstructor
public class EmployeeController {
    private final EmployeeService employeeService;

    @PostMapping
    @PreAuthorize("hasRole('ADMIN') or hasRole('HR')")
    public ResponseEntity<EmployeeResponse> createEmployee(@Valid @RequestBody CreateEmployeeRequest request) {
        return ResponseEntity.ok(employeeService.createEmployee(request));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('HR') or @securityUtils.isCurrentUser(#id)")
    public ResponseEntity<EmployeeResponse> getEmployee(@PathVariable String id) {
        return ResponseEntity.ok(employeeService.getEmployee(id));
    }

    @GetMapping("/email/{email}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('HR')")
    public ResponseEntity<EmployeeResponse> getEmployeeByEmail(@PathVariable String email) {
        return ResponseEntity.ok(employeeService.getEmployeeByEmail(email));
    }

    @GetMapping
    @PreAuthorize("hasRole('ADMIN') or hasRole('HR')")
    public ResponseEntity<Page<EmployeeResponse>> getAllEmployees(Pageable pageable) {
        return ResponseEntity.ok(employeeService.getAllEmployees(pageable));
    }

    @GetMapping("/department/{department}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('HR')")
    public ResponseEntity<Page<EmployeeResponse>> getEmployeesByDepartment(
            @PathVariable String department, Pageable pageable) {
        return ResponseEntity.ok(employeeService.getEmployeesByDepartment(department, pageable));
    }

    @GetMapping("/status/{status}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('HR')")
    public ResponseEntity<Page<EmployeeResponse>> getEmployeesByStatus(
            @PathVariable EmployeeStatus status, Pageable pageable) {
        return ResponseEntity.ok(employeeService.getEmployeesByStatus(status, pageable));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('HR')")
    public ResponseEntity<EmployeeResponse> updateEmployee(
            @PathVariable String id, @Valid @RequestBody CreateEmployeeRequest request) {
        return ResponseEntity.ok(employeeService.updateEmployee(id, request));
    }

    @PatchMapping("/{id}/status")
    @PreAuthorize("hasRole('ADMIN') or hasRole('HR')")
    public ResponseEntity<EmployeeResponse> updateEmployeeStatus(
            @PathVariable String id, @RequestParam EmployeeStatus status) {
        return ResponseEntity.ok(employeeService.updateEmployeeStatus(id, status));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteEmployee(@PathVariable String id) {
        employeeService.deleteEmployee(id);
        return ResponseEntity.ok().build();
    }
}