<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:set var="pageTitle" value="Dashboard" scope="request" />
        <jsp:include page="common/header.jsp" />

        <div class="container mt-4">
            <h2 class="mb-4"><i class="bi bi-speedometer2"></i> Dashboard</h2>

            <div class="row g-4">
                <!-- Total Employees Card -->
                <div class="col-md-3">
                    <div class="card dashboard-card primary shadow-sm">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="text-muted mb-2">Total Employees</h6>
                                    <h3 class="mb-0">100</h3>
                                </div>
                                <div class="text-primary">
                                    <i class="bi bi-people fs-1"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Active Enrollments Card -->
                <div class="col-md-3">
                    <div class="card dashboard-card success shadow-sm">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="text-muted mb-2">Active Enrollments</h6>
                                    <h3 class="mb-0">250</h3>
                                </div>
                                <div class="text-success">
                                    <i class="bi bi-card-checklist fs-1"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Pending Claims Card -->
                <div class="col-md-3">
                    <div class="card dashboard-card warning shadow-sm">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="text-muted mb-2">Pending Claims</h6>
                                    <h3 class="mb-0">15</h3>
                                </div>
                                <div class="text-warning">
                                    <i class="bi bi-clock-history fs-1"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Total Benefits Card -->
                <div class="col-md-3">
                    <div class="card dashboard-card danger shadow-sm">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="text-muted mb-2">Benefit Plans</h6>
                                    <h3 class="mb-0">12</h3>
                                </div>
                                <div class="text-danger">
                                    <i class="bi bi-gift fs-1"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mt-4">
                <div class="col-md-8">
                    <div class="card shadow-sm">
                        <div class="card-header bg-white">
                            <h5 class="mb-0"><i class="bi bi-activity"></i> Recent Activities</h5>
                        </div>
                        <div class="card-body">
                            <div class="list-group list-group-flush">
                                <div class="list-group-item">
                                    <div class="d-flex w-100 justify-content-between">
                                        <h6 style="cursor: pointer; color: rgb(53, 53, 139);" class="mb-1">New
                                            enrollment created
                                        </h6>
                                        <small class="text-muted">2 hours ago</small>
                                    </div>
                                    <p class="mb-1">Employee EMP001 enrolled in Health Insurance Premium</p>
                                </div>
                                <div class="list-group-item">
                                    <div class="d-flex w-100 justify-content-between">
                                        <h6 style="cursor: pointer; color: rgb(65, 143, 78);" class="mb-1">Claim
                                            approved</h6>
                                        <small class="text-muted">5 hours ago</small>
                                    </div>
                                    <p class="mb-1">Medical claim for 1,500,000 VND approved</p>
                                </div>
                                <div class="list-group-item">
                                    <div class="d-flex w-100 justify-content-between">
                                        <h6 style="cursor: pointer; color: rgb(153, 45, 54);" class="mb-1">New employee
                                            added</h6>
                                        <small class="text-muted">1 day ago</small>
                                    </div>
                                    <p class="mb-1">Employee EMP011 added to IT Department</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card shadow-sm">
                        <div class="card-header bg-white">
                            <h5 class="mb-0"><i class="bi bi-exclamation-triangle"></i> Alerts</h5>
                        </div>
                        <div class="card-body">
                            <div class="alert alert-warning alert-permanent mb-2">
                                <strong>15 claims</strong> pending approval
                            </div>
                            <div class="alert alert-info alert-permanent mb-2">
                                <strong>3 benefit plans</strong> expiring this month
                            </div>
                            <div class="alert alert-success alert-permanent mb-0">
                                System running smoothly
                            </div>
                        </div>
                    </div>

                    <div class="card shadow-sm mt-3">
                        <div class="card-header bg-white">
                            <h5 class="mb-0"><i class="bi bi-link-45deg"></i> Quick Links</h5>
                        </div>
                        <div class="card-body">
                            <div class="d-grid gap-2">
                                <sec:authorize access="hasAnyRole('ADMIN', 'HR_MANAGER')">
                                    <a href="<c:url value='/employee/new'/>" class="btn btn-outline-primary">
                                        <i class="bi bi-person-plus"></i> Add Employee
                                    </a>
                                    <a href="<c:url value='/hr/enrollment/new'/>" class="btn btn-outline-success">
                                        <i class="bi bi-plus-circle"></i> New Enrollment
                                    </a>
                                </sec:authorize>
                                <a href="<c:url value='/self-service/claims'/>" class="btn btn-outline-warning">
                                    <i class="bi bi-file-earmark-medical"></i> Create Claim
                                </a>
                                <a href="<c:url value='/self-service/benefits'/>" class="btn btn-outline-warning">
                                    <i class="bi bi-file-earmark-medical"></i> Enroll
                                </a>
                                <sec:authorize access="hasAnyRole('ADMIN', 'HR_MANAGER', 'MANAGER')">
                                    <a href="<c:url value='/report'/>" class="btn btn-outline-info">
                                        <i class="bi bi-bar-chart"></i> Generate Report
                                    </a>
                                </sec:authorize>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="common/footer.jsp" />