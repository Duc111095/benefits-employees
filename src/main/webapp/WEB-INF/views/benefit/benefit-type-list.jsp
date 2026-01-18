<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <c:set var="pageTitle" value="Benefit Types" scope="request" />
            <jsp:include page="../common/header.jsp" />

            <div class="container mt-4">
                <div class="row mb-4 align-items-center">
                    <div class="col-md-6">
                        <h2 class="mb-0"><i class="bi bi-tag-fill text-primary me-2"></i> Benefit Types</h2>
                        <p class="text-muted small mb-0">Manage categories of benefits available to employees</p>
                    </div>
                    <div class="col-md-6 text-end">
                        <a href="<c:url value='/benefit/types/new'/>" class="btn btn-primary shadow-sm">
                            <i class="bi bi-plus-lg me-1"></i> New Benefit Type
                        </a>
                    </div>
                </div>

                <!-- Alert Messages -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i> ${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <div class="card border-0 shadow-sm">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="bg-light">
                                    <tr>
                                        <th class="ps-4">Code</th>
                                        <th>Name</th>
                                        <th>Description</th>
                                        <th class="text-center">Status</th>
                                        <th class="text-end pe-4">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:if test="${empty benefitTypes}">
                                        <tr>
                                            <td colspan="5" class="text-center py-5">
                                                <i class="bi bi-inbox display-4 d-block mb-3 text-muted"></i>
                                                <p class="text-muted">No benefit types found.</p>
                                            </td>
                                        </tr>
                                    </c:if>
                                    <c:forEach items="${benefitTypes}" var="type">
                                        <tr>
                                            <td class="ps-4">
                                                <span class="badge bg-light text-dark border">${type.code}</span>
                                            </td>
                                            <td class="fw-bold text-primary">
                                                ${type.name}
                                            </td>
                                            <td class="text-muted small">
                                                ${type.description}
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${type.active}">
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
                                                <a href="<c:url value='/benefit/types/edit/${type.id}'/>"
                                                    class="btn btn-sm btn-light border" title="Edit Type">
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