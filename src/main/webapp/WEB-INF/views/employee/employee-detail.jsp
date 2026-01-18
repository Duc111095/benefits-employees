<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <c:set var="pageTitle" value="Employee Details - ${employee.fullName}" scope="request" />
            <jsp:include page="../common/header.jsp" />

            <div class="container mt-4">
                <div class="row mb-4">
                    <div class="col-md-8">
                        <h2><i class="bi bi-person-badge"></i> Employee Details</h2>
                    </div>
                    <div class="col-md-4 text-end">
                        <a href="<c:url value='/employee/edit/${employee.id}'/>" class="btn btn-primary">
                            <i class="bi bi-pencil"></i> Edit Employee
                        </a>
                        <a href="<c:url value='/employee'/>" class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> Back to List
                        </a>
                    </div>
                </div>

                <div class="row">
                    <!-- Profile Sidebar -->
                    <div class="col-md-4">
                        <div class="card shadow-sm mb-4">
                            <div class="card-body text-center">
                                <img src="https://ui-avatars.com/api/?name=${employee.fullName}&size=128&background=random"
                                    class="rounded-circle mb-3" alt="Avatar">
                                <h4>${employee.fullName}</h4>
                                <p class="text-muted">${employee.position}</p>
                                <span
                                    class="badge ${employee.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'} px-3 py-2">
                                    ${employee.status}
                                </span>
                            </div>
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <span><i class="bi bi-building me-2"></i> Department</span>
                                    <span class="fw-bold text-primary">${employee.department.name}</span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <span><i class="bi bi-qr-code me-2"></i> Employee Code</span>
                                    <span class="fw-bold">${employee.employeeCode}</span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <span><i class="bi bi-calendar-check me-2"></i> Hire Date</span>
                                    <span>${employee.hireDate}</span>
                                </li>
                            </ul>
                        </div>

                        <div class="card shadow-sm">
                            <div class="card-header bg-white">
                                <h5 class="mb-0">Contact Information</h5>
                            </div>
                            <div class="card-body">
                                <p class="mb-2"><i class="bi bi-envelope me-2"></i> ${employee.email}</p>
                                <p class="mb-0"><i class="bi bi-phone me-2"></i> ${not empty employee.phone ?
                                    employee.phone : 'N/A'}</p>
                            </div>
                        </div>
                    </div>

                    <!-- Main Content -->
                    <div class="col-md-8">
                        <div class="card shadow-sm mb-4">
                            <div class="card-header bg-white d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Active Benefits</h5>
                                <a href="<c:url value='/enrollment/new?employeeId=${employee.id}'/>"
                                    class="btn btn-sm btn-outline-success">
                                    <i class="bi bi-plus"></i> Enroll in Benefit
                                </a>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Benefit Plan</th>
                                                <th>Effective Date</th>
                                                <th>Contribution</th>
                                                <th>Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <!-- This would be populated from Enrollment module -->
                                            <tr>
                                                <td colspan="4" class="text-center text-muted py-4">
                                                    No active benefits found.
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <div class="card shadow-sm">
                            <div class="card-header bg-white">
                                <h5 class="mb-0">Personal Information</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-sm-4">
                                        <p class="text-muted mb-1">Full Name</p>
                                        <p class="fw-bold">${employee.fullName}</p>
                                    </div>
                                    <div class="col-sm-4">
                                        <p class="text-muted mb-1">Date of Birth</p>
                                        <p class="fw-bold">${not empty employee.dateOfBirth ? employee.dateOfBirth :
                                            'N/A'}</p>
                                    </div>
                                    <div class="col-sm-4">
                                        <p class="text-muted mb-1">Gender</p>
                                        <p class="fw-bold">N/A</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <jsp:include page="../common/footer.jsp" />