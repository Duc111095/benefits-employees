package com.benefits.module.benefit.service;

import com.benefits.module.benefit.repository.BenefitBalanceRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;

@Service
@RequiredArgsConstructor
public class BalanceService {

    private final BenefitBalanceRepository benefitBalanceRepository;

    public BigDecimal getRemainingBalance(Long employeeId, Long benefitTypeId) {
        return benefitBalanceRepository.getRemainingBalance(employeeId, benefitTypeId);
    }
}
