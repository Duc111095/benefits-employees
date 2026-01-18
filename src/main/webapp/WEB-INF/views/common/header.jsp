<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>
                    <c:out value="${pageTitle}" default="Benefits Management System" />
                </title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
                <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
            </head>

            <body>
                <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
                    <div class="container-fluid">
                        <a class="navbar-brand" href="<c:url value='/dashboard'/>">
                            <i class="bi bi-gift"></i> Benefits System
                        </a>
                        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                            data-bs-target="#navbarNav">
                            <span class="navbar-toggler-icon"></span>
                        </button>
                        <div class="collapse navbar-collapse" id="navbarNav">
                            <ul class="navbar-nav ms-auto mb-2 mb-lg-0 align-items-center">
                                <!-- Notifications -->
                                <li class="nav-item me-3">
                                    <a class="nav-link position-relative" href="<c:url value='/notifications'/>">
                                        <i class="bi bi-bell fs-5"></i>
                                        <c:if test="${unreadNotificationCount > 0}">
                                            <span
                                                class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger"
                                                style="margin-top: 5px;">
                                                ${unreadNotificationCount}
                                            </span>
                                        </c:if>
                                    </a>
                                </li>

                                <sec:authorize access="hasAnyRole('HR_MANAGER', 'ADMIN')">
                                    <li class="nav-item me-2">
                                        <a class="btn btn-sm btn-outline-warning"
                                            href="<c:url value='/notifications/broadcast'/>">
                                            <i class="bi bi-megaphone"></i> Broadcast
                                        </a>
                                    </li>
                                </sec:authorize>

                                <li class="nav-item">
                                    <a class="nav-link ${pageTitle == 'Dashboard' ? 'active' : ''}"
                                        href="<c:url value='/dashboard'/>">
                                        <i class="bi bi-speedometer2"></i> Dashboard
                                    </a>
                                </li>

                                <%-- Self-Service for all roles, especially Employees --%>
                                    <li class="nav-item dropdown">
                                        <a class="nav-link dropdown-toggle ${pageTitle.startsWith('My ') ? 'active' : ''}"
                                            href="#" role="button" data-bs-toggle="dropdown">
                                            <i class="bi bi-person-lines-fill"></i> Self-Service
                                        </a>
                                        <ul class="dropdown-menu">
                                            <li><a class="dropdown-item"
                                                    href="<c:url value='/self-service/benefits'/>">My Benefits</a></li>
                                            <li><a class="dropdown-item" href="<c:url value='/self-service/claims'/>">My
                                                    Claims</a></li>
                                            <li>
                                                <hr class="dropdown-divider">
                                            </li>
                                            <li><a class="dropdown-item"
                                                    href="<c:url value='/self-service/profile'/>">My Profile</a></li>
                                        </ul>
                                    </li>

                                    <sec:authorize access="hasAnyRole('ADMIN', 'HR_MANAGER')">
                                        <li class="nav-item">
                                            <a class="nav-link ${pageTitle == 'Employees' ? 'active' : ''}"
                                                href="<c:url value='/employee'/>">
                                                <i class="bi bi-people"></i> Employees
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link ${pageTitle == 'Departments' ? 'active' : ''}"
                                                href="<c:url value='/department'/>">
                                                <i class="bi bi-building"></i> Departments
                                            </a>
                                        </li>
                                        <li class="nav-item dropdown">
                                            <a class="nav-link dropdown-toggle ${pageTitle == 'Benefit Plans' ? 'active' : ''}"
                                                href="#" role="button" data-bs-toggle="dropdown">
                                                <i class="bi bi-gift"></i> Benefits
                                            </a>
                                            <ul class="dropdown-menu">
                                                <li><a class="dropdown-item"
                                                        href="<c:url value='/benefit/plans'/>">Benefit Plans</a></li>
                                                <li><a class="dropdown-item"
                                                        href="<c:url value='/benefit/types'/>">Benefit Types</a></li>
                                            </ul>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link ${pageTitle == 'Enrollments' ? 'active' : ''}"
                                                href="<c:url value='/hr/enrollments'/>">
                                                <i class="bi bi-card-checklist"></i> Enrollments
                                            </a>
                                        </li>
                                    </sec:authorize>
                                    <sec:authorize access="hasAnyRole('MANAGER')">
                                        <li class="nav-item">
                                            <a class="nav-link ${pageTitle == 'Claims' ? 'active' : ''}"
                                                href="<c:url value='/manager/claims'/>">
                                                <i class="bi bi-file-earmark-medical"></i> Claims
                                            </a>
                                        </li>
                                    </sec:authorize>
                                    <sec:authorize access="hasAnyRole('ADMIN', 'HR_MANAGER', 'MANAGER')">
                                        <li class="nav-item">
                                            <a class="nav-link ${pageTitle == 'Reports' ? 'active' : ''}"
                                                href="<c:url value='/manager/reports'/>">
                                                <i class="bi bi-bar-chart"></i> Reports
                                            </a>
                                        </li>
                                    </sec:authorize>
                            </ul>
                            <ul class="navbar-nav">
                                <li class="nav-item dropdown">
                                    <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
                                        data-bs-toggle="dropdown">
                                        <i class="bi bi-person-circle"></i>
                                        <sec:authentication property="principal.username" />
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end">
                                        <li><a class="dropdown-item"
                                                href="<c:url value='/self-service/profile'/>">Profile</a></li>
                                        <li>
                                            <hr class="dropdown-divider">
                                        </li>
                                        <li>
                                            <form action="<c:url value='/auth/logout'/>" method="post">
                                                <input type="hidden" name="${_csrf.parameterName}"
                                                    value="${_csrf.token}" />
                                                <button type="submit" class="dropdown-item">
                                                    <i class="bi bi-box-arrow-right"></i> Logout
                                                </button>
                                            </form>
                                        </li>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                    </div>
                </nav>