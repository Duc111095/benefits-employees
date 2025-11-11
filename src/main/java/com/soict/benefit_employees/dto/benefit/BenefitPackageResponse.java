package com.soict.benefit_employees.dto.benefit;

import com.soict.benefit_employees.entity.BenefitType;
import lombok.Builder;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
public class BenefitPackageResponse {
    private String id;
    private String name;
    private BenefitType type;
    private String description;
    private BigDecimal maxAmount;
    private boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}