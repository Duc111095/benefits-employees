<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <c:set var="pageTitle" value="Benefit Plans" scope="request" />
            <jsp:include page="../common/header.jsp" />

            <div class="container mt-4">
                <div class="row mb-4">
                    <div class="col-md-8">
                        <h2><i class="bi bi-gift"></i> Benefit Plans</h2>
                    </div>
                    <div class="col-md-4 text-end">
                        <a href="<c:url value='/benefit/plans/new'/>" class="btn btn-primary">
                            <i class="bi bi-plus-circle"></i> Add Benefit Plan
                        </a>
                    </div>
                </div>

                <div class="card shadow-sm">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>Plan Name</th>
                                        <th>Type</th>
                                        <th>Budget</th>
                                        <th>Company Contr.</th>
                                        <th>Effective Date</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${benefitPlans}" var="plan">
                                        <tr>
                                            <td><strong>${plan.planName}</strong><br><small
                                                    class="text-muted">${plan.planCode}</small></td>
                                            <td>${plan.benefitType.name}</td>
                                            <td>
                                                <fmt:formatNumber value="${plan.budget}" type="currency"
                                                    currencySymbol="VND" />
                                            </td>
                                            <td>
                                                <fmt:formatNumber value="${plan.companyContribution}" type="currency"
                                                    currencySymbol="VND" />
                                            </td>
                                            <td>${plan.effectiveDate}</td>
                                            <td>
                                                <span class="badge ${plan.active ? 'bg-success' : 'bg-secondary'}">
                                                    ${plan.active ? 'Active' : 'Inactive'}
                                                </span>
                                            </td>
                                            <td>
                                                <a href="<c:url value='/benefit/plans/edit/${plan.id}'/>"
                                                    class="btn btn-sm btn-outline-primary">
                                                    <i class="bi bi-pencil"></i>
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