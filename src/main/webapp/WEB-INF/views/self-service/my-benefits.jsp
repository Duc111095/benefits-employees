<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <c:set var="pageTitle" value="My Benefits" scope="request" />
            <jsp:include page="../common/header.jsp" />

            <div class="container mt-4">
                <div class="row mb-4">
                    <div class="col-md-12">
                        <h2><i class="bi bi-shield-check"></i> My Enrolled Benefits</h2>
                    </div>
                </div>

                <div class="row mb-4">
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

                        <div class="card shadow-sm">
                            <div class="card-header bg-success text-white">
                                <h5 class="mb-0">Current Enrollments</h5>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Benefit Plan</th>
                                                <th>Effective Date</th>
                                                <th>Company Contr.</th>
                                                <th>My Contr.</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${empty enrollments}">
                                                    <tr>
                                                        <td colspan="6" class="text-center py-4 text-muted">You are not
                                                            enrolled in any benefits yet.</td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach items="${enrollments}" var="enr">
                                                        <tr>
                                                            <td><strong>${enr.benefitPlan.planName}</strong></td>
                                                            <td>${enr.effectiveDate}</td>
                                                            <td>
                                                                <fmt:formatNumber value="${enr.companyContribution}"
                                                                    type="currency" currencySymbol="VND " />
                                                            </td>
                                                            <td>
                                                                <fmt:formatNumber value="${enr.employeeContribution}"
                                                                    type="currency" currencySymbol="VND " />
                                                            </td>
                                                            <td>
                                                                <span
                                                                    class="badge ${enr.status == 'ACTIVE' ? 'bg-success' : 'bg-warning'}">
                                                                    ${enr.status}
                                                                </span>
                                                            </td>
                                                            <td>
                                                                <c:if test="${enr.status == 'ACTIVE'}">
                                                                    <a href="<c:url value='/self-service/claims'/>"
                                                                        class="btn btn-sm btn-outline-success">
                                                                        <i class="bi bi-plus-circle"></i> New Claim
                                                                    </a>
                                                                </c:if>
                                                            </td>
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
                </div>

                <div class="row">
                    <div class="col-md-12">
                        <h3>Available Benefit Plans</h3>
                        <div class="row g-4 mt-2">
                            <c:forEach items="${availablePlans}" var="plan">
                                <div class="col-md-4">
                                    <div class="card h-100 shadow-sm border-primary">
                                        <div class="card-body">
                                            <h5 class="card-title text-primary">${plan.planName}</h5>
                                            <h6 class="card-subtitle mb-2 text-muted">${plan.benefitType.name}</h6>
                                            <p class="card-text small">${plan.description}</p>
                                            <p class="mb-1"><strong>Eligibility:</strong> ${plan.eligibilityCriteria}
                                            </p>
                                            <p class="mb-1"><strong>Monthly Cost:</strong>
                                                <fmt:formatNumber value="${plan.employeeContribution}" type="currency"
                                                    currencySymbol="VND " />
                                            </p>
                                        </div>
                                        <div class="card-footer bg-white border-top-0">
                                            <button type="button" class="btn btn-primary w-100" data-bs-toggle="modal"
                                                data-bs-target="#enrollModal${plan.id}">
                                                Request Enrollment
                                            </button>
                                        </div>
                                    </div>

                                    <!-- Enrollment Modal -->
                                    <div class="modal fade" id="enrollModal${plan.id}" tabindex="-1" aria-hidden="true">
                                        <div class="modal-dialog">
                                            <form action="<c:url value='/self-service/enrollment/request'/>"
                                                method="post">
                                                <input type="hidden" name="${_csrf.parameterName}"
                                                    value="${_csrf.token}" />
                                                <input type="hidden" name="planId" value="${plan.id}" />
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title">Enroll in ${plan.planName}</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                            aria-label="Close"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <p>Confirm your enrollment request for
                                                            <strong>${plan.planName}</strong>.</p>
                                                        <div class="mb-3">
                                                            <label class="form-label">Notes for HR (Optional)</label>
                                                            <textarea name="notes" class="form-control" rows="3"
                                                                placeholder="Additional details or questions..."></textarea>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary"
                                                            data-bs-dismiss="modal">Cancel</button>
                                                        <button type="submit" class="btn btn-primary">Submit
                                                            Request</button>
                                                    </div>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>

            <jsp:include page="../common/footer.jsp" />