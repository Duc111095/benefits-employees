package com.soict.benefit_employees.dto.registration;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class UpdateRegistrationRequest {
    @NotBlank(message = "Notes are required")
    private String notes;
}