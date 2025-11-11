package com.soict.benefit_employees.service;

import com.soict.benefit_employees.dto.auth.JwtResponse;
import com.soict.benefit_employees.dto.auth.LoginRequest;
import com.soict.benefit_employees.dto.auth.RegisterRequest;
import com.soict.benefit_employees.dto.auth.TokenRefreshRequest;

public interface AuthService {
    JwtResponse register(RegisterRequest registerRequest);
    JwtResponse login(LoginRequest loginRequest);
    JwtResponse refreshToken(TokenRefreshRequest request);
    void logout(String email);
}