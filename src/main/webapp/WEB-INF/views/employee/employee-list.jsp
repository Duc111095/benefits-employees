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

            <div class="card shadow-sm mb-4">
                <div class="card-body bg-light">
                    <form action="<c:url value='/employee'/>" method="get" class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label small">Keyword</label>
                            <input type="text" class="form-control" name="keyword" placeholder="Name, code or email..."
                                value="${keyword}">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label small">Department</label>
                            <select class="form-select" name="departmentId">
                                <option value="">All Departments</option>
                                <c:forEach items="${departments}" var="dept">
                                    <option value="${dept.id}" ${selectedDept==dept.id ? 'selected' : '' }>
                                        ${dept.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label small">Status</label>
                            <select class="form-select" name="status">
                                <option value="">All Status</option>
                                <option value="ACTIVE" ${selectedStatus=='ACTIVE' ? 'selected' : '' }>Active</option>
                                <option value="INACTIVE" ${selectedStatus=='INACTIVE' ? 'selected' : '' }>Inactive
                                </option>
                                <option value="TERMINATED" ${selectedStatus=='TERMINATED' ? 'selected' : '' }>Terminated
                                </option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label small">Position</label>
                            <input type="text" class="form-control" name="position" placeholder="Position..."
                                value="${selectedPos}">
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-filter"></i> Filter
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card shadow-sm">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Employee</th>
                                    <th>Contact</th>
                                    <th>Organization</th>
                                    <th>Status</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty employees}">
                                        <tr>
                                            <td colspan="5" class="text-center py-4 text-muted">
                                                <i class="bi bi-search display-6 d-block mb-3"></i>
                                                No employees matched your criteria
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${employees}" var="emp">
                                            <tr>
                                                <td>
                                                    <div class="fw-medium">${emp.id}</div>
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="avatar-circle me-3">
                                                            ${emp.fullName.substring(0,1).toUpperCase()}
                                                        </div>
                                                        <div>
                                                            <div class="fw-bold">${emp.fullName}</div>
                                                            <div class="small text-muted">${emp.employeeCode}</div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="small"><i class="bi bi-envelope me-1"></i>${emp.email}
                                                    </div>
                                                    <div class="small"><i class="bi bi-phone me-1"></i>${emp.phone}
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="fw-medium">${emp.department.name}</div>
                                                    <div class="small text-muted">${emp.position}</div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${emp.status == 'ACTIVE'}">
                                                            <span
                                                                class="badge rounded-pill bg-success-subtle text-success border border-success">Active</span>
                                                        </c:when>
                                                        <c:when test="${emp.status == 'INACTIVE'}">
                                                            <span
                                                                class="badge rounded-pill bg-warning-subtle text-warning border border-warning">Inactive</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span
                                                                class="badge rounded-pill bg-danger-subtle text-danger border border-danger">Terminated</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-end">
                                                    <div class="btn-group">
                                                        <a href="<c:url value='/employee/${emp.id}'/>"
                                                            class="btn btn-sm btn-light" title="View Detail">
                                                            <i class="bi bi-eye"></i>
                                                        </a>
                                                        <a href="<c:url value='/employee/edit/${emp.id}'/>"
                                                            class="btn btn-sm btn-light text-primary" title="Edit">
                                                            <i class="bi bi-pencil"></i>
                                                        </a>
                                                        <a href="<c:url value='/employee/delete/${emp.id}'/>"
                                                            class="btn btn-sm btn-light text-danger" title="Delete"
                                                            onclick="return confirm('Delete this employee?')">
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