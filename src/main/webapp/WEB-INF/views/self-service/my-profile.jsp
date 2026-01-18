<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <c:set var="pageTitle" value="My Profile" scope="request" />
            <jsp:include page="../common/header.jsp" />

            <div class="container mt-4">
                <div class="row justify-content-center">
                    <div class="col-md-8">
                        <div class="card shadow-sm">
                            <div class="card-header bg-primary text-white">
                                <h5 class="mb-0"><i class="bi bi-person-circle"></i> My Personal Information</h5>
                            </div>
                            <div class="card-body">
                                <div class="text-center mb-4">
                                    <img src="https://ui-avatars.com/api/?name=${employee.fullName}&size=100&background=random"
                                        class="rounded-circle shadow-sm" alt="Avatar">
                                    <h4 class="mt-2">${employee.fullName}</h4>
                                    <span class="badge bg-info">${employee.position}</span>
                                </div>

                                <div class="row mb-3 border-bottom pb-2">
                                    <div class="col-sm-4 text-muted">Employee Code</div>
                                    <div class="col-sm-8 fw-bold">${employee.employeeCode}</div>
                                </div>
                                <div class="row mb-3 border-bottom pb-2">
                                    <div class="col-sm-4 text-muted">Email</div>
                                    <div class="col-sm-8 fw-bold">${employee.email}</div>
                                </div>
                                <div class="row mb-3 border-bottom pb-2">
                                    <div class="col-sm-4 text-muted">Phone</div>
                                    <div class="col-sm-8 fw-bold">${not empty employee.phone ? employee.phone : 'Not
                                        provided'}</div>
                                </div>
                                <div class="row mb-3 border-bottom pb-2">
                                    <div class="col-sm-4 text-muted">Department</div>
                                    <div class="col-sm-8 fw-bold">${employee.department.name}</div>
                                </div>
                                <div class="row mb-3 border-bottom pb-2">
                                    <div class="col-sm-4 text-muted">Hire Date</div>
                                    <div class="col-sm-8 fw-bold">${employee.hireDate}</div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-sm-4 text-muted">Date of Birth</div>
                                    <div class="col-sm-8 fw-bold">${not empty employee.dateOfBirth ?
                                        employee.dateOfBirth : 'Not provided'}</div>
                                </div>

                                <div class="mt-4 text-center">
                                    <button class="btn btn-outline-primary"
                                        onclick="alert('Profile edit functionality will be available soon.')">
                                        <i class="bi bi-pencil"></i> Request Profile Update
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <jsp:include page="../common/footer.jsp" />