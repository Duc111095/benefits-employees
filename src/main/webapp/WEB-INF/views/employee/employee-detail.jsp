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
                                    <span><i class="bi bi-person-fill-gear me-2"></i> Role Type</span>
                                    <span class="badge bg-light text-dark border">Universal</span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <span><i class="bi bi-cash-stack me-2"></i> Basic Salary</span>
                                    <span class="fw-bold text-success">
                                        <fmt:formatNumber value="${employee.basicSalary}" type="currency"
                                            currencySymbol="$" />
                                    </span>
                                </li>
                            </ul>
                        </div>

                        <div class="card shadow-sm">
                            <div class="card-header bg-white">
                                <h5 class="mb-0">Contact Information</h5>
                            </div>
                            <div class="card-body">
                                <p class="mb-2"><i class="bi bi-envelope fill me-2 text-primary"></i> ${employee.email}
                                </p>
                                <p class="mb-2"><i class="bi bi-telephone fill me-2 text-primary"></i> ${not empty
                                    employee.phone ?
                                    employee.phone : 'N/A'}</p>
                                <hr>
                                <div class="small text-muted mb-1">Residential Address</div>
                                <p class="mb-0 small">${not empty employee.address ? employee.address : 'No address
                                    provided'}</p>
                            </div>
                        </div>
                    </div>

                    <!-- Main Content -->
                    <div class="col-md-8">
                        <div class="card shadow-sm mb-4">
                            <div class="card-header bg-white">
                                <h5 class="mb-0">Personal Profile</h5>
                            </div>
                            <div class="card-body">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <div class="p-3 border rounded bg-light">
                                            <div class="text-muted small mb-1">Full Identity</div>
                                            <div class="fw-bold h5 mb-0">${employee.fullName}</div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="p-3 border rounded bg-light">
                                            <div class="text-muted small mb-1">Gender</div>
                                            <div class="fw-bold">${not empty employee.gender ? employee.gender : 'N/A'}
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="p-3 border rounded bg-light">
                                            <div class="text-muted small mb-1">Birth Date</div>
                                            <div class="fw-bold">
                                                <fmt:parseDate value="${employee.dateOfBirth}" pattern="yyyy-MM-dd"
                                                    var="dob" />
                                                <fmt:formatDate value="${dob}" pattern="MMM dd, yyyy" />
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="p-3 border rounded bg-light">
                                            <div class="text-muted small mb-1">Corporate ID</div>
                                            <div class="fw-bold text-primary">${employee.employeeCode}</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="p-3 border rounded bg-light">
                                            <div class="text-muted small mb-1">Onboarding Date</div>
                                            <div class="fw-bold">
                                                <fmt:parseDate value="${employee.hireDate}" pattern="yyyy-MM-dd"
                                                    var="hdate" />
                                                <fmt:formatDate value="${hdate}" pattern="MMM dd, yyyy" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="card shadow-sm">
                            <div class="card-header bg-white d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Active Benefit Enrollments</h5>
                                <a href="<c:url value='/enrollment/new?employeeId=${employee.id}'/>"
                                    class="btn btn-sm btn-outline-success">
                                    <i class="bi bi-lightning-charge"></i> New Enrollment
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
                                                <th class="text-end">Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td colspan="4" class="text-center text-muted py-5">
                                                    <i class="bi bi-shield-lock display-6 d-block mb-3"></i>
                                                    No active benefits discovered for this record.
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <jsp:include page="../common/footer.jsp" />