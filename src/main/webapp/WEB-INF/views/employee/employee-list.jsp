<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:set var="pageTitle" value="Employees" scope="request" />
        <jsp:include page="../common/header.jsp" />

        <div class="container mt-4">
            <div class="row mb-4">
                <div class="col-md-8">
                    <h2><i class="bi bi-people"></i> Employee Management</h2>
                </div>
                <div class="col-md-4 text-end">
                    <a href="<c:url value='/employee/new'/>" class="btn btn-primary">
                        <i class="bi bi-person-plus"></i> Add Employee
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
                    <form action="<c:url value='/employee/search'/>" method="get" class="row g-3">
                        <div class="col-md-10">
                            <input type="text" class="form-control" name="keyword"
                                placeholder="Search by name, code or email..." value="${keyword}">
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
                                    <th>Full Name</th>
                                    <th>Email</th>
                                    <th>Department</th>
                                    <th>Position</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty employees}">
                                        <tr>
                                            <td colspan="7" class="text-center text-muted">
                                                No employees found
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${employees}" var="emp">
                                            <tr data-href="<c:url value='/employee/${emp.id}'/>"
                                                style="cursor: pointer;">
                                                <td><strong>${emp.employeeCode}</strong></td>
                                                <td>${emp.fullName}</td>
                                                <td>${emp.email}</td>
                                                <td>${emp.department.name}</td>
                                                <td>${emp.position}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${emp.status == 'ACTIVE'}">
                                                            <span class="badge bg-success">${emp.status}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">${emp.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="btn-group">
                                                        <a href="<c:url value='/employee/${emp.id}'/>"
                                                            class="btn btn-sm btn-outline-info" title="View">
                                                            <i class="bi bi-eye"></i>
                                                        </a>
                                                        <a href="<c:url value='/employee/edit/${emp.id}'/>"
                                                            class="btn btn-sm btn-outline-primary" title="Edit">
                                                            <i class="bi bi-pencil"></i>
                                                        </a>
                                                        <a href="<c:url value='/employee/delete/${emp.id}'/>"
                                                            class="btn btn-sm btn-outline-danger" title="Delete"
                                                            onclick="return confirm('Are you sure you want to delete this employee?')">
                                                            <i class="bi bi-trash"></i>
                                                        </a>
                                                    </div>
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