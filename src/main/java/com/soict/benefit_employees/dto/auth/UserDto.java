package com.soict.benefit_employees.dto.auth;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UserDto {
    private String id;

    private String email;

    private String password;

    private String role;
}
