<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:set var="pageTitle" value="Broadcast Notification" scope="request" />
        <jsp:include page="../common/header.jsp" />

        <div class="container mt-4">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="card shadow">
                        <div class="card-header bg-warning text-dark">
                            <h4 class="mb-0"><i class="bi bi-megaphone-fill"></i> Send Broadcast Notification</h4>
                        </div>
                        <div class="card-body">
                            <p class="text-muted mb-4">This message will be sent to <strong>all registered
                                    users</strong> in the system.</p>

                            <form action="<c:url value='/notifications/broadcast'/>" method="post">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                                <div class="mb-3">
                                    <label class="form-label">Notification Title</label>
                                    <input type="text" name="title" class="form-control"
                                        placeholder="e.g. New Year Benefit Policy Update" required>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Type / Severity</label>
                                        <select name="type" class="form-select" required>
                                            <option value="INFO">Information (Blue)</option>
                                            <option value="SUCCESS">Success (Green)</option>
                                            <option value="WARNING">Warning (Yellow)</option>
                                            <option value="DANGER">Critical/Danger (Red)</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Category</label>
                                        <select name="category" class="form-select" required>
                                            <option value="POLICY">Policy Change</option>
                                            <option value="SYSTEM">System Announcement</option>
                                            <option value="ENROLLMENT">Enrollment Reminder</option>
                                            <option value="CLAIM">Claim Guideline</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Message Content</label>
                                    <textarea name="message" class="form-control" rows="5"
                                        placeholder="Write the details of your announcement here..."
                                        required></textarea>
                                    <div class="form-text">Plain text only. Maximum 1000 characters recommended.</div>
                                </div>

                                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                    <a href="<c:url value='/notifications'/>"
                                        class="btn btn-outline-secondary me-md-2">Cancel</a>
                                    <button type="submit" class="btn btn-primary px-5"
                                        onclick="return confirm('Are you sure you want to send this broadcast to EVERYONE?')">
                                        Send to All Users
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="../common/footer.jsp" />