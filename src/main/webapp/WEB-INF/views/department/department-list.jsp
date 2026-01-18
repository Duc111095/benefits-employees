<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:set var="pageTitle" value="Departments" scope="request" />
        <jsp:include page="../common/header.jsp" />

        <div class="container mt-4">
            <div class="row mb-4">
                <div class="col-md-8">
                    <h2><i class="bi bi-building"></i> Department Management</h2>
                </div>
                <div class="col-md-4 text-end">
                    <a href="<c:url value='/department/new'/>" class="btn btn-primary">
                        <i class="bi bi-plus-circle"></i> Add Department
                    </a>
                </div>
            </div>

            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="card shadow-sm">
                <div class="card-header bg-white">
                    <form action="<c:url value='/department/search'/>" method="get" class="row g-3">
                        <div class="col-md-10">
                            <input type="text" class="form-control" name="keyword" placeholder="Search departments..."
                                value="${keyword}">
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-secondary w-100">
                                <i class="bi bi-search"></i> Search
                            </button>
                        </div>
                    </form>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>Code</th>
                                    <th>Name</th>
                                    <th>Description</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty departments}">
                                        <tr>
                                            <td colspan="5" class="text-center text-muted">
                                                No departments found
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${departments}" var="dept">
                                            <tr>
                                                <td><strong>${dept.code}</strong></td>
                                                <td>${dept.name}</td>
                                                <td>${dept.description}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${dept.active}">
                                                            <span class="badge bg-success">Active</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">Inactive</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <a href="<c:url value='/department/edit/${dept.id}'/>"
                                                        class="btn btn-sm btn-outline-primary">
                                                        <i class="bi bi-pencil"></i> Edit
                                                    </a>
                                                    <a href="<c:url value='/department/delete/${dept.id}'/>"
                                                        class="btn btn-sm btn-outline-danger"
                                                        onclick="return confirm('Are you sure you want to delete this department?')">
                                                        <i class="bi bi-trash"></i> Delete
                                                    </a>
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

        <jsp:include page="../common/footer.jsp" />