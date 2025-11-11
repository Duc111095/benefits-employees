package com.soict.benefit_employees.service;

import com.soict.benefit_employees.dto.auth.LoginRequest;
import com.soict.benefit_employees.entity.Role;
import com.soict.benefit_employees.entity.User;
import com.soict.benefit_employees.repository.RefreshTokenRepository;
import com.soict.benefit_employees.repository.UserRepository;
import com.soict.benefit_employees.security.JwtUtils;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import com.soict.benefit_employees.security.UserDetailsImpl;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;

import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.junit.jupiter.api.Assertions.*;
import com.soict.benefit_employees.entity.RefreshToken;
import java.time.LocalDateTime;

@SpringBootTest
@ActiveProfiles("test")
class AuthServiceTest {

    @Autowired
    private AuthService authService;

    @SuppressWarnings("removal")
    @MockBean
    private AuthenticationManager authenticationManager;

    @SuppressWarnings("removal")
    @MockBean
    private UserRepository userRepository;

    @SuppressWarnings("removal")
    @MockBean
    private RefreshTokenRepository refreshTokenRepository;

    @SuppressWarnings("removal")
    @MockBean
    private JwtUtils jwtUtils;

    @Autowired
    private PasswordEncoder passwordEncoder;

    private User testUser;
    private LoginRequest loginRequest;
    private Authentication authentication;

    @BeforeEach
    void setUp() {
        // Create test user
        testUser = User.builder()
                .id("1")
                .email("test@example.com")
                .password(passwordEncoder.encode("password"))
                .role(Role.ROLE_EMPLOYEE)
                .build();

        // Create login request
        loginRequest = new LoginRequest();
        loginRequest.setEmail("test@example.com");
        loginRequest.setPassword("password");

        // Build UserDetails and mock authentication with UserDetails as principal
        UserDetailsImpl userDetails = UserDetailsImpl.build(testUser);
        authentication = new UsernamePasswordAuthenticationToken(
                userDetails,
                null,
                userDetails.getAuthorities()
        );
    }

    @Test
    void whenValidCredentials_thenLoginSuccessful() {
        // Mock authentication manager
        when(authenticationManager.authenticate(any(Authentication.class)))
                .thenReturn(authentication);

        // Mock user repository
        when(userRepository.findByEmail(testUser.getEmail()))
                .thenReturn(Optional.of(testUser));
        when(userRepository.findById(testUser.getId()))
                .thenReturn(Optional.of(testUser));

        // Mock JWT generation
        when(jwtUtils.generateJwtToken(any(Authentication.class)))
                .thenReturn("test.jwt.token");
        // Mock refresh token save
        RefreshToken savedRefresh = RefreshToken.builder()
                .id("rt1")
                .user(testUser)
                .token("refresh-token")
                .expiryDate(LocalDateTime.now().plusDays(7))
                .build();
        when(refreshTokenRepository.save(any())).thenReturn(savedRefresh);

        // Perform login
        var result = authService.login(loginRequest);

        // Verify result
        assertNotNull(result);
        assertEquals("test.jwt.token", result.getToken());
        assertEquals("Bearer", result.getType());
      
    }

    @Test
    void whenInvalidCredentials_thenThrowException() {
        // Mock authentication manager to throw exception
        when(authenticationManager.authenticate(any(Authentication.class)))
                .thenThrow(new RuntimeException("Invalid credentials"));

        // Verify that exception is thrown
        assertThrows(RuntimeException.class, () -> authService.login(loginRequest));
    }
}