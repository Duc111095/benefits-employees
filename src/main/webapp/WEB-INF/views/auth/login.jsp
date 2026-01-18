<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Login - Benefits Management System</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
            <link href="<c:url value='/css/style.css'/>" rel="stylesheet">
        </head>

        <body class="bg-light">

            <div class="container">
                <div class="row justify-content-center align-items-center min-vh-100">
                    <div class="col-md-6 col-lg-5">
                        <div class="card shadow-lg border-0 rounded-lg">
                            <div class="card-header bg-primary text-white text-center py-4">
                                <h3 class="font-weight-light my-2">Benefits Management</h3>
                                <p class="mb-0">Please sign in to your account</p>
                            </div>
                            <div class="card-body p-4">
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                        <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                </c:if>

                                <c:if test="${not empty message or not empty success}">
                                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                                        <i class="bi bi-check-circle-fill me-2"></i> ${message} ${success}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                </c:if>

                                <form action="<c:url value='/auth/login'/>" method="post">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                                    <div class="form-floating mb-3">
                                        <input class="form-control" id="username" name="username" type="text"
                                            placeholder="username" required autofocus />
                                        <label for="username"><i class="bi bi-person"></i> Username</label>
                                    </div>

                                    <div class="form-floating mb-3">
                                        <input class="form-control" id="password" name="password" type="password"
                                            placeholder="Password" required />
                                        <label for="password"><i class="bi bi-lock"></i> Password</label>
                                    </div>

                                    <div class="form-check mb-3">
                                        <input class="form-check-input" id="remember" name="remember-me" type="checkbox"
                                            value="" />
                                        <label class="form-check-label" for="remember">Remember me</label>
                                    </div>

                                    <div class="d-grid gap-2">
                                        <button class="btn btn-primary btn-lg" type="submit">Sign In</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>