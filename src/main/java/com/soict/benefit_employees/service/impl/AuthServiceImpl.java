package com.soict.benefit_employees.service.impl;

import com.soict.benefit_employees.dto.auth.JwtResponse;
import com.soict.benefit_employees.dto.auth.LoginRequest;
import com.soict.benefit_employees.dto.auth.RegisterRequest;
import com.soict.benefit_employees.dto.auth.TokenRefreshRequest;
import com.soict.benefit_employees.entity.Employee;
import com.soict.benefit_employees.entity.EmployeeStatus;
import com.soict.benefit_employees.entity.RefreshToken;
import com.soict.benefit_employees.entity.Role;
import com.soict.benefit_employees.entity.User;
import com.soict.benefit_employees.repository.EmployeeRepository;
import com.soict.benefit_employees.repository.RefreshTokenRepository;
import com.soict.benefit_employees.repository.UserRepository;
import com.soict.benefit_employees.security.JwtUtils;
import com.soict.benefit_employees.security.UserDetailsImpl;
import com.soict.benefit_employees.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {
    private final AuthenticationManager authenticationManager;
    private final JwtUtils jwtUtils;
    private final UserRepository userRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final EmployeeRepository employeeRepository;
    private final PasswordEncoder passwordEncoder;

    @Value("${app.jwt.refresh-token.expiration}")
    private long refreshTokenExpirationMs;

    @Override
    @Transactional
    public JwtResponse register(RegisterRequest registerRequest) {
        // Check if user already exists
        if (userRepository.existsByEmail(registerRequest.getEmail())) {
            throw new RuntimeException("Email is already registered");
        }

        // Create new user
        User user = User.builder()
                .email(registerRequest.getEmail())
                .password(passwordEncoder.encode(registerRequest.getPassword()))
                .role(Role.ROLE_EMPLOYEE)
                .build();

        User savedUser = userRepository.save(user);

        // Create employee profile
        Employee employee = Employee.builder()
                .user(savedUser)
                .fullName(registerRequest.getFullName())
                .department(registerRequest.getDepartment())
                .status(EmployeeStatus.ACTIVE)
                .employeeCode(UUID.randomUUID().toString())
                .build();

        employeeRepository.save(employee);

        // Generate JWT token
        String jwt = jwtUtils.generateTokenFromEmail(savedUser.getEmail());
        RefreshToken refreshToken = createRefreshToken(savedUser.getId());

        return JwtResponse.builder()
                .token(jwt)
                .refreshToken(refreshToken.getToken())
                .type("Bearer")
                .user(savedUser.toDto())
                .build();
    }

    @Override
    @Transactional
    public JwtResponse login(LoginRequest loginRequest) {
        Authentication authentication = authenticationManager.authenticate(
            new UsernamePasswordAuthenticationToken(loginRequest.getEmail(), loginRequest.getPassword())
        );

        SecurityContextHolder.getContext().setAuthentication(authentication);
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        User user = userRepository.findByEmail(userDetails.getEmail())
                .orElseThrow(() -> new RuntimeException("User not found"));
        String jwt = jwtUtils.generateJwtToken(authentication);
        RefreshToken refreshToken = createRefreshToken(userDetails.getId());

        return JwtResponse.builder()
                .token(jwt)
                .refreshToken(refreshToken.getToken())
                .type("Bearer")
                .user(user.toDto())
                .build();
    }

    @Override
    @Transactional
    public JwtResponse refreshToken(TokenRefreshRequest request) {
        RefreshToken refreshToken = refreshTokenRepository.findByToken(request.getRefreshToken())
                .orElseThrow(() -> new RuntimeException("Refresh token not found"));

        if (refreshToken.getExpiryDate().isBefore(LocalDateTime.now())) {
            refreshTokenRepository.delete(refreshToken);
            throw new RuntimeException("Refresh token was expired");
        }

        String token = jwtUtils.generateTokenFromEmail(refreshToken.getUser().getEmail());

        return JwtResponse.builder()
                .token(token)
                .refreshToken(refreshToken.getToken())
                .type("Bearer")
                .user(refreshToken.getUser().toDto())
                .build();
    }

    @Override
    @Transactional
    public void logout(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));
        refreshTokenRepository.deleteByUser(user);
    }

    private RefreshToken createRefreshToken(String userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        refreshTokenRepository.findByUser(user)
                .ifPresent(refreshTokenRepository::delete);

        RefreshToken refreshToken = RefreshToken.builder()
                .user(user)
                .token(UUID.randomUUID().toString())
                .expiryDate(LocalDateTime.ofInstant(Instant.now().plusMillis(refreshTokenExpirationMs), ZoneId.systemDefault()))
                .build();

        return refreshTokenRepository.save(refreshToken);
    }
}