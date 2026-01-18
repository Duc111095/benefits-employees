<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

            <c:set var="pageTitle" value="${isEdit ? 'Edit Benefit Type' : 'New Benefit Type'}" scope="request" />
            <jsp:include page="../common/header.jsp" />

            <div class="container mt-4">
                <div class="row justify-content-center">
                    <div class="col-md-8 col-lg-6">
                        <div class="d-flex align-items-center mb-4">
                            <a href="<c:url value='/benefit/types'/>" class="btn btn-light border me-3">
                                <i class="bi bi-arrow-left"></i>
                            </a>
                            <h2 class="mb-0">
                                <i class="bi ${isEdit ? 'bi-pencil-square' : 'bi-plus-circle'} text-primary me-2"></i>
                                ${isEdit ? 'Edit Benefit Type' : 'New Benefit Type'}
                            </h2>
                        </div>

                        <div class="card border-0 shadow-sm">
                            <div class="card-body p-4">
                                <form:form modelAttribute="benefitType"
                                    action="${pageContext.request.contextPath}/benefit/types/save" method="post">
                                    <form:hidden path="id" />

                                    <div class="mb-3">
                                        <label for="code" class="form-label fw-bold">Code <span
                                                class="text-danger">*</span></label>
                                        <form:input path="code" id="code" class="form-control" required="true"
                                            maxlength="20" placeholder="e.g. MED, DENT, WELL" />
                                        <div class="form-text">Unique identifier code, max 20 chars.</div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="name" class="form-label fw-bold">Name <span
                                                class="text-danger">*</span></label>
                                        <form:input path="name" id="name" class="form-control" required="true"
                                            maxlength="100" placeholder="e.g. Medical, Dental, Wellness" />
                                    </div>

                                    <div class="mb-3">
                                        <label for="description" class="form-label fw-bold">Description</label>
                                        <form:textarea path="description" id="description" class="form-control" rows="3"
                                            placeholder="Brief description of this benefit type" />
                                    </div>

                                    <div class="mb-4 form-check form-switch">
                                        <form:checkbox path="active" id="active" class="form-check-input" />
                                        <label class="form-check-label" for="active">Active</label>
                                        <div class="form-text">Inactive types cannot be selected for new benefit plans.
                                        </div>
                                    </div>

                                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                        <a href="<c:url value='/benefit/types'/>"
                                            class="btn btn-light border px-4">Cancel</a>
                                        <button type="submit" class="btn btn-primary px-4">
                                            <i class="bi bi-save me-1"></i> Save Benefit Type
                                        </button>
                                    </div>
                                </form:form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <jsp:include page="../common/footer.jsp" />