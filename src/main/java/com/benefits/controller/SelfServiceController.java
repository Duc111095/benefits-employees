package com.benefits.controller;

import com.benefits.module.auth.entity.User;
import com.benefits.module.auth.repository.UserRepository;
import com.benefits.module.benefit.service.BenefitService;
import com.benefits.module.claim.entity.BenefitClaim;
import com.benefits.module.claim.service.ClaimService;
import com.benefits.module.employee.entity.Employee;
import com.benefits.module.enrollment.entity.Enrollment;
import com.benefits.module.enrollment.service.EnrollmentService;
import com.benefits.common.Constants;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.UUID;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/self-service")
@RequiredArgsConstructor
public class SelfServiceController {

    private final EnrollmentService enrollmentService;
    private final ClaimService claimService;
    private final BenefitService benefitService;
    private final UserRepository userRepository;

    private static final String UPLOAD_DIR = "uploads/claims/";

    private Employee getCurrentEmployee(UserDetails userDetails) {
        User user = userRepository.findByUsername(userDetails.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found"));
        return user.getEmployee();
    }

    private User getCurrentUser(UserDetails userDetails) {
        return userRepository.findByUsername(userDetails.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    @GetMapping("/benefits")
    public String myBenefits(Model model, @AuthenticationPrincipal UserDetails userDetails) {
        Employee employee = getCurrentEmployee(userDetails);
        if (employee == null) {
            model.addAttribute("error", "No employee record linked to your user account.");
            return "dashboard";
        }
        model.addAttribute("enrollments", enrollmentService.getEnrollmentsByEmployee(employee.getId()));
        model.addAttribute("availablePlans", benefitService.getActiveBenefitPlans());
        return "self-service/my-benefits";
    }

    @GetMapping("/claims")
    public String myClaims(Model model, @AuthenticationPrincipal UserDetails userDetails) {
        Employee employee = getCurrentEmployee(userDetails);
        if (employee == null)
            return "redirect:/dashboard";

        model.addAttribute("claims", claimService.getAllClaims().stream()
                .filter(c -> c.getEmployee().getId().equals(employee.getId()))
                .toList());

        // Provide active enrollments for the dropdown
        model.addAttribute("activeEnrollments", enrollmentService.getEnrollmentsByEmployee(employee.getId()).stream()
                .filter(e -> e.getStatus().equals(Constants.ENROLLMENT_STATUS_ACTIVE))
                .collect(Collectors.toList()));

        return "self-service/my-claims";
    }

    @GetMapping("/profile")
    public String myProfile(Model model, @AuthenticationPrincipal UserDetails userDetails) {
        Employee employee = getCurrentEmployee(userDetails);
        if (employee == null)
            return "redirect:/dashboard";

        model.addAttribute("employee", employee);
        return "self-service/my-profile";
    }

    @PostMapping("/claim/save")
    public String saveClaim(@ModelAttribute BenefitClaim claim,
            @RequestParam("enrollmentId") Long enrollmentId,
            @RequestParam("attachment") MultipartFile attachment,
            @AuthenticationPrincipal UserDetails userDetails,
            RedirectAttributes redirectAttributes) {

        Employee employee = getCurrentEmployee(userDetails);
        User user = getCurrentUser(userDetails);

        if (employee == null)
            return "redirect:/dashboard";

        // Set mandatory fields
        claim.setEmployee(employee);
        claim.setSubmittedBy(user);
        claim.setClaimDate(LocalDate.now()); // Default to today if not provided by form

        // Set enrollment
        Enrollment enrollment = new Enrollment();
        enrollment.setId(enrollmentId);
        claim.setEnrollment(enrollment);

        // Handle file upload
        if (!attachment.isEmpty()) {
            try {
                Path uploadPath = Paths.get(UPLOAD_DIR);
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }

                String filename = UUID.randomUUID().toString() + "_" + attachment.getOriginalFilename();
                Path filePath = uploadPath.resolve(filename);
                Files.copy(attachment.getInputStream(), filePath);

                claim.setAttachmentPath(filePath.toString());
            } catch (IOException e) {
                redirectAttributes.addFlashAttribute("error", "Failed to upload attachment: " + e.getMessage());
                return "redirect:/self-service/claims";
            }
        }

        try {
            claimService.submitClaim(claim);
            redirectAttributes.addFlashAttribute("success", "Claim submitted successfully and is pending approval.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/self-service/claims";
    }

    @PostMapping("/enrollment/request")
    public String requestEnrollment(@RequestParam("planId") Long planId,
            @RequestParam(value = "notes", required = false) String notes,
            @AuthenticationPrincipal UserDetails userDetails, RedirectAttributes redirectAttributes) {
        Employee employee = getCurrentEmployee(userDetails);
        if (employee == null)
            return "redirect:/dashboard";

        try {
            enrollmentService.requestEnrollment(employee.getId(), planId, notes);
            redirectAttributes.addFlashAttribute("success",
                    "Enrollment request submitted successfully and is pending approval.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/self-service/benefits";
    }
}
