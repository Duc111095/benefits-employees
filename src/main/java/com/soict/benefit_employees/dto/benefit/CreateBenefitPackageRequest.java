package com.soict.benefit_employees.dto.benefit;

import com.soict.benefit_employees.entity.BenefitType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;
import java.math.BigDecimal;

@Data
public class CreateBenefitPackageRequest {
    @NotBlank(message = "Name is required")
    private String name;

    @NotNull(message = "Type is required")
    private BenefitType type;

    private String description;

    @NotNull(message = "Maximum amount is required")
    @Positive(message = "Maximum amount must be positive")
    private BigDecimal maxAmount;
}