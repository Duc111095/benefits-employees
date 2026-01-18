package com.benefits.module.report.controller;

import com.benefits.module.report.dto.DashboardStatsDTO;
import com.benefits.module.report.service.ReportService;
import com.benefits.module.claim.entity.BenefitClaim;
import com.benefits.module.department.service.DepartmentService;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.InputStreamResource;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping("/manager/reports")
@RequiredArgsConstructor
@PreAuthorize("hasAnyRole('ROLE_HR_MANAGER', 'ROLE_ADMIN', 'ROLE_MANAGER')")
public class ReportController {

    private final ReportService reportService;
    private final DepartmentService departmentService;

    @GetMapping("/dashboard")
    public String showDashboard(Model model) {
        DashboardStatsDTO stats = reportService.getDashboardStats();
        model.addAttribute("stats", stats);
        return "report/dashboard";
    }

    @GetMapping
    public String listReports(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Long deptId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(required = false) String keyword,
            Model model) {

        List<BenefitClaim> claims = reportService.searchReportData(status, deptId, startDate, endDate, keyword);

        model.addAttribute("claims", claims);
        model.addAttribute("departments", departmentService.getAllDepartments());
        model.addAttribute("status", status);
        model.addAttribute("deptId", deptId);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("keyword", keyword);

        return "report/report-list";
    }

    @GetMapping("/export/excel")
    public ResponseEntity<InputStreamResource> exportExcel(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Long deptId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(required = false) String keyword) throws IOException {

        List<BenefitClaim> claims = reportService.searchReportData(status, deptId, startDate, endDate, keyword);
        ByteArrayInputStream in = reportService.exportToExcel(claims);

        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Disposition", "attachment; filename=benefit_report.xlsx");

        return ResponseEntity.ok()
                .headers(headers)
                .contentType(
                        MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"))
                .body(new InputStreamResource(in));
    }

    @GetMapping("/export/pdf")
    public ResponseEntity<InputStreamResource> exportPdf(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Long deptId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(required = false) String keyword) {
        System.out.println("Export PDF");
        System.out.println("status: " + status);
        System.out.println("deptId: " + deptId);
        System.out.println("startDate: " + startDate);
        System.out.println("endDate: " + endDate);
        System.out.println("keyword: " + keyword);
        List<BenefitClaim> claims = reportService.searchReportData(status, deptId, startDate, endDate, keyword);
        ByteArrayInputStream in = reportService.exportToPdf(claims);

        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Disposition", "attachment; filename=benefit_report.pdf");

        return ResponseEntity.ok()
                .headers(headers)
                .contentType(MediaType.APPLICATION_PDF)
                .body(new InputStreamResource(in));
    }
}
