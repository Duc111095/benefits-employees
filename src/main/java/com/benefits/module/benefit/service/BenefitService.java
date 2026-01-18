package com.benefits.module.benefit.service;

import com.benefits.module.benefit.entity.BenefitPlan;
import com.benefits.module.benefit.entity.BenefitType;
import com.benefits.module.benefit.repository.BenefitPlanRepository;
import com.benefits.module.benefit.repository.BenefitTypeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class BenefitService {

    private final BenefitTypeRepository benefitTypeRepository;
    private final BenefitPlanRepository benefitPlanRepository;

    // Benefit Type methods
    public List<BenefitType> getAllBenefitTypes() {
        return benefitTypeRepository.findAll();
    }

    public List<BenefitType> getActiveBenefitTypes() {
        return benefitTypeRepository.findByActiveTrue();
    }

    public Optional<BenefitType> getBenefitTypeById(Long id) {
        return benefitTypeRepository.findById(id);
    }

    @Transactional
    public BenefitType saveBenefitType(BenefitType type) {
        if (type.getId() == null && benefitTypeRepository.existsByCode(type.getCode())) {
            throw new IllegalArgumentException("Benefit type code already exists: " + type.getCode());
        }
        return benefitTypeRepository.save(type);
    }

    @Transactional
    public void deleteBenefitType(Long id) {
        benefitTypeRepository.deleteById(id);
    }

    // Benefit Plan methods
    public List<BenefitPlan> getAllBenefitPlans() {
        return benefitPlanRepository.findAll();
    }

    public List<BenefitPlan> searchBenefitPlans(String keyword, Long typeId, Boolean active) {
        return benefitPlanRepository.searchPlans(keyword, typeId, active);
    }

    public List<BenefitPlan> getActiveBenefitPlans() {
        return benefitPlanRepository.findByActiveTrue();
    }

    public Optional<BenefitPlan> getBenefitPlanById(Long id) {
        return benefitPlanRepository.findById(id);
    }

    @Transactional
    public BenefitPlan saveBenefitPlan(BenefitPlan plan) {
        if (plan.getId() == null && benefitPlanRepository.existsByPlanCode(plan.getPlanCode())) {
            throw new IllegalArgumentException("Benefit plan code already exists: " + plan.getPlanCode());
        }
        return benefitPlanRepository.save(plan);
    }

    @Transactional
    public void deleteBenefitPlan(Long id) {
        benefitPlanRepository.deleteById(id);
    }
}
