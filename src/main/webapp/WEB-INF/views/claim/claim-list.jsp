<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Benefit Claims Management - BenefitHub</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
                <style>
                    :root {
                        --primary-color: #2a9d8f;
                        --secondary-color: #264653;
                        --accent-color: #e9c46a;
                        --bg-light: #f4f9f9;
                    }

                    body {
                        background-color: var(--bg-light);
                        font-family: 'Inter', sans-serif;
                    }

                    .navbar {
                        background: linear-gradient(135deg, var(--secondary-color), var(--primary-color));
                    }

                    .card {
                        border: none;
                        border-radius: 12px;
                        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                        margin-bottom: 1.5rem;
                    }

                    .status-badge {
                        padding: 0.4rem 0.8rem;
                        border-radius: 20px;
                        font-weight: 600;
                        font-size: 0.8rem;
                        text-transform: uppercase;
                    }

                    .status-pending {
                        background-color: #fff3cd;
                        color: #856404;
                    }

                    .status-approved {
                        background-color: #d1e7dd;
                        color: #0f5132;
                    }

                    .status-rejected {
                        background-color: #f8d7da;
                        color: #842029;
                    }

                    .btn-action {
                        padding: 0.4rem 0.8rem;
                        border-radius: 8px;
                        font-size: 0.85rem;
                        transition: 0.3s;
                    }

                    .table thead {
                        background-color: #f8f9fa;
                    }

                    .filter-section {
                        background: #fff;
                        padding: 1.5rem;
                        border-radius: 12px;
                        margin-bottom: 2rem;
                    }
                </style>
            </head>

            <body>

                <nav class="navbar navbar-expand-lg navbar-dark mb-4">
                    <div class="container">
                        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/"><i
                                class="fas fa-hand-holding-heart me-2"></i>BenefitHub</a>
                        <div class="collapse navbar-collapse">
                            <ul class="navbar-nav me-auto">
                                <li class="nav-item"><a class="nav-link"
                                        href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                                <li class="nav-item"><a class="nav-link active"
                                        href="${pageContext.request.contextPath}/manager/claims">Claims
                                        Management</a></li>
                            </ul>
                        </div>
                    </div>
                </nav>

                <div class="container">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="fw-bold text-dark">Employee Claims</h2>
                        <div class="text-muted">Managerial Oversight</div>
                    </div>

                    <!-- Filter Bar -->
                    <div class="filter-section shadow-sm">
                        <form action="${pageContext.request.contextPath}/manager/claims" method="get" class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label small fw-bold">Search Employee</label>
                                <input type="text" name="keyword" class="form-control" placeholder="Name or code..."
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
                            <div class="col-md-3">
                                <label class="form-label small fw-bold">Department</label>
                                <select name="deptId" class="form-select">
                                    <option value="">All Departments</option>
                                    <c:forEach items="${departments}" var="dept">
                                        <option value="${dept.id}" ${deptId==dept.id ? 'selected' : '' }>
                                            ${dept.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-4 d-flex align-items-end gap-2">
                                <button type="submit" class="btn btn-primary px-4"><i class="fas fa-search me-1"></i>
                                    Search</button>
                                <a href="${pageContext.request.contextPath}/manager/claims"
                                    class="btn btn-outline-secondary">Reset</a>
                            </div>
                        </form>
                    </div>

                    <c:if test="${not empty successMsg}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i> ${successMsg}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty errorMsg}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i> ${errorMsg}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <div class="card">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th class="ps-4">Employee</th>
                                        <th>Benefit Plan</th>
                                        <th>Claim Amount</th>
                                        <th>Date Submitted</th>
                                        <th>Status</th>
                                        <th class="text-end pe-4">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${claims}" var="claim">
                                        <tr>
                                            <td class="ps-4">
                                                <div class="fw-bold">${claim.employee.fullName}</div>
                                                <div class="small text-muted">${claim.employee.employeeCode}</div>
                                            </td>
                                            <td>
                                                <div>${claim.enrollment.benefitPlan.planName}</div>
                                                <div class="small text-muted">
                                                    ${claim.enrollment.benefitPlan.benefitType.name}</div>
                                            </td>
                                            <td class="fw-bold text-primary">
                                                $
                                                <fmt:formatNumber value="${claim.claimAmount}" pattern="#,##0.00" />
                                            </td>
                                            <td>
                                                <fmt:parseDate value="${claim.submissionDate}"
                                                    pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedSubDate" type="both" />
                                                <fmt:formatDate value="${parsedSubDate}" pattern="MMM dd, yyyy" />
                                            </td>
                                            <td>
                                                <span class="status-badge status-${claim.status.toLowerCase()}">
                                                    ${claim.status}
                                                </span>
                                            </td>
                                            <td class="text-end pe-4">
                                                <a href="${pageContext.request.contextPath}/manager/claims/${claim.id}"
                                                    class="btn btn-light btn-action">
                                                    <i class="fas fa-eye me-1"></i> Review
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty claims}">
                                        <tr>
                                            <td colspan="6" class="text-center py-5 text-muted">
                                                <i class="fas fa-inbox fa-3x mb-3"></i>
                                                <p>No claims found matching your criteria.</p>
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>