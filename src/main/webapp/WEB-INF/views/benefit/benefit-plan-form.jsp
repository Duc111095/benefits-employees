<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

            <c:set var="pageTitle" value="${benefitPlan.id == null ? 'New' : 'Edit'} Benefit Plan" scope="request" />
            <jsp:include page="../common/header.jsp" />

            <div class="container mt-4 mb-5">
                <div class="row justify-content-center">
                    <div class="col-lg-10">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <h2 class="mb-0"><i class="bi bi-gift-fill text-primary me-2"></i> ${benefitPlan.id ==
                                    null ? 'Define New' : 'Modify'} Benefit Plan</h2>
                                <p class="text-muted small">Establish policy rules, financial limits, and operational
                                    workflows</p>
                            </div>
                            <a href="<c:url value='/benefit/plans'/>" class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-left"></i> Back to List
                            </a>
                        </div>

                        <form:form action="${pageContext.request.contextPath}/benefit/plans/save" method="post"
                            modelAttribute="benefitPlan">
                            <form:hidden path="id" />

                            <!-- Identification & Type -->
                            <div class="card border-0 shadow-sm mb-4">
                                <div class="card-header bg-white py-3">
                                    <h5 class="mb-0 text-dark"><i class="bi bi-info-circle me-2"></i> Plan
                                        Identification</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">Plan Name</label>
                                            <form:input path="planName" class="form-control"
                                                placeholder="e.g. Platinum Health Plus" required="true" />
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label fw-bold">Internal Code</label>
                                            <form:input path="planCode" class="form-control" placeholder="HEALTH-001"
                                                required="true" />
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label fw-bold">Benefit Category</label>
                                            <form:select path="benefitType.id" class="form-select" required="true">
                                                <form:option value="" label="-- Select Type --" />
                                                <form:options items="${benefitTypes}" itemValue="id" itemLabel="name" />
                                            </form:select>
                                        </div>
                                        <div class="col-12">
                                            <label class="form-label fw-bold">Policy Description</label>
                                            <form:textarea path="description" class="form-control" rows="3"
                                                placeholder="Brief overview of the benefit plan..." />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Financials & Timeline -->
                            <div class="card border-0 shadow-sm mb-4">
                                <div class="card-header bg-white py-3">
                                    <h5 class="mb-0 text-dark"><i class="bi bi-cash-coin me-2"></i> Financial Controls &
                                        Period</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row g-3">
                                        <div class="col-md-4">
                                            <label class="form-label fw-bold">Total Annual Budget</label>
                                            <div class="input-group">
                                                <span class="input-group-text">$</span>
                                                <form:input path="budget" type="number" step="0.01" class="form-control"
                                                    required="true" />
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label fw-bold">Company Contribution</label>
                                            <div class="input-group">
                                                <span class="input-group-text">$</span>
                                                <form:input path="companyContribution" type="number" step="0.01"
                                                    class="form-control" required="true" />
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label fw-bold">Employee Contribution</label>
                                            <div class="input-group">
                                                <span class="input-group-text">$</span>
                                                <form:input path="employeeContribution" type="number" step="0.01"
                                                    class="form-control" required="true" />
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label fw-bold">Limit Value</label>
                                            <form:input path="limitValue" type="number" step="0.01" class="form-control"
                                                placeholder="Leave empty for no limit" />
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label fw-bold">Limit Basis</label>
                                            <form:select path="limitType" class="form-select">
                                                <form:option value="AMOUNT">Fixed Amount ($)</form:option>
                                                <form:option value="PERCENTAGE">Percentage of Basic Salary (%)
                                                </form:option>
                                            </form:select>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label fw-bold">Effective From</label>
                                            <form:input path="effectiveDate" type="date" class="form-control"
                                                required="true" />
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label fw-bold">Expiry Date</label>
                                            <form:input path="expiryDate" type="date" class="form-control" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Eligibility & Workflow -->
                            <div class="card border-0 shadow-sm mb-4">
                                <div class="card-header bg-white py-3">
                                    <h5 class="mb-0 text-dark"><i class="bi bi-shield-check me-2"></i> Eligibility &
                                        Operational Logic</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">Participation Criteria</label>
                                            <form:textarea path="eligibilityCriteria" class="form-control" rows="4"
                                                placeholder="e.g. Minimum 1 year tenure, Full-time employees only..." />
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">Processing Workflow</label>
                                            <form:textarea path="processingWorkflow" class="form-control" rows="4"
                                                placeholder="Steps for approval, required documentation..." />
                                        </div>
                                        <div class="col-12">
                                            <label class="form-label fw-bold">HR Important Notes</label>
                                            <form:textarea path="importantNotes" class="form-control" rows="2"
                                                placeholder="Internal notes for HR staff..." />
                                        </div>
                                        <div class="col-12">
                                            <div class="form-check form-switch p-3 border rounded bg-light">
                                                <form:checkbox path="active" class="form-check-input ms-0 me-2"
                                                    id="activeStatus" />
                                                <label class="form-check-label fw-bold" for="activeStatus">Policy
                                                    Status: Active and Visible to Employees</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="text-end">
                                <button type="submit" class="btn btn-primary px-5 py-2 shadow border-0">
                                    <i class="bi bi-save me-1"></i> Save Benefit Policy
                                </button>
                            </div>
                        </form:form>
                    </div>
                </div>
            </div>

            <jsp:include page="../common/footer.jsp" />