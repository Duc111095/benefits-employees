<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Employee Registration - Benefits System</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
            <link href="<c:url value='/css/style.css'/>" rel="stylesheet">
        </head>

        <body class="bg-light">

            <div class="container">
                <div class="row justify-content-center mt-5">
                    <div class="col-md-6 col-lg-5">
                        <div class="card shadow-lg border-0 rounded-lg mt-5">
                            <div class="card-header bg-primary text-white text-center py-4">
                                <h3 class="font-weight-light my-2">Create Account</h3>
                                <p class="mb-0">Enter your employee details to register</p>
                            </div>
                            <div class="card-body p-4">
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                        <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"
                                            aria-label="Close"></button>
                                    </div>
                                </c:if>

                                <c:if test="${not empty success}">
                                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                                        <i class="bi bi-check-circle-fill me-2"></i> ${success}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"
                                            aria-label="Close"></button>
                                    </div>
                                </c:if>

                                <form action="<c:url value='/auth/register'/>" method="post" id="registrationForm">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                                    <div class="form-floating mb-3">
                                        <input class="form-control" id="employeeCode" name="employeeCode" type="text"
                                            placeholder="EMP001" required />
                                        <label for="employeeCode"><i class="bi bi-person-badge"></i> Employee
                                            Code</label>
                                        <div class="form-text">As provided by HR (e.g., EMP001)</div>
                                    </div>

                                    <div class="form-floating mb-3">
                                        <input class="form-control" id="username" name="username" type="text"
                                            placeholder="username" required />
                                        <label for="username"><i class="bi bi-person"></i> Desired Username</label>
                                    </div>

                                    <div class="form-floating mb-3">
                                        <input class="form-control" id="email" name="email" type="email"
                                            placeholder="name@example.com" required />
                                        <label for="email"><i class="bi bi-envelope"></i> Email Address</label>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <div class="form-floating mb-3 mb-md-0">
                                                <input class="form-control" id="password" name="password"
                                                    type="password" placeholder="Create a password" required />
                                                <label for="password"><i class="bi bi-lock"></i> Password</label>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-floating mb-3 mb-md-0">
                                                <input class="form-control" id="confirmPassword" name="confirmPassword"
                                                    type="password" placeholder="Confirm password" required />
                                                <label for="confirmPassword"><i class="bi bi-shield-lock"></i>
                                                    Confirm</label>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="d-grid gap-2">
                                        <button class="btn btn-primary btn-lg" type="submit">Create Account</button>
                                    </div>
                                </form>
                            </div>
                            <div class="card-footer text-center py-3 border-0">
                                <div class="small"><a href="<c:url value='/auth/login'/>">Have an account? Go to
                                        login</a></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                document.getElementById('registrationForm').addEventListener('submit', function (event) {
                    const password = document.getElementById('password').value;
                    const confirm = document.getElementById('confirmPassword').value;

                    if (password !== confirm) {
                        alert('Passwords do not match!');
                        event.preventDefault();
                    }
                });
            </script>
        </body>

        </html>