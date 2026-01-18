<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Detailed Reports - BenefitHub</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
                <style>
                    :root {
                        --primary-color: #2a9d8f;
                        --secondary-color: #264653;
                        --bg-light: #f8fbfb;
                    }

                    body {
                        background-color: var(--bg-light);
                        font-family: 'Inter', sans-serif;
                    }

                    .filter-section {
                        background: #fff;
                        padding: 1.5rem;
                        border-radius: 12px;
                        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                        margin-bottom: 2rem;
                    }

                    .report-table {
                        background: #fff;
                        border-radius: 12px;
                        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                        overflow: hidden;
                    }

                    .table thead {
                        background-color: #f8f9fa;
                    }

                    .status-badge {
                        padding: 0.5em 1em;
                        border-radius: 50px;
                        font-size: 0.75rem;
                        font-weight: 600;
                    }

                    .status-approved {
                        background-color: #d1fae5;
                        color: #065f46;
                    }

                    .status-pending {
                        background-color: #fef3c7;
                        color: #92400e;
                    }

                    .status-rejected {
                        background-color: #fee2e2;
                        color: #991b1b;
                    }
                </style>
            </head>

            <body>

                <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
                    <div class="container">
                        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/"><i
                                class="fas fa-chart-line me-2"></i>BenefitHub
                            Analytics</a>
                        <div class="ms-auto">
                            <a href="${pageContext.request.contextPath}/manager/reports/dashboard"
                                class="btn btn-sm btn-outline-light me-2">Back to
                                Dashboard</a>
                            <span class="text-light small">HR Manager Portal</span>
                        </div>
                    </div>
                </nav>

                <div class="container pb-5">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="fw-bold"><i class="fas fa-file-contract text-primary me-2"></i>Detailed Benefit
                            Reports</h2>
                        <div class="btn-group">
                            <button class="btn btn-success" onclick="exportData('excel')"><i
                                    class="fas fa-file-excel me-1"></i> Excel</button>
                            <button class="btn btn-danger" onclick="exportData('pdf')"><i
                                    class="fas fa-file-pdf me-1"></i> PDF</button>
                        </div>
                    </div>

                    <!-- Filters -->
                    <div class="filter-section">
                        <form id="reportForm" action="${pageContext.request.contextPath}/manager/reports" method="GET"
                            class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label small fw-bold">Keyword (Name/Code)</label>
                                <input type="text" name="keyword" class="form-control" placeholder="Search..."
                                    value="${keyword}">
                            </div>
                            <div class="col-md-2">
                                <label class="form-label small fw-bold">Status</label>
                                <select name="status" class="form-select">
                                    <option value="">All Statuses</option>
                                    <option value="PENDING" ${status=='PENDING' ? 'selected' : '' }>Pending</option>
                                    <option value="APPROVED" ${status=='APPROVED' ? 'selected' : '' }>Approved</option>
                                    <option value="REJECTED" ${status=='REJECTED' ? 'selected' : '' }>Rejected</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label small fw-bold">Department</label>
                                <select name="deptId" class="form-select">
                                    <option value="">All Depts</option>
                                    <c:forEach items="${departments}" var="dept">
                                        <option value="${dept.id}" ${deptId==dept.id ? 'selected' : '' }>${dept.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label small fw-bold">Start Date</label>
                                <input type="date" name="startDate" class="form-control" value="${startDate}">
                            </div>
                            <div class="col-md-2">
                                <label class="form-label small fw-bold">End Date</label>
                                <input type="date" name="endDate" class="form-control" value="${endDate}">
                            </div>
                            <div class="col-md-1 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary w-100"><i
                                        class="fas fa-search"></i></button>
                            </div>
                        </form>
                    </div>

                    <!-- Results Table -->
                    <div class="report-table">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th class="ps-4">ID</th>
                                        <th>Employee</th>
                                        <th>Department</th>
                                        <th>Benefit Plan</th>
                                        <th class="text-end">Amount</th>
                                        <th class="text-center">Status</th>
                                        <th class="text-end pe-4">Date</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${claims}" var="claim">
                                        <tr>
                                            <td class="ps-4 text-muted">#${claim.id}</td>
                                            <td>
                                                <div class="fw-bold">${claim.employee.fullName}</div>
                                                <div class="small text-muted">${claim.employee.employeeCode}</div>
                                            </td>
                                            <td>${claim.employee.department.name}</td>
                                            <td>${claim.enrollment.benefitPlan.planName}</td>
                                            <td class="text-end fw-bold text-dark">$
                                                <fmt:formatNumber value="${claim.claimAmount}" pattern="#,##0.00" />
                                            </td>
                                            <td class="text-center">
                                                <span
                                                    class="status-badge ${claim.status == 'APPROVED' ? 'status-approved' : (claim.status == 'PENDING' ? 'status-pending' : 'status-rejected')}">
                                                    ${claim.status}
                                                </span>
                                            </td>
                                            <td class="text-end pe-4 text-muted">${claim.claimDate}</td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty claims}">
                                        <tr>
                                            <td colspan="7" class="text-center py-5 text-muted">No data found for the
                                                selected filters.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <script>
                    function exportData(type) {
                        const form = document.getElementById('reportForm');
                        const params = new URLSearchParams(new FormData(form)).toString();
                        window.location.href = `${pageContext.request.contextPath}/manager/reports/export/` + type + "?" + params;
                    }
                </script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>