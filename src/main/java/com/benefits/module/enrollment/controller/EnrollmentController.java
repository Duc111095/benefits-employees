package com.benefits.module.enrollment.controller;

import com.benefits.module.auth.entity.User;
import com.benefits.module.department.service.DepartmentService;
import com.benefits.module.benefit.service.BenefitService;
import com.benefits.module.enrollment.service.EnrollmentService;
import com.benefits.module.enrollment.entity.Enrollment;
import com.benefits.module.auth.service.AuthService;
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
@RequestMapping("/hr/enrollments")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ROLE_HR_MANAGER')")
public class EnrollmentController {

    private final EnrollmentService enrollmentService;
    private final DepartmentService departmentService;
    private final BenefitService benefitService;
    private final AuthService authService;

    @GetMapping
    public String listEnrollments(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Long deptId,
            @RequestParam(required = false) Long typeId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(required = false) String keyword,
            Model model) {

        List<Enrollment> enrollments = enrollmentService.searchEnrollments(status, deptId, typeId, startDate, endDate,
                keyword);

        model.addAttribute("enrollments", enrollments);
        model.addAttribute("departments", departmentService.getAllDepartments());
        model.addAttribute("benefitTypes", benefitService.getAllBenefitTypes());
        model.addAttribute("status", status);
        model.addAttribute("deptId", deptId);
        model.addAttribute("typeId", typeId);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("keyword", keyword);

        return "enrollment/enrollment-list";
    }

    @GetMapping("/{id}")
    public String viewEnrollment(@PathVariable Long id, Model model) {
        model.addAttribute("enrollment", enrollmentService.getEnrollmentById(id));
        return "enrollment/enrollment-detail";
    }

    @PostMapping("/{id}/approve")
    public String approveEnrollment(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            User currentUser = authService.getCurrentUser();
            enrollmentService.approveEnrollment(id, currentUser);
            redirectAttributes.addFlashAttribute("successMsg", "Enrollment approved successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMsg", "Error: " + e.getMessage());
        }
        return "redirect:/hr/enrollments";
    }

    @PostMapping("/{id}/reject")
    public String rejectEnrollment(@PathVariable Long id, @RequestParam String reason,
            RedirectAttributes redirectAttributes) {
        try {
            User currentUser = authService.getCurrentUser();
            enrollmentService.rejectEnrollment(id, reason, currentUser);
            redirectAttributes.addFlashAttribute("successMsg", "Enrollment rejected.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMsg", "Error: " + e.getMessage());
        }
        return "redirect:/hr/enrollments";
    }
}
