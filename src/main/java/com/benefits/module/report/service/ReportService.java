package com.benefits.module.report.service;

import com.benefits.module.claim.repository.ClaimRepository;
import com.benefits.module.enrollment.repository.EnrollmentRepository;
import com.benefits.module.report.dto.DashboardStatsDTO;
import com.benefits.module.claim.entity.BenefitClaim;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.UnitValue;
import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ReportService {

    private final EnrollmentRepository enrollmentRepository;
    private final ClaimRepository claimRepository;

    public DashboardStatsDTO getDashboardStats() {
        DashboardStatsDTO.DashboardStatsDTOBuilder builder = DashboardStatsDTO.builder();

        // Basic KPIs
        builder.totalEnrollments(enrollmentRepository.count());
        builder.totalBenefitCost(Optional.ofNullable(claimRepository.getTotalApprovedCost()).orElse(BigDecimal.ZERO));

        // Claim Status Distribution
        Map<String, Long> claimStatusCounts = claimRepository.countByStatus().stream()
                .collect(Collectors.toMap(
                        obj -> (String) obj[0],
                        obj -> (Long) obj[1]));
        builder.claimStatusDistribution(claimStatusCounts);

        // Enrollments by Status
        Map<String, Long> enrollmentStatusCounts = enrollmentRepository.countByStatus().stream()
                .collect(Collectors.toMap(
                        obj -> (String) obj[0],
                        obj -> (Long) obj[1]));
        builder.enrollmentsByStatus(enrollmentStatusCounts);
        builder.pendingEnrollments(enrollmentStatusCounts.getOrDefault("PENDING", 0L));
        builder.activeEnrollments(enrollmentStatusCounts.getOrDefault("ACTIVE", 0L));

        // Enrollments by Type
        builder.enrollmentsByType(enrollmentRepository.countByBenefitType().stream()
                .collect(Collectors.toMap(
                        obj -> (String) obj[0],
                        obj -> (Long) obj[1])));

        // Monthly Cost Trends
        builder.monthlyCostTrends(claimRepository.findMonthlyCostTrends().stream()
                .collect(Collectors.toMap(
                        obj -> (String) obj[0],
                        obj -> (BigDecimal) obj[1],
                        (v1, v2) -> v1, LinkedHashMap::new)));

        // Cost by Department
        builder.costByDepartment(claimRepository.findCostByDepartment().stream()
                .collect(Collectors.toMap(
                        obj -> (String) obj[0],
                        obj -> (BigDecimal) obj[1])));

        // Top Benefit Plans
        builder.topBenefitPlans(enrollmentRepository.findTopPlans().stream()
                .limit(5)
                .map(obj -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("planName", obj[0]);
                    map.put("count", obj[1]);
                    return map;
                })
                .collect(Collectors.toList()));

        return builder.build();
    }

    public List<BenefitClaim> searchReportData(String status, Long deptId, LocalDate startDate, LocalDate endDate,
            String keyword) {
        return claimRepository.searchClaims(status, deptId, startDate, endDate, keyword);
    }

    public ByteArrayInputStream exportToExcel(List<BenefitClaim> claims) throws IOException {
        try (Workbook workbook = new XSSFWorkbook(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Sheet sheet = workbook.createSheet("Benefit Claims Report");

            // Header Style
            CellStyle headerStyle = workbook.createCellStyle();
            headerStyle.setFillForegroundColor(IndexedColors.TEAL.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            Font font = workbook.createFont();
            font.setColor(IndexedColors.WHITE.getIndex());
            font.setBold(true);
            headerStyle.setFont(font);

            Row headerRow = sheet.createRow(0);
            String[] headers = { "Claim ID", "Employee", "Department", "Benefit Plan", "Category", "Amount", "Status",
                    "Date" };
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            int rowIdx = 1;
            for (BenefitClaim claim : claims) {
                Row row = sheet.createRow(rowIdx++);
                row.createCell(0).setCellValue(claim.getId());
                row.createCell(1).setCellValue(claim.getEmployee().getFullName());
                row.createCell(2).setCellValue(claim.getEmployee().getDepartment().getName());
                row.createCell(3).setCellValue(claim.getEnrollment().getBenefitPlan().getPlanName());
                row.createCell(4).setCellValue(claim.getEnrollment().getBenefitPlan().getBenefitType().getName());
                row.createCell(5).setCellValue(claim.getClaimAmount().doubleValue());
                row.createCell(6).setCellValue(claim.getStatus());
                row.createCell(7).setCellValue(claim.getClaimDate().toString());
            }

            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            workbook.write(out);
            return new ByteArrayInputStream(out.toByteArray());
        }
    }

    public ByteArrayInputStream exportToPdf(List<BenefitClaim> claims) {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        PdfWriter writer = new PdfWriter(out);
        PdfDocument pdf = new PdfDocument(writer);
        Document document = new Document(pdf);

        document.add(new Paragraph("Benefit Claims Summary Report").setBold().setFontSize(18));
        document.add(new Paragraph("Generated on: " + LocalDate.now()));
        document.add(new Paragraph("\n"));

        Table table = new Table(UnitValue.createPercentArray(new float[] { 1, 2, 2, 2, 1, 1 }));
        table.setWidth(UnitValue.createPercentValue(100));

        table.addHeaderCell("ID");
        table.addHeaderCell("Employee");
        table.addHeaderCell("Dept");
        table.addHeaderCell("Benefit");
        table.addHeaderCell("Amount");
        table.addHeaderCell("Status");

        for (BenefitClaim claim : claims) {
            table.addCell(claim.getId().toString());
            table.addCell(claim.getEmployee().getFullName());
            table.addCell(claim.getEmployee().getDepartment().getName());
            table.addCell(claim.getEnrollment().getBenefitPlan().getPlanName());
            table.addCell("$" + claim.getClaimAmount());
            table.addCell(claim.getStatus());
        }

        document.add(table);
        document.close();

        return new ByteArrayInputStream(out.toByteArray());
    }
}
