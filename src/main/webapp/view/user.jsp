<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Expires", "0");

    if (session.getAttribute("userId") == null || !"ADMIN".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - Novoxia</title>
    <link rel="icon" type="image/x-icon" href="../assets/a.svg">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="../styles/dashboard.css">
</head>
<body>

<!-- Top Navigation -->
<nav class="top-nav">
    <div class="d-flex justify-content-between align-items-center">
        <div class="d-flex align-items-center gap-4">
            <div class="window-dots">
                <div class="window-dot dot-red"></div>
                <div class="window-dot dot-yellow"></div>
                <div class="window-dot dot-green"></div>
            </div>
            <div>
                <img src="../assets/a.svg" alt="logo" width="32" height="32">
                <span class="nav-logo">Novoxia</span>
            </div>
            <div class="d-flex gap-3">
                <a href="dashboard.jsp" class="nav-link">Dashboard</a>
                <a href="products.jsp" class="nav-link">Products</a>
                <a href="categories.jsp" class="nav-link">Categories</a>
                <a href="orders.jsp" class="nav-link">Orders</a>
                <a href="user.jsp" class="nav-link active">Users</a>
            </div>
        </div>
        <div class="d-flex align-items-center gap-3">
            <button class="cart-btn" title="Cart">
                <a href="cart.jsp">
                    <i class="bi bi-cart fs-5"></i>
                    <span class="cart-badge">0</span>
                </a>
            </button>
            <div class="d-flex align-items-center gap-2">
                <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center"
                     style="width: 32px; height: 32px;">
                    <%= session.getAttribute("firstName") != null ? ((String)session.getAttribute("firstName")).charAt(0) : "U" %>
                </div>
                <div>
                    <div class="fw-medium" style="font-size: 0.875rem;">
                        <%= session.getAttribute("firstName") %> <%= session.getAttribute("lastName") %>
                    </div>
                    <div style="font-size: 0.75rem; color: #64748b;">
                        <%= session.getAttribute("email") %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</nav>

<div class="app-container">
    <div class="row">
        <div class="col-12">
            <div class="feature-card">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="mb-1">User Management</h4>
                        <p class="text-muted mb-0">View and manage registered users</p>
                    </div>
                    <div class="d-flex gap-3 align-items-center">
                        <div class="position-relative">
                            <i class="bi bi-search position-absolute"
                               style="left: 10px; top: 50%; transform: translateY(-50%); color: #6c757d;"></i>
                            <input type="text" class="form-control ps-4"
                                   id="searchInput" placeholder="Search users...">
                        </div>
                        <button class="btn btn-primary d-flex align-items-center gap-2" onclick="refreshUsers()">
                            <i class="bi bi-arrow-clockwise"></i>
                            <span>Refresh</span>
                        </button>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover" id="usersTable">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Full Name</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Join Date</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <!-- Data will be populated via JavaScript -->
                        </tbody>
                    </table>
                    <div id="loadingSpinner" class="text-center py-4 d-none">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                    </div>
                    <div id="noResults" class="text-center py-4 d-none">
                        <i class="bi bi-search fs-1 text-muted"></i>
                        <p class="mt-2 mb-0">No users found matching your search.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.all.min.js"></script>

<script>
    function showLoading() {
        document.getElementById('loadingSpinner').classList.remove('d-none');
        document.querySelector('#usersTable tbody').innerHTML = '';
    }

    function hideLoading() {
        document.getElementById('loadingSpinner').classList.add('d-none');
    }

    function loadUsers() {
        showLoading();

        fetch('user')
            .then(response => response.json())
            .then(data => {
                hideLoading();

                if (data.status === 'success') {
                    const tbody = document.querySelector('#usersTable tbody');
                    const users = JSON.parse(data.data);

                    if (users.length === 0) {
                        document.getElementById('noResults').classList.remove('d-none');
                        return;
                    }

                    users.forEach(user => {
                        const createdDate = new Date(user.createdAt).toLocaleDateString('en-US', {
                            year: 'numeric',
                            month: 'short',
                            day: 'numeric'
                        });

                        const row = document.createElement('tr');
                        row.innerHTML = `
                        <td>#${user.id}</td>
                        <td>
                            <div class="d-flex align-items-center gap-2">
                                <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center"
                                     style="width: 32px; height: 32px;">
                                    ${user.firstName.charAt(0)}${user.lastName.charAt(0)}
                                </div>
                                <div>${user.firstName} ${user.lastName}</div>
                            </div>
                        </td>
                        <td>${user.username}</td>
                        <td>${user.email}</td>
                        <td>${createdDate}</td>
                        <td>
                            <button class="btn btn-sm btn-outline-primary" onclick="viewUserDetails(${user.id})">
                                <i class="bi bi-info-circle"></i>
                            </button>
                        </td>
                    `;
                        tbody.appendChild(row);
                    });

                    updateSearchResults();
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: data.message || 'Failed to load users'
                    });
                }
            })
            .catch(error => {
                hideLoading();
                console.error('Error:', error);
                Swal.fire({
                    icon: 'error',
                    title: 'Connection Error',
                    text: 'Failed to connect to the server. Please try again.',
                    confirmButtonText: 'Retry'
                }).then((result) => {
                    if (result.isConfirmed) {
                        loadUsers();
                    }
                });
            });
    }

    function viewUserDetails(userId) {
        Swal.fire({
            title: 'User Details',
            text: 'User details view coming soon',
            icon: 'info'
        });
    }

    function updateSearchResults() {
        const searchText = document.getElementById('searchInput').value.toLowerCase();
        const rows = document.querySelectorAll('#usersTable tbody tr');
        let visibleRows = 0;

        rows.forEach(row => {
            const text = row.textContent.toLowerCase();
            const isVisible = text.includes(searchText);
            row.style.display = isVisible ? '' : 'none';
            if (isVisible) visibleRows++;
        });

        document.getElementById('noResults').classList.toggle('d-none', visibleRows > 0);
    }

    function refreshUsers() {
        loadUsers();
    }

    // Initialize
    document.addEventListener('DOMContentLoaded', function() {
        loadUsers();
        document.getElementById('searchInput').addEventListener('input', updateSearchResults);
    });
</script>

</body>
</html>