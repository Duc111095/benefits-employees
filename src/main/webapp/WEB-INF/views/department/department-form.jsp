<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:set var="pageTitle" value="${isEdit ? 'Edit Department' : 'New Department'}" scope="request" />
        <jsp:include page="../common/header.jsp" />

        <div class="container mt-4">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="card shadow-sm">
                        <div class="card-header bg-primary text-white">
                            <h4 class="mb-0">
                                <i class="bi bi-building"></i>
                                ${isEdit ? 'Edit Department' : 'New Department'}
                            </h4>
                        </div>
                        <div class="card-body">
                            <form action="<c:url value='/department/save'/>" method="post">
                                <input type="hidden" name="id" value="${department.id}">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                                <div class="mb-3">
                                    <label for="code" class="form-label">Department Code *</label>
                                    <input type="text" class="form-control" id="code" name="code"
                                        value="${department.code}" required maxlength="20" ${isEdit ? 'readonly' : '' }>
                                    <small class="form-text text-muted">Unique code for the department</small>
                                </div>

                                <div class="mb-3">
                                    <label for="name" class="form-label">Department Name *</label>
                                    <input type="text" class="form-control" id="name" name="name"
                                        value="${department.name}" required maxlength="100">
                                </div>

                                <div class="mb-3">
                                    <label for="description" class="form-label">Description</label>
                                    <textarea class="form-control" id="description" name="description"
                                        rows="3">${department.description}</textarea>
                                </div>

                                <div class="mb-3">
                                    <div class="form-check">
                                        <input type="checkbox" class="form-check-input" id="active" name="active"
                                            value="true" ${department.active or not isEdit ? 'checked' : '' }>
                                        <label class="form-check-label" for="active">
                                            Active
                                        </label>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-between">
                                    <a href="<c:url value='/department'/>" class="btn btn-secondary">
                                        <i class="bi bi-x-circle"></i> Cancel
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-check-circle"></i> Save
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="../common/footer.jsp" />