package com.soict.benefit_employees.service;

import com.soict.benefit_employees.dto.employee.CreateEmployeeRequest;
import com.soict.benefit_employees.entity.Employee;
import com.soict.benefit_employees.entity.EmployeeStatus;
import com.soict.benefit_employees.entity.Role;
import com.soict.benefit_employees.entity.User;
import com.soict.benefit_employees.repository.EmployeeRepository;
import com.soict.benefit_employees.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;

import java.math.BigDecimal;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@ActiveProfiles("test")
class EmployeeServiceTest {

    @Autowired
    private EmployeeService employeeService;

    @MockBean
    private EmployeeRepository employeeRepository;

    @MockBean
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    private CreateEmployeeRequest createEmployeeRequest;
    private User testUser;
    private Employee testEmployee;

    @BeforeEach
    void setUp() {
        // Create test user
        testUser = User.builder()
                .id("1")
                .email("test@example.com")
                .password(passwordEncoder.encode("password"))
                .role(Role.ROLE_EMPLOYEE)
                .build();

        // Create test employee
        testEmployee = Employee.builder()
                .id("1")
                .user(testUser)
                .fullName("Test Employee")
                .department("IT")
                .position("Developer")
                .phone("1234567890")
                .salary(BigDecimal.valueOf(5000))
                .status(EmployeeStatus.ACTIVE)
                .employeeCode("EMP001")
                .build();

        // Create employee request
        createEmployeeRequest = new CreateEmployeeRequest();
        createEmployeeRequest.setEmail("test@example.com");
        createEmployeeRequest.setPassword("password");
        createEmployeeRequest.setFullName("Test Employee");
        createEmployeeRequest.setDepartment("IT");
        createEmployeeRequest.setPosition("Developer");
        createEmployeeRequest.setPhone("1234567890");
        createEmployeeRequest.setSalary(BigDecimal.valueOf(5000));
        createEmployeeRequest.setEmployeeCode("EMP001");
    }

    @Test
    void whenCreateValidEmployee_thenSuccess() {
        // Mock repositories
        when(userRepository.existsByEmail(any())).thenReturn(false);
        when(userRepository.save(any())).thenReturn(testUser);
        when(employeeRepository.save(any())).thenReturn(testEmployee);

        // Create employee
        var result = employeeService.createEmployee(createEmployeeRequest);

        // Verify result
        assertNotNull(result);
        assertEquals(testEmployee.getId(), result.getId());
        assertEquals(testEmployee.getFullName(), result.getFullName());
        assertEquals(testEmployee.getUser().getEmail(), result.getEmail());
        assertEquals(testEmployee.getDepartment(), result.getDepartment());
        assertEquals(testEmployee.getPosition(), result.getPosition());
        assertEquals(testEmployee.getPhone(), result.getPhone());
        assertEquals(testEmployee.getSalary(), result.getSalary());
        assertEquals(testEmployee.getStatus(), result.getStatus());
        assertEquals(testEmployee.getEmployeeCode(), result.getEmployeeCode());
    }

    @Test
    void whenEmailExists_thenThrowException() {
        // Mock repository to return true for email exists
        when(userRepository.existsByEmail(any())).thenReturn(true);

        // Verify that exception is thrown
        assertThrows(RuntimeException.class, () -> employeeService.createEmployee(createEmployeeRequest));
    }

    @Test
    void whenGetExistingEmployee_thenSuccess() {
        // Mock repository
        when(employeeRepository.findById(testEmployee.getId()))
                .thenReturn(Optional.of(testEmployee));

        // Get employee
        var result = employeeService.getEmployee(testEmployee.getId());

        // Verify result
        assertNotNull(result);
        assertEquals(testEmployee.getId(), result.getId());
        assertEquals(testEmployee.getFullName(), result.getFullName());
        assertEquals(testEmployee.getUser().getEmail(), result.getEmail());
    }

    @Test
    void whenGetNonExistingEmployee_thenThrowException() {
        // Mock repository
        when(employeeRepository.findById(any())).thenReturn(Optional.empty());

        // Verify that exception is thrown
        assertThrows(RuntimeException.class, () -> employeeService.getEmployee("non-existing-id"));
    }

    @Test
    void whenUpdateEmployeeStatus_thenSuccess() {
        // Mock repository
        when(employeeRepository.findById(testEmployee.getId()))
                .thenReturn(Optional.of(testEmployee));
        when(employeeRepository.save(any())).thenReturn(testEmployee);

        // Update status
        var result = employeeService.updateEmployeeStatus(testEmployee.getId(), EmployeeStatus.INACTIVE);

        // Verify result
        assertNotNull(result);
        assertEquals(EmployeeStatus.INACTIVE, result.getStatus());
    }
}