<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <c:set var="pageTitle" value="My Notifications" scope="request" />
            <jsp:include page="../common/header.jsp" />

            <div class="container mt-4">
                <div class="row mb-4">
                    <div class="col-md-8">
                        <h2><i class="bi bi-bell"></i> My Notifications</h2>
                    </div>
                    <div class="col-md-4 text-end">
                        <button class="btn btn-outline-secondary btn-sm" onclick="markAllAsRead()">
                            Mark all as read
                        </button>
                    </div>
                </div>

                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <div class="list-group shadow-sm">
                    <c:choose>
                        <c:when test="${empty notifications}">
                            <div class="list-group-item text-center py-5 text-muted">
                                <i class="bi bi-mailbox fs-1 d-block mb-3"></i>
                                No notifications yet.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${notifications}" var="notif">
                                <div class="list-group-item list-group-item-action ${notif.read ? '' : 'bg-light border-start border-4 border-primary'}"
                                    id="notif-${notif.id}">
                                    <div class="d-flex w-100 justify-content-between align-items-center">
                                        <h5 class="mb-1">
                                            <span
                                                class="badge rounded-pill bg-${notif.type.toLowerCase() == 'danger' ? 'danger' : (notif.type.toLowerCase() == 'warning' ? 'warning text-dark' : (notif.type.toLowerCase() == 'success' ? 'success' : 'info'))} me-2">
                                                ${notif.category}
                                            </span>
                                            ${notif.title}
                                        </h5>
                                        <small class="text-muted">
                                            <fmt:parseDate value="${notif.createdAt}" pattern="yyyy-MM-dd'T'HH:mm"
                                                var="parsedDate" type="both" />
                                            <fmt:formatDate value="${parsedDate}" pattern="MMM dd, yyyy HH:mm" />
                                        </small>
                                    </div>
                                    <p class="mb-1 mt-2 text-dark">${notif.message}</p>
                                    <div class="mt-3">
                                        <c:if test="${!notif.read}">
                                            <button class="btn btn-sm btn-link p-0 text-decoration-none me-3"
                                                onclick="markRead('${notif.id}')">
                                                Mark as read
                                            </button>
                                        </c:if>
                                        <form action="<c:url value='/notifications/${notif.id}/delete'/>" method="post"
                                            class="d-inline">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                            <button type="submit"
                                                class="btn btn-sm btn-link p-0 text-decoration-none text-danger"
                                                onclick="return confirm('Delete this notification?')">
                                                Delete
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <script>
                function markRead(id) {
                    fetch('<c:url value="/notifications/"/>' + id + '/read', {
                        method: 'POST',
                        headers: {
                            'X-CSRF-TOKEN': '${_csrf.token}'
                        }
                    }).then(response => {
                        if (response.ok) {
                            const item = document.getElementById('notif-' + id);
                            item.classList.remove('bg-light', 'border-start', 'border-4', 'border-primary');
                            // Remove the mark as read button
                            const btn = item.querySelector('button[onclick="markRead(' + id + ')"]');
                            if (btn) btn.remove();

                            // Optionally update the badge count in header
                            location.reload(); // Simple way to update everything
                        }
                    });
                }

                function markAllAsRead() {
                    location.reload();
                }
            </script>

            <jsp:include page="../common/footer.jsp" />