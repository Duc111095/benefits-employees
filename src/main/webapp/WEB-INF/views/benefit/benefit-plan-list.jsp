<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <c:set var="pageTitle" value="Benefit Plans" scope="request" />
            <jsp:include page="../common/header.jsp" />

            <div class="container mt-4">
                <div class="row mb-4 align-items-center">
                    <div class="col-md-6">
                        <h2 class="mb-0"><i class="bi bi-gift-fill text-primary me-2"></i> Benefit Plans</h2>
                        <p class="text-muted small mb-0">Manage corporate benefit offerings and eligibility policies</p>
                    </div>
                    <div class="col-md-6 text-end">
                        <a href="<c:url value='/benefit/plans/new'/>" class="btn btn-primary shadow-sm">
                            <i class="bi bi-plus-lg me-1"></i> New Benefit Plan
                        </a>
                    </div>
                </div>

                <!-- Filter Bar -->
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-body bg-light rounded">
                        <form action="<c:url value='/benefit/plans'/>" method="get" class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label small fw-bold">Search</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-white border-end-0"><i
                                            class="bi bi-search"></i></span>
                                    <input type="text" name="keyword" class="form-control border-start-0"
                                        placeholder="Name or code..." value="${keyword}">
                                </div>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label small fw-bold">Benefit Type</label>
                                <select name="typeId" class="form-select">
                                    <option value="">All Types</option>
                                    <c:forEach items="${benefitTypes}" var="type">
                                        <option value="${type.id}" ${selectedType==type.id ? 'selected' : '' }>
                                            ${type.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label small fw-bold">Status</label>
                                <select name="active" class="form-select">
                                    <option value="">All Status</option>
                                    <option value="true" ${selectedStatus==true ? 'selected' : '' }>Active Only</option>
                                    <option value="false" ${selectedStatus==false ? 'selected' : '' }>Inactive Only
                                    </option>
                                </select>
                            </div>
                            <div class="col-md-2 d-flex align-items-end">
                                <button type="submit" class="btn btn-dark w-100">Filter</button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="card border-0 shadow-sm">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="bg-light">
                                    <tr>
                                        <th class="ps-4">Plan Identification</th>
                                        <th>Category</th>
                                        <th>Financials</th>
                                        <th>Period</th>
                                        <th class="text-center">Status</th>
                                        <th class="text-end pe-4">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:if test="${empty benefitPlans}">
                                        <tr>
                                            <td colspan="6" class="text-center py-5">
                                                <i class="bi bi-inbox display-4 d-block mb-3 text-muted"></i>
                                                <p class="text-muted">No benefit plans found matching your criteria.</p>
                                            </td>
                                        </tr>
                                    </c:if>
                                    <c:forEach items="${benefitPlans}" var="plan">
                                        <tr>
                                            <td class="ps-4">
                                                <div class="fw-bold text-primary">${plan.planName}</div>
                                                <div class="text-muted small">${plan.planCode}</div>
                                            </td>
                                            <td>
                                                <span class="badge bg-info text-dark">${plan.benefitType.name}</span>
                                            </td>
                                            <td>
                                                <div class="small">
                                                    <span class="text-muted">Budget:</span>
                                                    <span class="fw-bold">
                                                        <fmt:formatNumber value="${plan.budget}" type="currency"
                                                            currencySymbol="$" />
                                                    </span>
                                                </div>
                                                <div class="small">
                                                    <span class="text-muted">Co. Contr:</span>
                                                    <span class="text-success">
                                                        <fmt:formatNumber value="${plan.companyContribution}"
                                                            type="currency" currencySymbol="$" />
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="small"><i class="bi bi-calendar-event me-1"></i>
                                                    ${plan.effectiveDate}</div>
                                                <c:if test="${not empty plan.expiryDate}">
                                                    <div class="small text-danger"><i class="bi bi-calendar-x me-1"></i>
                                                        ${plan.expiryDate}</div>
                                                </c:if>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${plan.active}">
                                                        <span
                                                            class="badge rounded-pill bg-success-subtle text-success border border-success px-3">Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span
                                                            class="badge rounded-pill bg-secondary-subtle text-secondary border border-secondary px-3">Inactive</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end pe-4">
                                                <a href="<c:url value='/benefit/plans/edit/${plan.id}'/>"
                                                    class="btn btn-sm btn-light border" title="Edit Policy">
                                                    <i class="bi bi-pencil-square text-primary"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <jsp:include page="../common/footer.jsp" />