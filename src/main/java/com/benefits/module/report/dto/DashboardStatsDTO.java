package com.benefits.module.report.dto;

import lombok.Builder;
import lombok.Data;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Data
@Builder
public class DashboardStatsDTO {
    private long totalEnrollments;
    private long pendingEnrollments;
    private long activeEnrollments;
    private BigDecimal totalBenefitCost;

    private Map<String, Long> enrollmentsByStatus;
    private Map<String, Long> enrollmentsByType;
    private Map<String, Long> claimStatusDistribution;
    private Map<String, BigDecimal> monthlyCostTrends;
    private Map<String, BigDecimal> costByDepartment;
    private List<Map<String, Object>> topBenefitPlans;
}
