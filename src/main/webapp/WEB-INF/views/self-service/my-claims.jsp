<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <c:set var="pageTitle" value="My Claims" scope="request" />
            <jsp:include page="../common/header.jsp" />

            <div class="container mt-4">
                <div class="row mb-4">
                    <div class="col-md-8">
                        <h2><i class="bi bi-file-earmark-medical"></i> My Benefits Claims</h2>
                    </div>
                    <div class="col-md-4 text-end">
                        <button class="btn btn-primary" data-bs-toggle="collapse" data-bs-target="#newClaimForm">
                            <i class="bi bi-plus-circle"></i> New Claim Request
                        </button>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-12">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty success}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="bi bi-check-circle-fill me-2"></i> ${success}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                    </div>
                </div>

                <div id="newClaimForm" class="collapse mb-4">
                    <div class="card card-body shadow-sm">
                        <h5>Submit New Payment Request</h5>
                        <form action="<c:url value='/self-service/claim/save'/>" method="post"
                            enctype="multipart/form-data">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Benefit Plan (Active Enrollments)</label>
                                    <select name="enrollmentId" class="form-select" required>
                                        <option value="" disabled selected>Select an enrolled benefit...</option>
                                        <c:forEach items="${activeEnrollments}" var="enr">
                                            <option value="${enr.id}">${enr.benefitPlan.planName}</option>
                                        </c:forEach>
                                    </select>
                                    <c:if test="${empty activeEnrollments}">
                                        <div class="form-text text-danger">You must be enrolled in an active benefit to
                                            submit a claim.</div>
                                    </c:if>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Amount (VND)</label>
                                    <div class="input-group">
                                        <input type="number" name="claimAmount" class="form-control"
                                            placeholder="Enter amount" required>
                                        <span class="input-group-text">VND</span>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Supporting Documents (PDF, JPG, PNG)</label>
                                    <input type="file" name="attachment" class="form-control"
                                        accept=".pdf,.jpg,.jpeg,.png">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Date of Usage/Service</label>
                                    <input type="date" name="claimDate" class="form-control"
                                        value="<%= java.time.LocalDate.now() %>" required>
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label">Description / Reason</label>
                                    <textarea name="description" class="form-control" rows="2"
                                        placeholder="Describe the usage (e.g., Medical checkup at ABC Hospital)"
                                        required></textarea>
                                </div>
                                <div class="col-md-12 text-end">
                                    <button type="submit" class="btn btn-success" ${empty activeEnrollments ? 'disabled'
                                        : '' }>
                                        Submit Request
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="card shadow-sm">
                    <div class="card-header bg-white">
                        <h5 class="mb-0">Claim History</h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Date</th>
                                        <th>Benefit</th>
                                        <th>Amount</th>
                                        <th>Status</th>
                                        <th>Attachment</th>
                                        <th>Description</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty claims}">
                                            <tr>
                                                <td colspan="6" class="text-center py-4 text-muted">You haven't
                                                    submitted any claims yet.</td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach items="${claims}" var="claim">
                                                <tr>
                                                    <td>${claim.claimDate}</td>
                                                    <td>${claim.enrollment.benefitPlan.planName}</td>
                                                    <td>
                                                        <fmt:formatNumber value="${claim.claimAmount}" type="currency"
                                                            currencySymbol="VND " />
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${claim.status == 'APPROVED'}">
                                                                <span class="badge bg-success">${claim.status}</span>
                                                            </c:when>
                                                            <c:when test="${claim.status == 'PENDING'}">
                                                                <span
                                                                    class="badge bg-warning text-dark">${claim.status}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-danger">${claim.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:if test="${not empty claim.attachmentPath}">
                                                            <a href="#" class="btn btn-sm btn-outline-info"
                                                                title="View Attachment">
                                                                <i class="bi bi-paperclip"></i>
                                                            </a>
                                                        </c:if>
                                                        <c:if test="${empty claim.attachmentPath}">
                                                            <span class="text-muted">None</span>
                                                        </c:if>
                                                    </td>
                                                    <td><small>${claim.description}</small></td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <jsp:include page="../common/footer.jsp" />