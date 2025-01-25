<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
  response.setHeader("Pragma", "no-cache");
  response.setHeader("Expires", "0");

  // Session check
  if (session.getAttribute("userId") == null) {
    response.sendRedirect(request.getContextPath() + "/index.jsp");
    return;
  }

  String username = (String) session.getAttribute("username");
  String firstName = (String) session.getAttribute("firstName");
  String lastName = (String) session.getAttribute("lastName");
  String email = (String) session.getAttribute("email");
  String role = (String) session.getAttribute("role");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Novoxia - Dashboard</title>
  <link rel="icon" type="image/x-icon" href="assets/a.svg">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="styles/dashboard.css">
</head>

<body>
<!-- Top Navigation -->
<jsp:include page="components/topnav.jsp" />

<div class="app-container">
  <div class="row g-4">
    <div class="col-lg-3">
      <div class="steps-nav">
        <div class="step-item active">
          <div class="step-number">1</div>
          <div class="step-content">
            <h3>Overview</h3>
            <p>View dashboard stats</p>
          </div>
        </div>

        <div class="step-item">
          <div class="step-number">2</div>
          <div class="step-content">
            <h3>Products</h3>
            <p>Manage your products</p>
          </div>
        </div>

        <div class="step-item">
          <div class="step-number">3</div>
          <div class="step-content">
            <h3>Categories</h3>
            <p>Organize inventory</p>
          </div>
        </div>

        <div class="step-item">
          <div class="step-number">4</div>
          <div class="step-content">
            <h3>Orders</h3>
            <p>Process customer orders</p>
          </div>
        </div>

        <% if ("ADMIN".equals(role)) { %>
        <div class="step-item">
          <div class="step-number">5</div>
          <div class="step-content">
            <h3>Users</h3>
            <p>Manage customer accounts</p>
          </div>
        </div>
        <% } %>
      </div>
      <div class="step-item">
        <div class="step-content">
          <form id="logoutForm" action="${pageContext.request.contextPath}/index.jsp" method="post">
            <button type="submit" class="btn btn-danger w-100">Log Out</button>
          </form>
          <p class="text-center mt-2">End your session</p>
        </div>
      </div>
    </div>

    <!-- Main Content -->
    <div class="col-lg-9">
      <div class="row g-4">
        <div class="col-sm-6 col-xl-3">
          <div class="feature-card">
            <div class="feature-icon">
              <i class="bi bi-box-seam text-primary"></i>
            </div>
            <div class="feature-title">Total Products</div>
            <div class="feature-value">485</div>
            <div class="feature-description">12 added today</div>
          </div>
        </div>

        <div class="col-sm-6 col-xl-3">
          <div class="feature-card">
            <div class="feature-icon">
              <i class="bi bi-cart text-success"></i>
            </div>
            <div class="feature-title">Active Orders</div>
            <div class="feature-value">24</div>
            <div class="feature-description">6 pending delivery</div>
          </div>
        </div>

        <div class="col-sm-6 col-xl-3">
          <div class="feature-card">
            <div class="feature-icon">
              <i class="bi bi-people text-info"></i>
            </div>
            <div class="feature-title">Total Users</div>
            <div class="feature-value">1,284</div>
            <div class="feature-description">32 new this week</div>
          </div>
        </div>

        <div class="col-sm-6 col-xl-3">
          <div class="feature-card">
            <div class="feature-icon">
              <i class="bi bi-currency-dollar text-warning"></i>
            </div>
            <div class="feature-title">Revenue</div>
            <div class="feature-value">$12,845</div>
            <div class="feature-description">+8% from last month</div>
          </div>
        </div>

        <!-- Quick Links -->
        <div class="col-12">
          <div class="row g-4">
            <div class="col-md-3">
              <a href="products.jsp" class="text-decoration-none">
                <div class="feature-card quick-link-card">
                  <div class="d-flex flex-column align-items-center text-center">
                    <div class="feature-icon mb-3">
                      <i class="bi bi-box-seam fs-1 text-primary"></i>
                    </div>
                    <h5 class="mb-2">Products</h5>
                    <p class="text-muted mb-0">Manage your product inventory</p>
                  </div>
                </div>
              </a>
            </div>

            <div class="col-md-3">
              <a href="categories.jsp" class="text-decoration-none">
                <div class="feature-card quick-link-card">
                  <div class="d-flex flex-column align-items-center text-center">
                    <div class="feature-icon mb-3">
                      <i class="bi bi-grid fs-1 text-success"></i>
                    </div>
                    <h5 class="mb-2">Categories</h5>
                    <p class="text-muted mb-0">Organize your products</p>
                  </div>
                </div>
              </a>
            </div>

            <div class="col-md-3">
              <a href="view/orders.jsp" class="text-decoration-none">
                <div class="feature-card quick-link-card">
                  <div class="d-flex flex-column align-items-center text-center">
                    <div class="feature-icon mb-3">
                      <i class="bi bi-cart-check fs-1 text-info"></i>
                    </div>
                    <h5 class="mb-2">Orders</h5>
                    <p class="text-muted mb-0">Track customer orders</p>
                  </div>
                </div>
              </a>
            </div>

            <% if ("ADMIN".equals(role)) { %>
            <div class="col-md-3">
              <a href="user" class="text-decoration-none">
                <div class="feature-card quick-link-card">
                  <div class="d-flex flex-column align-items-center text-center">
                    <div class="feature-icon mb-3">
                      <i class="bi bi-people fs-1 text-warning"></i>
                    </div>
                    <h5 class="mb-2">Users</h5>
                    <p class="text-muted mb-0">Manage accounts</p>
                  </div>
                </div>
              </a>
            </div>
            <% } %>
          </div>
        </div>

        <div class="col-12">
          <div class="feature-card">
            <div class="d-flex justify-content-between align-items-center mb-4">
              <h5 class="mb-0">Recent Orders</h5>
              <a href="view/orders.jsp" class="btn btn-primary btn-sm">View All</a>
            </div>
            <div class="table-responsive">
              <table class="table">
                <thead>
                <tr>
                  <th>Order ID</th>
                  <th>Customer</th>
                  <th>Product</th>
                  <th>Amount</th>
                  <th>Date</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                  <td>#1</td>
                  <td>
                    <div class="d-flex align-items-center gap-2">
                      <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center"
                           style="width: 32px; height: 32px;">J</div>
                      <div>John Doe</div>
                    </div>
                  </td>
                  <td>Product Name</td>
                  <td>$999</td>
                  <td>Jan 15, 2024</td>
                  <td><span class="badge bg-success">Completed</span></td>
                  <td>
                    <div class="d-flex gap-2">
                      <button class="btn btn-sm btn-outline-primary"><i class="bi bi-eye"></i></button>
                      <button class="btn btn-sm btn-outline-success"><i class="bi bi-check-lg"></i></button>
                    </div>
                  </td>
                </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.all.min.js"></script>
<script src="scripts/dashboardScript.js"></script>
</body>
</html>