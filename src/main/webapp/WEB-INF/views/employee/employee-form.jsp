<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:set var="pageTitle" value="${isEdit ? 'Edit Employee' : 'New Employee'}" scope="request" />
        <jsp:include page="../common/header.jsp" />

        <div class="container mt-4">
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
            <div class="row justify-content-center">
                <div class="col-md-10">
                    <div class="card shadow-sm">
                        <div class="card-header bg-primary text-white">
                            <h4 class="mb-0">
                                <i class="bi bi-person-plus"></i>
                                ${isEdit ? 'Edit Employee' : 'New Employee'}
                            </h4>
                        </div>
                        <div class="card-body">
                            <form action="<c:url value='/employee/save'/>" method="post" class="needs-validation"
                                novalidate>
                                <input type="hidden" name="id" value="${employee.id}">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="employeeCode" class="form-label">Employee Code *</label>
                                        <input type="text" class="form-control" id="employeeCode" name="employeeCode"
                                            value="${employee.employeeCode}" required maxlength="20" ${isEdit
                                            ? 'readonly' : '' }>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="fullName" class="form-label">Full Name *</label>
                                        <input type="text" class="form-control" id="fullName" name="fullName"
                                            value="${employee.fullName}" required maxlength="100">
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="email" class="form-label">Email Address *</label>
                                        <input type="email" class="form-control" id="email" name="email"
                                            value="${employee.email}" required maxlength="100">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="phone" class="form-label">Phone Number</label>
                                        <input type="text" class="form-control" id="phone" name="phone"
                                            value="${employee.phone}" maxlength="20">
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="dateOfBirth" class="form-label">Date of Birth</label>
                                        <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth"
                                            value="${employee.dateOfBirth}">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="hireDate" class="form-label">Hire Date *</label>
                                        <input type="date" class="form-control" id="hireDate" name="hireDate"
                                            value="${employee.hireDate}" required>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="gender" class="form-label">Gender</label>
                                        <div class="mt-2">
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input" type="radio" name="gender"
                                                    id="genderMale" value="MALE" ${employee.gender=='MALE' ? 'checked'
                                                    : '' }>
                                                <label class="form-check-label" for="genderMale">Male</label>
                                            </div>
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input" type="radio" name="gender"
                                                    id="genderFemale" value="FEMALE" ${employee.gender=='FEMALE'
                                                    ? 'checked' : '' }>
                                                <label class="form-check-label" for="genderFemale">Female</label>
                                            </div>
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input" type="radio" name="gender"
                                                    id="genderOther" value="OTHER" ${employee.gender=='OTHER'
                                                    ? 'checked' : '' }>
                                                <label class="form-check-label" for="genderOther">Other</label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="basicSalary" class="form-label">Basic Salary (USD) *</label>
                                        <div class="input-group">
                                            <span class="input-group-text">$</span>
                                            <input type="number" class="form-control" id="basicSalary"
                                                name="basicSalary" value="${employee.basicSalary}" required step="0.01"
                                                min="0">
                                        </div>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="address" class="form-label">Residential Address</label>
                                    <textarea class="form-control" id="address" name="address"
                                        rows="2">${employee.address}</textarea>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="department" class="form-label">Department *</label>
                                        <select class="form-select" id="department" name="department.id" required>
                                            <option value="">Select Department</option>
                                            <c:forEach items="${departments}" var="dept">
                                                <option value="${dept.id}" ${employee.department.id==dept.id
                                                    ? 'selected' : '' }>
                                                    ${dept.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="position" class="form-label">Position *</label>
                                        <input type="text" class="form-control" id="position" name="position"
                                            value="${employee.position}" required maxlength="100">
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="status" class="form-label">Employee Status</label>
                                        <select class="form-select border-primary" id="status" name="status">
                                            <option value="ACTIVE" ${employee.status=='ACTIVE' ? 'selected' : '' }>
                                                ACTIVE</option>
                                            <option value="INACTIVE" ${employee.status=='INACTIVE' ? 'selected' : '' }>
                                                INACTIVE</option>
                                            <option value="TERMINATED" ${employee.status=='TERMINATED' ? 'selected' : ''
                                                }>TERMINATED</option>
                                        </select>
                                        <div class="form-text">Note: Terminating an employee will disable their login
                                            account.</div>
                                    </div>
                                    <c:if test="${!isEdit}">
                                        <div class="col-md-6 d-flex align-items-center justify-content-center">
                                            <div class="card bg-light w-100 border-dashed p-2 text-center">
                                                <div class="form-check form-switch d-inline-block">
                                                    <input class="form-check-input" type="checkbox" id="createAccount"
                                                        name="createAccount" value="true" checked>
                                                    <label class="form-check-label fw-bold"
                                                        for="createAccount">Provision System Access</label>
                                                </div>
                                                <div class="small text-muted mt-1">Creates user account with default
                                                    password</div>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>

                                <div class="d-flex justify-content-between mt-4">
                                    <a href="<c:url value='/employee'/>" class="btn btn-secondary">
                                        <i class="bi bi-x-circle"></i> Cancel
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-check-circle"></i> Save Employee
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="../common/footer.jsp" />