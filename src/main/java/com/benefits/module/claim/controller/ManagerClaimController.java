package com.benefits.module.claim.controller;

import com.benefits.module.auth.entity.User;
import com.benefits.module.auth.service.AuthService;
import com.benefits.module.benefit.service.BalanceService;
import com.benefits.module.claim.entity.BenefitClaim;
import com.benefits.module.claim.service.ClaimService;
import com.benefits.module.department.service.DepartmentService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping("/manager/claims")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ROLE_MANAGER')")
public class ManagerClaimController {

    private final ClaimService claimService;
    private final DepartmentService departmentService;
    private final AuthService authService;
    private final BalanceService balanceService;

    @GetMapping
    public String listClaims(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Long deptId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(required = false) String keyword,
            Model model) {

        List<BenefitClaim> claims = claimService.searchClaims(status, deptId, startDate, endDate, keyword);

        model.addAttribute("claims", claims);
        model.addAttribute("departments", departmentService.getAllDepartments());
        model.addAttribute("status", status);
        model.addAttribute("deptId", deptId);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("keyword", keyword);

        return "claim/claim-list";
    }

    @GetMapping("/{id}")
    public String viewClaim(@PathVariable Long id, Model model) {
        model.addAttribute("claim", claimService.getClaimById(id));
        return "claim/claim-detail";
    }

    @PostMapping("/{id}/approve")
    public String approveClaim(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            User currentUser = authService.getCurrentUser();
            claimService.approveClaim(id, currentUser);
            redirectAttributes.addFlashAttribute("successMsg", "Claim approved.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMsg", "Approval failed: " + e.getMessage());
        }
        return "redirect:/manager/claims";
    }

    @PostMapping("/{id}/reject")
    public String rejectClaim(@PathVariable Long id, @RequestParam String reason,
            RedirectAttributes redirectAttributes) {
        try {
            User currentUser = authService.getCurrentUser();
            claimService.rejectClaim(id, reason, currentUser);
            redirectAttributes.addFlashAttribute("successMsg", "Claim rejected.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMsg", "Rejection failed: " + e.getMessage());
        }
        return "redirect:/manager/claims";
    }
}
