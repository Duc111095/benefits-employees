<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Enrollment Requests - BenefitHub</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
                <style>
                    :root {
                        --primary-color: #4361ee;
                        --secondary-color: #3f37c9;
                        --accent-color: #4cc9f0;
                        --success-color: #4cc9f0;
                        --warning-color: #f72585;
                        --bg-light: #f8f9fa;
                    }

                    body {
                        background-color: var(--bg-light);
                        font-family: 'Inter', sans-serif;
                    }

                    .navbar {
                        background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                    }

                    .card {
                        border: none;
                        border-radius: 15px;
                        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
                        margin-bottom: 2rem;
                    }

                    .filter-card {
                        background: #fff;
                        padding: 1.5rem;
                        border-radius: 12px;
                    }

                    .status-badge {
                        padding: 0.5rem 1rem;
                        border-radius: 20px;
                        font-weight: 600;
                        font-size: 0.85rem;
                    }

                    .status-pending {
                        background-color: #fff3cd;
                        color: #856404;
                    }

                    .status-active {
                        background-color: #d1e7dd;
                        color: #0f5132;
                    }

                    .status-rejected {
                        background-color: #f8d7da;
                        color: #842029;
                    }

                    .status-terminated {
                        background-color: #e2e3e5;
                        color: #41464b;
                    }

                    .table thead th {
                        background-color: #f8f9fa;
                        border-bottom: 2px solid #dee2e6;
                        font-weight: 600;
                        text-transform: uppercase;
                        font-size: 0.75rem;
                        letter-spacing: 0.5px;
                    }

                    .btn-view {
                        color: var(--primary-color);
                        background: rgba(67, 97, 238, 0.1);
                        border: none;
                        border-radius: 8px;
                        padding: 0.4rem 0.8rem;
                        transition: all 0.3s;
                    }

                    .btn-view:hover {
                        background: var(--primary-color);
                        color: #fff;
                    }

                    .search-input {
                        border-radius: 10px 0 0 10px;
                        border-right: none;
                    }

                    .search-btn {
                        border-radius: 0 10px 10px 0;
                    }
                </style>
            </head>

            <body>

                <nav class="navbar navbar-expand-lg navbar-dark mb-4">
                    <div class="container">
                        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/"><i
                                class="fas fa-parachute-box me-2"></i>BenefitHub</a>
                        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                            data-bs-target="#navbarNav">
                            <span class="navbar-toggler-icon"></span>
                        </button>
                        <div class="collapse navbar-collapse" id="navbarNav">
                            <ul class="navbar-nav me-auto">
                                <li class="nav-item"><a class="nav-link"
                                        href="${pageContext.request.contextPath}/hr/dashboard">Dashboard</a></li>
                                <li class="nav-item"><a class="nav-link active"
                                        href="${pageContext.request.contextPath}/hr/enrollments">Enrollments</a>
                                </li>
                                <li class="nav-item"><a class="nav-link"
                                        href="${pageContext.request.contextPath}/hr/benefits">Benefits</a></li>
                            </ul>
                        </div>
                    </div>
                </nav>

                <div class="container">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="fw-bold text-dark">Enrollment Requests</h2>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb mb-0">
                                <li class="breadcrumb-item"><a
                                        href="${pageContext.request.contextPath}/dashboard">Home</a></li>
                                <li class="breadcrumb-item active">Enrollments</li>
                            </ol>
                        </nav>
                    </div>

                    <!-- Filter Bar -->
                    <div class="card filter-card mb-4">
                        <form action="${pageContext.request.contextPath}/hr/enrollments" method="get" class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label small fw-bold">Keyword</label>
                                <div class="input-group">
                                    <input type="text" name="keyword" class="form-control" placeholder="Name, code..."
                                        value="${keyword}">
                                </div>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label small fw-bold">Status</label>
                                <select name="status" class="form-select">
                                    <option value="">All Statuses</option>
                                    <option value="PENDING" ${status=='PENDING' ? 'selected' : '' }>Pending</option>
                                    <option value="ACTIVE" ${status=='ACTIVE' ? 'selected' : '' }>Active</option>
                                    <option value="REJECTED" ${status=='REJECTED' ? 'selected' : '' }>Rejected</option>
                                    <option value="TERMINATED" ${status=='TERMINATED' ? 'selected' : '' }>Terminated
                                    </option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label small fw-bold">Department</label>
                                <select name="deptId" class="form-select">
                                    <option value="">All Departments</option>
                                    <c:forEach items="${departments}" var="dept">
                                        <option value="${dept.id}" ${deptId==dept.id ? 'selected' : '' }>
                                            ${dept.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label small fw-bold">Benefit Type</label>
                                <select name="typeId" class="form-select">
                                    <option value="">All Types</option>
                                    <c:forEach items="${benefitTypes}" var="type">
                                        <option value="${type.id}" ${typeId==type.id ? 'selected' : '' }>
                                            ${type.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3 d-flex align-items-end gap-2">
                                <button type="submit" class="btn btn-primary w-100 search-btn">
                                    <i class="fas fa-search me-1"></i> Filter
                                </button>
                                <a href="${pageContext.request.contextPath}/hr/enrollments"
                                    class="btn btn-light border w-100">Reset</a>
                            </div>
                        </form>
                    </div>

                    <c:if test="${not empty successMsg}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i> ${successMsg}
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
                                        <th>Requested Date</th>
                                        <th>Status</th>
                                        <th class="text-end pe-4">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${enrollments}" var="enrollment">
                                        <tr>
                                            <td class="ps-4">
                                                <div class="d-flex align-items-center">
                                                    <div class="avatar-sm me-3 bg-light rounded-circle d-flex align-items-center justify-content-center"
                                                        style="width: 40px; height: 40px;">
                                                        <i class="fas fa-user text-muted"></i>
                                                    </div>
                                                    <div>
                                                        <div class="fw-bold text-dark">${enrollment.employee.fullName}
                                                        </div>
                                                        <div class="small text-muted">
                                                            ${enrollment.employee.employeeCode}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="fw-bold">${enrollment.benefitPlan.planName}</div>
                                                <div class="small text-muted">
                                                    ${enrollment.benefitPlan.benefitType.name}</div>
                                            </td>
                                            <td>
                                                <fmt:parseDate value="${enrollment.enrollmentDate}" pattern="yyyy-MM-dd"
                                                    var="parsedDate" type="date" />
                                                <fmt:formatDate value="${parsedDate}" pattern="MMM dd, yyyy" />
                                            </td>
                                            <td>
                                                <span class="status-badge status-${enrollment.status.toLowerCase()}">
                                                    <i class="fas fa-circle me-1" style="font-size: 0.5rem;"></i>
                                                    ${enrollment.status}
                                                </span>
                                            </td>
                                            <td class="text-end pe-4">
                                                <a href="${pageContext.request.contextPath}/hr/enrollments/${enrollment.id}"
                                                    class="btn-view text-decoration-none">
                                                    <i class="fas fa-eye me-1"></i> Details
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty enrollments}">
                                        <tr>
                                            <td colspan="5" class="text-center py-5">
                                                <div class="text-muted mb-2"><i class="fas fa-folder-open fa-3x"></i>
                                                </div>
                                                <div class="fw-bold">No enrollment requests found</div>
                                                <div class="small">Try adjusting your filters</div>
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