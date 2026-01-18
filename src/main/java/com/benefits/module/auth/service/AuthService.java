package com.benefits.module.auth.service;

import com.benefits.common.Constants;
import com.benefits.module.auth.entity.User;
import com.benefits.module.auth.repository.UserRepository;
import com.benefits.module.employee.entity.Employee;
import com.benefits.module.employee.repository.EmployeeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final EmployeeRepository employeeRepository;
    private final PasswordEncoder passwordEncoder;

    public User getCurrentUser() {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String username;
        if (principal instanceof UserDetails) {
            username = ((UserDetails) principal).getUsername();
        } else {
            username = principal.toString();
        }
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Authenticated user not found in database"));
    }

    @Transactional
    public User registerEmployee(String employeeCode, String username, String password, String email) {
        // 1. Verify Employee Code exists
        Employee employee = employeeRepository.findByEmployeeCode(employeeCode)
                .orElseThrow(() -> new IllegalArgumentException("Invalid Employee Code. Please contact HR."));

        // 2. Verify Employee doesn't already have a user account
        if (userRepository.findAll().stream()
                .anyMatch(u -> u.getEmployee() != null && u.getEmployee().getId().equals(employee.getId()))) {
            throw new IllegalArgumentException("Account already exists for this Employee Code.");
        }

        // 3. Verify Username and Email are unique
        if (userRepository.existsByUsername(username)) {
            throw new IllegalArgumentException("Username already taken.");
        }
        if (userRepository.existsByEmail(email)) {
            throw new IllegalArgumentException("Email already taken.");
        }

        // 4. Create User
        User user = new User();
        user.setUsername(username);
        user.setPassword(passwordEncoder.encode(password));
        user.setEmail(email);
        user.setRole(Constants.ROLE_EMPLOYEE);
        user.setEmployee(employee);
        user.setActive(true);

        User savedUser = userRepository.save(user);

        // 5. Simulated Email Confirmation
        System.out.println("SIMULATED MAIL: Confirmation email sent to " + email + " for user " + username);

        return savedUser;
    }

    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    public boolean validateUser(String username, String password) {
        Optional<User> userOpt = userRepository.findByUsername(username);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            return user.getActive() && passwordEncoder.matches(password, user.getPassword());
        }
        return false;
    }

    @Transactional
    public User createUser(String username, String password, String email, String role) {
        if (userRepository.existsByUsername(username)) {
            throw new IllegalArgumentException("Username already exists");
        }
        if (userRepository.existsByEmail(email)) {
            throw new IllegalArgumentException("Email already exists");
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(passwordEncoder.encode(password));
        user.setEmail(email);
        user.setRole(role);
        user.setActive(true);

        return userRepository.save(user);
    }

    @Transactional
    public User createUser(User user) {
        if (userRepository.existsByUsername(user.getUsername())) {
            throw new IllegalArgumentException("Username already exists");
        }
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new IllegalArgumentException("Email already exists");
        }

        user.setPassword(passwordEncoder.encode(user.getPassword()));
        return userRepository.save(user);
    }

    @Transactional
    public void changePassword(Long userId, String oldPassword, String newPassword) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            throw new IllegalArgumentException("Old password is incorrect");
        }

        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }
}
