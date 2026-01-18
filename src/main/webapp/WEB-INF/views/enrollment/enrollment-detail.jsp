<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Enrollment Detail - BenefitHub</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
                <style>
                    :root {
                        --primary-color: #4361ee;
                        --secondary-color: #3f37c9;
                        --bg-light: #f8f9fa;
                    }

                    body {
                        background-color: var(--bg-light);
                        font-family: 'Inter', sans-serif;
                    }

                    .navbar {
                        background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
                    }

                    .card {
                        border: none;
                        border-radius: 15px;
                        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
                        margin-bottom: 1.5rem;
                    }

                    .section-header {
                        border-bottom: 2px solid #f0f0f0;
                        padding-bottom: 1rem;
                        margin-bottom: 1.5rem;
                        font-weight: 700;
                        color: #333;
                    }

                    .detail-label {
                        font-size: 0.75rem;
                        font-weight: 700;
                        color: #6c757d;
                        text-transform: uppercase;
                        margin-bottom: 0.2rem;
                    }

                    .detail-value {
                        font-weight: 600;
                        color: #212529;
                        margin-bottom: 1rem;
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

                    .action-card {
                        background: #fff;
                        padding: 2rem;
                        text-align: center;
                    }

                    .btn-approve {
                        background-color: #198754;
                        border: none;
                        padding: 0.8rem 2rem;
                        font-weight: 600;
                        border-radius: 10px;
                    }

                    .btn-reject {
                        background-color: #dc3545;
                        border: none;
                        padding: 0.8rem 2rem;
                        font-weight: 600;
                        border-radius: 10px;
                    }

                    .plan-info-box {
                        background-color: #f8faff;
                        border: 1px solid #e1e7ff;
                        border-radius: 10px;
                        padding: 1rem;
                    }
                </style>
            </head>

            <body>

                <nav class="navbar navbar-expand-lg navbar-dark mb-4">
                    <div class="container">
                        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/"><i
                                class="fas fa-parachute-box me-2"></i>BenefitHub</a>
                        <div class="collapse navbar-collapse">
                            <ul class="navbar-nav ms-auto text-white">
                                <li class="nav-item">HR Manager Portal</li>
                            </ul>
                        </div>
                    </div>
                </nav>

                <div class="container py-4">
                    <div class="mb-4">
                        <a href="${pageContext.request.contextPath}/hr/enrollments"
                            class="text-decoration-none text-muted">
                            <i class="fas fa-arrow-left me-2"></i> Back to Requests
                        </a>
                    </div>

                    <div class="row">
                        <!-- Main Content (Left) -->
                        <div class="col-lg-8">
                            <!-- Enrollment Info -->
                            <div class="card p-4">
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h4 class="fw-bold mb-0">Enrollment Details</h4>
                                    <span class="status-badge status-${enrollment.status.toLowerCase()}">
                                        ${enrollment.status}
                                    </span>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="detail-label">Request ID</div>
                                        <div class="detail-value">#ENR-${enrollment.id}</div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="detail-label">Submission Date</div>
                                        <div class="detail-value">
                                            <fmt:parseDate value="${enrollment.enrollmentDate}" pattern="yyyy-MM-dd"
                                                var="subDate" type="date" />
                                            <fmt:formatDate value="${subDate}" pattern="MMMM dd, yyyy" />
                                        </div>
                                    </div>
                                </div>

                                <div class="section-header mt-3">Employee Information</div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="detail-label">Full Name</div>
                                        <div class="detail-value">${enrollment.employee.fullName}</div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="detail-label">Employee Code</div>
                                        <div class="detail-value">${enrollment.employee.employeeCode}</div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="detail-label">Department</div>
                                        <div class="detail-value">${enrollment.employee.department.name}</div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="detail-label">Email</div>
                                        <div class="detail-value">${enrollment.employee.email}</div>
                                    </div>
                                </div>

                                <div class="section-header mt-3">Plan Details</div>
                                <div class="row">
                                    <div class="col-12">
                                        <div class="plan-info-box mb-3">
                                            <h5 class="fw-bold text-primary mb-1">${enrollment.benefitPlan.planName}
                                            </h5>
                                            <p class="mb-0 text-muted">${enrollment.benefitPlan.description}</p>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="detail-label">Type</div>
                                        <div class="detail-value">${enrollment.benefitPlan.benefitType.name}</div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="detail-label">Company Contribution</div>
                                        <div class="detail-value">$${enrollment.companyContribution}</div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="detail-label">Employee Contribution</div>
                                        <div class="detail-value">$${enrollment.employeeContribution}</div>
                                    </div>
                                </div>

                                <c:if test="${not empty enrollment.notes}">
                                    <div class="section-header mt-3">Employee Notes</div>
                                    <div class="p-3 bg-light rounded text-muted italic">
                                        "${enrollment.notes}"
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <!-- Sidebar Actions (Right) -->
                        <div class="col-lg-4">
                            <div class="card action-card">
                                <h5 class="fw-bold mb-4">Approval Actions</h5>

                                <c:choose>
                                    <c:when test="${enrollment.status == 'PENDING'}">
                                        <form
                                            action="${pageContext.request.contextPath}/hr/enrollments/${enrollment.id}/approve"
                                            method="post" class="mb-3">
                                            <button type="submit" class="btn btn-approve btn-success w-100 py-3">
                                                <i class="fas fa-check-circle me-2"></i> Approve Request
                                            </button>
                                        </form>

                                        <button type="button" class="btn btn-reject btn-danger w-100 py-3"
                                            data-bs-toggle="modal" data-bs-target="#rejectModal">
                                            <i class="fas fa-times-circle me-2"></i> Reject Request
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="alert alert-info py-4">
                                            <i class="fas fa-info-circle fa-2x mb-3 text-primary d-block"></i>
                                            This request has already been processed and is currently
                                            <strong>${enrollment.status}</strong>.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Financial Summary Card (Visible if pending) -->
                            <c:if test="${enrollment.status == 'PENDING'}">
                                <div class="card p-4">
                                    <h6 class="fw-bold mb-3">Post-Approval Impact</h6>
                                    <ul class="list-unstyled small">
                                        <li class="d-flex justify-content-between mb-2">
                                            <span>Plan Limit:</span>
                                            <span class="fw-bold">${enrollment.benefitPlan.limitValue}
                                                (${enrollment.benefitPlan.limitType})</span>
                                        </li>
                                        <li class="d-flex justify-content-between mb-2 text-success">
                                            <span>Effective From:</span>
                                            <span class="fw-bold">Today</span>
                                        </li>
                                    </ul>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Reject Modal -->
                <div class="modal fade" id="rejectModal" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title fw-bold">Confirm Rejection</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <form action="${pageContext.request.contextPath}/hr/enrollments/${enrollment.id}/reject"
                                method="post">
                                <div class="modal-body">
                                    <p>Are you sure you want to reject this request? This action cannot be undone.</p>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold small">Reason for Rejection</label>
                                        <textarea name="reason" class="form-control" rows="3"
                                            placeholder="Explain why the request is being rejected..."
                                            required></textarea>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                                    <button type="submit" class="btn btn-danger">Confirm Rejection</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>