<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
  if (session.getAttribute("userId") == null || !"ADMIN".equals(session.getAttribute("role"))) {
    response.sendRedirect("../index.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Novoxia - User Management</title>
  <link rel="icon" type="image/x-icon" href="assets/a.svg">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="styles/userStyles.css">
</head>
<body>

<!-- Top Navigation -->
<jsp:include page="components/topnav.jsp" />

<div class="dashboard-container">
  <!-- Stats Cards -->
  <div class="stats-grid">
    <div class="stat-card">
      <div class="stat-icon" style="background-color: #dbeafe; color: #2563eb;">
        <i class="bi bi-people-fill"></i>
      </div>
      <h3 class="h6 text-muted mb-1">Total Users</h3>
      <h2 class="h4 mb-0">${users.size()}</h2>
    </div>

    <div class="stat-card">
      <div class="stat-icon" style="background-color: #fee2e2; color: #dc2626;">
        <i class="bi bi-shield-lock-fill"></i>
      </div>
      <h3 class="h6 text-muted mb-1">Admins</h3>
      <h2 class="h4 mb-0">
        ${fn:length(users.stream().filter(user -> user.role == 'ADMIN').toList())}
      </h2>
    </div>

    <div class="stat-card">
      <div class="stat-icon" style="background-color: #e0e7ff; color: #4338ca;">
        <i class="bi bi-person-check-fill"></i>
      </div>
      <h3 class="h6 text-muted mb-1">Customers</h3>
      <h2 class="h4 mb-0">
        ${fn:length(users.stream().filter(user -> user.role == 'CUSTOMER').toList())}
      </h2>
    </div>

    <div class="stat-card">
      <div class="stat-icon" style="background-color: #d1fae5; color: #059669;">
        <i class="bi bi-clock-history"></i>
      </div>
      <h3 class="h6 text-muted mb-1">New Users (24h)</h3>
      <h2 class="h4 mb-0">0</h2>
    </div>
  </div>

  <!-- Main Table Container -->
  <div class="table-container">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h3 class="h4 mb-0">User Management</h3>
      <button class="btn btn-primary" onclick="openCreateModal()">
        <i class="bi bi-plus-lg me-2"></i>Add New User
      </button>
    </div>

    <div class="table-responsive">
      <table class="table">
        <thead>
        <tr>
          <th>User</th>
          <th>Email</th>
          <th>Role</th>
          <th>Created At</th>
          <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
          <c:when test="${empty users}">
            <tr>
              <td colspan="5">
                <div class="empty-state">
                  <i class="bi bi-person-x"></i>
                  <h4>No Users Found</h4>
                  <p class="text-muted">Start by adding a new user to the system.</p>
                </div>
              </td>
            </tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="user" items="${users}">
              <tr>
                <td>
                  <div class="user-info">
                    <div class="user-avatar">
                        ${fn:substring(user.firstName, 0, 1)}${fn:substring(user.lastName, 0, 1)}
                    </div>
                    <div>
                      <div class="fw-medium">${user.firstName} ${user.lastName}</div>
                      <div class="text-muted small">@${user.username}</div>
                    </div>
                  </div>
                </td>
                <td>${user.email}</td>
                <td>
                                    <span class="badge bg-${user.role == 'ADMIN' ? 'danger' : 'primary'} bg-opacity-10 text-${user.role == 'ADMIN' ? 'danger' : 'primary'}">
                                        ${user.role}
                                    </span>
                </td>
                <td>
                  <div>${user.createdAt}</div>
                </td>
                <td class="action-buttons">
                  <button class="btn btn-light"
                          onclick="openEditModal(${user.id}, '${user.username}', '${user.email}',
                                  '${user.firstName}', '${user.lastName}', '${user.role}')">
                    <i class="bi bi-pencil"></i>
                  </button>
                  <button class="btn btn-light text-danger"
                          onclick="confirmDelete(${user.id}, '${user.username}')">
                    <i class="bi bi-trash"></i>
                  </button>
                </td>
              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
        </tbody>
      </table>
    </div>
  </div>
</div>

<!-- User Modal -->
<div class="modal fade" id="userModal" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modalTitle">Add New User</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <form id="userForm" class="needs-validation" novalidate>
          <input type="hidden" id="userId" name="id">
          <div class="row g-3">
            <div class="col-md-6">
              <div class="form-floating">
                <input type="text" class="form-control" id="username" name="username" required
                       pattern="^[a-zA-Z0-9_]{3,20}$">
                <label for="username">Username</label>
                <div class="invalid-feedback">
                  Username must be 3-20 characters long and contain only letters, numbers, and underscores.
                </div>
              </div>
            </div>

            <div class="col-md-6">
              <div class="form-floating">
                <input type="email" class="form-control" id="email" name="email" required>
                <label for="email">Email address</label>
                <div class="invalid-feedback">Please enter a valid email address.</div>
              </div>
            </div>

            <div class="col-md-6">
              <div class="form-floating">
                <input type="text" class="form-control" id="firstName" name="firstName" required
                       pattern="^[a-zA-Z\s]{2,30}$">
                <label for="firstName">First Name</label>
                <div class="invalid-feedback">
                  First name must be 2-30 characters long and contain only letters.
                </div>
              </div>
            </div>

            <div class="col-md-6">
              <div class="form-floating">
                <input type="text" class="form-control" id="lastName" name="lastName" required
                       pattern="^[a-zA-Z\s]{2,30}$">
                <label for="lastName">Last Name</label>
                <div class="invalid-feedback">
                  Last name must be 2-30 characters long and contain only letters.
                </div>
              </div>
            </div>

            <div class="col-md-6">
              <div class="form-floating position-relative">
                <input type="password" class="form-control" id="password" name="password"
                       pattern="^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$">
                <label for="password" id="passwordLabel">Password</label>
                <i class="bi bi-eye password-toggle" id="togglePassword"></i>
                <div class="invalid-feedback">
                  Password must be at least 8 characters long and include both letters,characters and numbers.
                </div>
              </div>
            </div>

            <div class="col-md-6">
              <div class="form-floating">
                <select class="form-select" id="role" name="role" required>
                  <option value="">Select role</option>
                  <option value="CUSTOMER">Customer</option>
                  <option value="ADMIN">Admin</option>
                </select>
                <label for="role">User Role</label>
                <div class="invalid-feedback">Please select a user role.</div>
              </div>
            </div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-primary" onclick="saveUser()">Save Changes</button>
      </div>
    </div>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="scripts/userScript.js"></script>
</body>
</html>