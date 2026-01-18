<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Executive Dashboard - BenefitHub</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
                <style>
                    :root {
                        --primary-color: #2a9d8f;
                        --secondary-color: #264653;
                        --accent-color: #e9c46a;
                        --bg-light: #f8fbfb;
                    }

                    body {
                        background-color: var(--bg-light);
                        font-family: 'Inter', sans-serif;
                    }

                    .navbar {
                        background: linear-gradient(135deg, var(--secondary-color), var(--primary-color));
                    }

                    .kpi-card {
                        border: none;
                        border-radius: 16px;
                        padding: 1.5rem;
                        transition: 0.3s;
                        background: #fff;
                        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
                    }

                    .kpi-card:hover {
                        transform: translateY(-5px);
                    }

                    .kpi-icon {
                        width: 50px;
                        height: 50px;
                        border-radius: 12px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 1.5rem;
                        margin-bottom: 1rem;
                    }

                    .bg-teal-light {
                        background-color: rgba(42, 157, 143, 0.1);
                        color: var(--primary-color);
                    }

                    .bg-blue-light {
                        background-color: rgba(52, 152, 219, 0.1);
                        color: #3498db;
                    }

                    .bg-orange-light {
                        background-color: rgba(243, 156, 18, 0.1);
                        color: #f39c12;
                    }

                    .bg-purple-light {
                        background-color: rgba(155, 89, 182, 0.1);
                        color: #9b59b6;
                    }

                    .chart-container {
                        background: #fff;
                        padding: 1.5rem;
                        border-radius: 16px;
                        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
                        margin-bottom: 1.5rem;
                        height: 400px;
                    }

                    .table-card {
                        background: #fff;
                        border-radius: 16px;
                        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
                        overflow: hidden;
                    }

                    .table thead {
                        background-color: #f8f9fa;
                    }
                </style>
            </head>

            <body>

                <nav class="navbar navbar-expand-lg navbar-dark mb-4">
                    <div class="container">
                        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/"><i
                                class="fas fa-chart-line me-2"></i>BenefitHub
                            Analytics</a>
                        <div class="collapse navbar-collapse">
                            <ul class="navbar-nav ms-auto">
                                <li class="nav-item"><a class="nav-link"
                                        href="${pageContext.request.contextPath}/manager/dashboard">System Admin</a>
                                </li>
                                <li class="nav-item"><a class="nav-link active"
                                        href="${pageContext.request.contextPath}/manager/reports/dashboard">Insights</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </nav>

                <div class="container pb-5">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h2 class="fw-bold mb-0">System Overview</h2>
                            <p class="text-muted">Real-time performance metrics and cost analytics</p>
                        </div>
                        <div class="btn-group">
                            <button class="btn btn-outline-primary" onclick="window.print()"><i
                                    class="fas fa-print me-1"></i> Print</button>
                            <a href="${pageContext.request.contextPath}/manager/reports" class="btn btn-primary"><i
                                    class="fas fa-file-export me-1"></i>
                                Detailed Reports</a>
                        </div>
                    </div>

                    <!-- KPI Row -->
                    <div class="row g-4 mb-4">
                        <div class="col-md-3">
                            <div class="kpi-card">
                                <div class="kpi-icon bg-teal-light">
                                    <i class="fas fa-users"></i>
                                </div>
                                <div class="text-muted small fw-bold">TOTAL ENROLLMENTS</div>
                                <h3 class="fw-bold mt-1">${stats.totalEnrollments}</h3>
                                <div class="small text-success"><i class="fas fa-arrow-up"></i> 12% increase</div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="kpi-card">
                                <div class="kpi-icon bg-blue-light">
                                    <i class="fas fa-clock"></i>
                                </div>
                                <div class="text-muted small fw-bold">PENDING APPROVALS</div>
                                <h3 class="fw-bold mt-1">${stats.pendingEnrollments}</h3>
                                <div class="small text-warning">Requires attention</div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="kpi-card">
                                <div class="kpi-icon bg-purple-light">
                                    <i class="fas fa-check-double"></i>
                                </div>
                                <div class="text-muted small fw-bold">ACTIVE BENEFITS</div>
                                <h3 class="fw-bold mt-1">${stats.activeEnrollments}</h3>
                                <div class="small text-muted">Currently utilized</div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="kpi-card">
                                <div class="kpi-icon bg-orange-light">
                                    <i class="fas fa-dollar-sign"></i>
                                </div>
                                <div class="text-muted small fw-bold">TOTAL APPROVED COST</div>
                                <h3 class="fw-bold mt-1">$
                                    <fmt:formatNumber value="${stats.totalBenefitCost}" pattern="#,##0.00" />
                                </h3>
                                <div class="small text-muted">Approval based</div>
                            </div>
                        </div>
                    </div>

                    <!-- Charts Row 1 -->
                    <div class="row g-4 mb-4">
                        <div class="col-lg-4">
                            <div class="chart-container">
                                <h5 class="fw-bold mb-4">Benefit Cost Trends (Monthly)</h5>
                                <canvas id="costTrendChart"></canvas>
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="chart-container">
                                <h5 class="fw-bold mb-4">Enrollment Distribution</h5>
                                <canvas id="typeDistChart"></canvas>
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="chart-container">
                                <h5 class="fw-bold mb-4">Claim Status Rate</h5>
                                <canvas id="claimStatusChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- Charts Row 2 -->
                    <div class="row g-4">
                        <div class="col-lg-6">
                            <div class="chart-container">
                                <h5 class="fw-bold mb-4">Department Cost Allocation</h5>
                                <canvas id="deptCostChart"></canvas>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="table-card h-100">
                                <div class="p-4 border-bottom">
                                    <h5 class="fw-bold mb-0">Most Popular Benefit Plans</h5>
                                </div>
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead>
                                            <tr>
                                                <th class="ps-4">Plan Name</th>
                                                <th class="text-center">Enrolled Users</th>
                                                <th class="text-end pe-4">Popularity Index</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${stats.topBenefitPlans}" var="plan">
                                                <tr>
                                                    <td class="ps-4 fw-bold">${plan.planName}</td>
                                                    <td class="text-center"><span
                                                            class="badge bg-light text-dark">${plan.count}</span></td>
                                                    <td class="text-end pe-4">
                                                        <div class="progress" style="height: 8px;">
                                                            <div class="progress-bar bg-primary"
                                                                style="width: ${plan.count * 10}%"></div>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                <script>
                    // Data injection from Server Side
                    const costTrendsLabels = [<c:forEach items="${stats.monthlyCostTrends}" var="entry">"${entry.key}",</c:forEach>];
                    const costTrendsData = [<c:forEach items="${stats.monthlyCostTrends}" var="entry">${entry.value},</c:forEach>];

                    const typeDistLabels = [<c:forEach items="${stats.enrollmentsByType}" var="entry">"${entry.key}",</c:forEach>];
                    const typeDistData = [<c:forEach items="${stats.enrollmentsByType}" var="entry">${entry.value},</c:forEach>];

                    const deptCostLabels = [<c:forEach items="${stats.costByDepartment}" var="entry">"${entry.key}",</c:forEach>];
                    const deptCostData = [<c:forEach items="${stats.costByDepartment}" var="entry">${entry.value},</c:forEach>];

                    const claimStatusLabels = [<c:forEach items="${stats.claimStatusDistribution}" var="entry">"${entry.key}",</c:forEach>];
                    const claimStatusData = [<c:forEach items="${stats.claimStatusDistribution}" var="entry">${entry.value},</c:forEach>];

                    // Chart Options
                    const chartOptions = {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: { legend: { position: 'bottom' } }
                    };

                    // 1. Cost Trend Chart (Line)
                    new Chart(document.getElementById('costTrendChart'), {
                        type: 'line',
                        data: {
                            labels: costTrendsLabels,
                            datasets: [{
                                label: 'Approved Spending ($)',
                                data: costTrendsData,
                                borderColor: '#2a9d8f',
                                backgroundColor: 'rgba(42, 157, 143, 0.1)',
                                fill: true,
                                tension: 0.4
                            }]
                        },
                        options: chartOptions
                    });

                    // 2. Type Distribution (Pie)
                    new Chart(document.getElementById('typeDistChart'), {
                        type: 'doughnut',
                        data: {
                            labels: typeDistLabels,
                            datasets: [{
                                data: typeDistData,
                                backgroundColor: ['#264653', '#2a9d8f', '#e9c46a', '#f4a261', '#e76f51']
                            }]
                        },
                        options: chartOptions
                    });

                    // 3. Department Cost (Bar)
                    new Chart(document.getElementById('deptCostChart'), {
                        type: 'bar',
                        data: {
                            labels: deptCostLabels,
                            datasets: [{
                                label: 'Departmental Spending ($)',
                                data: deptCostData,
                                backgroundColor: '#3498db',
                                borderRadius: 8
                            }]
                        },
                        options: chartOptions
                    });

                    // 4. Claim Status Chart (Pie)
                    new Chart(document.getElementById('claimStatusChart'), {
                        type: 'pie',
                        data: {
                            labels: claimStatusLabels,
                            datasets: [{
                                data: claimStatusData,
                                backgroundColor: ['#2a9d8f', '#f4a261', '#e76f51', '#264653']
                            }]
                        },
                        options: chartOptions
                    });
                </script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>