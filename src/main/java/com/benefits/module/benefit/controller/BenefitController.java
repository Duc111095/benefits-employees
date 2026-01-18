package com.benefits.module.benefit.controller;

import com.benefits.module.benefit.entity.BenefitPlan;
import com.benefits.module.benefit.entity.BenefitType;
import com.benefits.module.benefit.service.BenefitService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/benefit")
@RequiredArgsConstructor
public class BenefitController {

    private final BenefitService benefitService;

    // --- Benefit Types ---

    @GetMapping("/types")
    public String listBenefitTypes(Model model) {
        model.addAttribute("benefitTypes", benefitService.getAllBenefitTypes());
        return "benefit/benefit-type-list";
    }

    @GetMapping("/types/new")
    public String showTypeForm(Model model) {
        model.addAttribute("benefitType", new BenefitType());
        model.addAttribute("isEdit", false);
        return "benefit/benefit-type-form";
    }

    @PostMapping("/types/save")
    public String saveBenefitType(@ModelAttribute BenefitType benefitType, RedirectAttributes redirectAttributes) {
        try {
            benefitService.saveBenefitType(benefitType);
            redirectAttributes.addFlashAttribute("success", "Benefit type saved successfully");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/benefit/types";
    }

    @GetMapping("/types/edit/{id}")
    public String showEditTypeForm(@PathVariable Long id, Model model) {
        return benefitService.getBenefitTypeById(id)
                .map(type -> {
                    model.addAttribute("benefitType", type);
                    model.addAttribute("isEdit", true);
                    return "benefit/benefit-type-form";
                }).orElse("redirect:/benefit/types");
    }

    // --- Benefit Plans ---

    @GetMapping("/plans")
    public String listBenefitPlans(Model model,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Long typeId,
            @RequestParam(required = false) Boolean active) {
        model.addAttribute("benefitPlans", benefitService.searchBenefitPlans(keyword, typeId, active));
        model.addAttribute("benefitTypes", benefitService.getAllBenefitTypes());
        model.addAttribute("keyword", keyword);
        model.addAttribute("selectedType", typeId);
        model.addAttribute("selectedStatus", active);
        return "benefit/benefit-plan-list";
    }

    @GetMapping("/plans/new")
    public String showPlanForm(Model model) {
        model.addAttribute("benefitPlan", new BenefitPlan());
        model.addAttribute("benefitTypes", benefitService.getActiveBenefitTypes());
        model.addAttribute("isEdit", false);
        return "benefit/benefit-plan-form";
    }

    @GetMapping("/plans/edit/{id}")
    public String showEditPlanForm(@PathVariable Long id, Model model) {
        return benefitService.getBenefitPlanById(id)
                .map(plan -> {
                    model.addAttribute("benefitPlan", plan);
                    model.addAttribute("benefitTypes", benefitService.getActiveBenefitTypes());
                    model.addAttribute("isEdit", true);
                    return "benefit/benefit-plan-form";
                }).orElse("redirect:/benefit/plans");
    }

    @PostMapping("/plans/save")
    public String saveBenefitPlan(@ModelAttribute BenefitPlan benefitPlan, RedirectAttributes redirectAttributes) {
        try {
            benefitService.saveBenefitPlan(benefitPlan);
            redirectAttributes.addFlashAttribute("success", "Benefit plan saved successfully");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/benefit/plans";
    }
}
