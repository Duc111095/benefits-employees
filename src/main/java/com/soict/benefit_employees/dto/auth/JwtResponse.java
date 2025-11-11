package com.soict.benefit_employees.dto.auth;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class JwtResponse {
    private String token;
    private String refreshToken;
    private String type;
    private UserDto user;
}