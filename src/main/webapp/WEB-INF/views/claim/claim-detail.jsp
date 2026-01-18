<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Claim Review - BenefitHub</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
                <style>
                    :root {
                        --primary-color: #2a9d8f;
                        --secondary-color: #264653;
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

                    .section-title {
                        font-size: 0.9rem;
                        text-transform: uppercase;
                        letter-spacing: 1px;
                        color: #6c757d;
                        font-weight: 700;
                        border-bottom: 2px solid #f0f0f0;
                        padding-bottom: 0.5rem;
                        margin-bottom: 1rem;
                    }

                    .info-label {
                        font-size: 0.85rem;
                        color: #6c757d;
                        margin-bottom: 0.1rem;
                    }

                    .info-value {
                        font-weight: 600;
                        color: #264653;
                        margin-bottom: 1rem;
                    }

                    .claim-amount-box {
                        background-color: rgba(42, 157, 143, 0.1);
                        border: 1px solid var(--primary-color);
                        border-radius: 10px;
                        padding: 1.5rem;
                        text-align: center;
                    }

                    .status-badge {
                        padding: 0.5rem 1rem;
                        border-radius: 20px;
                        font-weight: 600;
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

                    .btn-approve {
                        background-color: var(--primary-color);
                        color: white;
                        border: none;
                        padding: 0.8rem;
                        font-weight: 700;
                    }

                    .btn-approve:hover {
                        background-color: #21867a;
                        color: white;
                    }

                    .attachment-card {
                        background: #fff;
                        border: 1px dashed #ced4da;
                        padding: 1rem;
                        display: flex;
                        align-items: center;
                        border-radius: 8px;
                    }
                </style>
            </head>

            <body>

                <nav class="navbar navbar-expand-lg navbar-dark mb-4">
                    <div class="container">
                        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/"><i
                                class="fas fa-hand-holding-heart me-2"></i>BenefitHub</a>
                    </div>
                </nav>

                <div class="container py-4">
                    <div class="mb-4">
                        <a href="${pageContext.request.contextPath}/manager/claims"
                            class="text-decoration-none text-muted">
                            <i class="fas fa-arrow-left me-1"></i> Back to Claims
                        </a>
                    </div>

                    <div class="row">
                        <div class="col-lg-8">
                            <div class="card p-4">
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h4 class="fw-bold mb-0">Claim Details</h4>
                                    <span
                                        class="status-badge status-${claim.status.toLowerCase()}">${claim.status}</span>
                                </div>

                                <div class="section-title">Employee Information</div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="info-label">Full Name</div>
                                        <div class="info-value">${claim.employee.fullName}</div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="info-label">Employee Code</div>
                                        <div class="info-value">${claim.employee.employeeCode}</div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="info-label">Department</div>
                                        <div class="info-value">${claim.employee.department.name}</div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="info-label">Current Position</div>
                                        <div class="info-value">${claim.employee.position}</div>
                                    </div>
                                </div>

                                <div class="section-title">Benefit Details</div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="info-label">Benefit Plan</div>
                                        <div class="info-value">${claim.enrollment.benefitPlan.planName}</div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="info-label">Benefit Type</div>
                                        <div class="info-value">${claim.enrollment.benefitPlan.benefitType.name}
                                        </div>
                                    </div>
                                </div>

                                <div class="section-title">Claim Information</div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="info-label">Submission Date</div>
                                        <div class="info-value">
                                            <fmt:parseDate value="${claim.submissionDate}"
                                                pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" type="both" />
                                            <fmt:formatDate value="${parsedDate}" pattern="MMMM dd, yyyy HH:mm" />
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="info-label">Claim Date</div>
                                        <div class="info-value">${claim.claimDate}</div>
                                    </div>
                                    <div class="col-12 mt-2">
                                        <div class="info-label">Description / Reason</div>
                                        <div class="p-3 bg-light rounded text-muted mb-3">
                                            "${claim.description != null ? claim.description : 'No description
                                            provided.'}"
                                        </div>
                                    </div>
                                </div>

                                <div class="section-title">Attachments</div>
                                <c:choose>
                                    <c:when test="${not empty claim.attachmentPath}">
                                        <div class="attachment-card">
                                            <i class="fas fa-file-pdf fa-2x text-danger me-3"></i>
                                            <div class="flex-grow-1">
                                                <div class="fw-bold small">Claim Support Document</div>
                                                <div class="text-muted smaller">Click to preview</div>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/${claim.attachmentPath}"
                                                target="_blank" class="btn btn-sm btn-outline-primary">
                                                <i class="fas fa-download me-1"></i> View
                                            </a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-muted small italic">No attachments provided with this claim.</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="col-lg-4">
                            <div class="card p-4 shadow-sm bg-white">
                                <h5 class="fw-bold mb-4">Financial Overview</h5>
                                <div class="claim-amount-box mb-4">
                                    <div class="info-label text-primary">Requested Amount</div>
                                    <h2 class="fw-bold text-primary mb-0">$
                                        <fmt:formatNumber value="${claim.claimAmount}" pattern="#,##0.00" />
                                    </h2>
                                </div>

                                <c:choose>
                                    <c:when test="${claim.status == 'PENDING'}">
                                        <form
                                            action="${pageContext.request.contextPath}/manager/claims/${claim.id}/approve"
                                            method="post" class="mb-2">
                                            <button type="submit" class="btn btn-approve w-100 rounded-3 py-3 border-0">
                                                <i class="fas fa-check-circle me-2"></i> Approve Request
                                            </button>
                                        </form>
                                        <button class="btn btn-outline-danger w-100 rounded-3 py-3"
                                            data-bs-toggle="modal" data-bs-target="#rejectModal">
                                            <i class="fas fa-times-circle me-2"></i> Reject Request
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="alert alert-info py-3 text-center">
                                            <i class="fas fa-info-circle mb-2 fa-2x d-block"></i>
                                            This claim is already <strong>${claim.status}</strong> and cannot be
                                            modified.
                                        </div>
                                        <c:if test="${claim.status == 'REJECTED'}">
                                            <div class="mt-3">
                                                <label class="info-label">Rejection Reason:</label>
                                                <div class="text-danger small p-2 bg-light rounded">
                                                    ${claim.rejectionReason}</div>
                                            </div>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="card p-4">
                                <h6 class="fw-bold mb-3">Audit Details</h6>
                                <div class="small">
                                    <div class="mb-2">
                                        <span class="text-muted">Managed By:</span>
                                        <span class="fw-bold text-dark">${claim.approvedBy != null ?
                                            claim.approvedBy.username : 'N/A'}</span>
                                    </div>
                                    <div>
                                        <span class="text-muted">Processed On:</span>
                                        <span class="fw-bold text-dark">
                                            ${claim.approvalDate != null ? claim.approvalDate : 'Pending'}
                                        </span>
                                    </div>
                                </div>
                            </div>
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
                            <form action="${pageContext.request.contextPath}/manager/claims/${claim.id}/reject"
                                method="post">
                                <div class="modal-body">
                                    <p>Are you sure you want to reject this claim? This action is irreversible.</p>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold small">Reason for Rejection</label>
                                        <textarea name="reason" class="form-control" rows="3"
                                            placeholder="Provide a detailed reason..." required></textarea>
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