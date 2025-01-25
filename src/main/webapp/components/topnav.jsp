<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Expires", "0");

    String username = (String) session.getAttribute("username");
    String firstName = (String) session.getAttribute("firstName");
    String lastName = (String) session.getAttribute("lastName");
    String email = (String) session.getAttribute("email");
    String role = (String) session.getAttribute("role");
    Integer cartCount = (Integer) session.getAttribute("cartCount");

    // Get current page for active state
    String currentPage = request.getRequestURI();
%>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">

<style>
    /* General Styles */
    body {
        background-color: #f8f9fa;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
        padding: 1rem 2rem 0 2rem;
    }

    /* Top Navigation Styles */
    .top-nav {
        background: #ffffff;
        padding: 1rem 2rem;
        border-bottom: 1px solid #e5e7eb;
        position: sticky;
        top: 0;
        z-index: 1000;
        border-radius: 0.5rem;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    }

    .nav-logo {
        font-weight: 600;
        font-size: 1.25rem;
        margin-left: 0.5rem;
        color: #2563eb;
    }

    .nav-link {
        color: #64748b;
        text-decoration: none;
        font-size: 0.875rem;
        padding: 0.5rem 1rem;
        border-radius: 0.375rem;
        transition: all 0.2s;
    }

    .nav-link:hover {
        color: #1e293b;
        background-color: #f1f5f9;
    }

    .nav-link.active {
        color: #3b82f6;
        background-color: #eff6ff;
    }

    /* Window Dots */
    .window-dots {
        display: flex;
        gap: 6px;
        padding: 0 8px;
    }

    .window-dot {
        width: 12px;
        height: 12px;
        border-radius: 50%;
    }

    .dot-red { background-color: #ff5f57; }
    .dot-yellow { background-color: #febc2e; }
    .dot-green { background-color: #28c840; }

    /* Cart Button */
    .cart-btn {
        position: relative;
        background: none;
        border: none;
        padding: 0.5rem;
        color: #64748b;
        cursor: pointer;
        transition: all 0.2s;
    }

    .cart-btn:hover {
        color: #1e293b;
        background-color: #f1f5f9;
        border-radius: 0.375rem;
    }

    .cart-btn a {
        color: inherit;
        text-decoration: none;
        position: relative;
        display: inline-block;
    }

    .cart-badge {
        position: absolute;
        top: -8px;
        right: -8px;
        background-color: #ef4444;
        color: white;
        font-size: 0.7rem;
        min-width: 18px;
        height: 18px;
        padding: 0 5px;
        border-radius: 9999px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 500;
        box-shadow: 0 2px 4px rgba(239, 68, 68, 0.3);
        animation: cartBadgePopIn 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    }

    @keyframes cartBadgePopIn {
        0% { transform: scale(0); }
        100% { transform: scale(1); }
    }

    /* Dropdown Styles */
    .dropdown-menu {
        padding: 0.5rem 0;
        border: none;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        border-radius: 0.5rem;
        margin-top: 0.5rem;
    }

    .dropdown-item {
        padding: 0.5rem 1rem;
        color: #4b5563;
        font-size: 0.875rem;
        transition: all 0.2s;
    }

    .dropdown-item:hover {
        background-color: #f3f4f6;
        color: #2563eb;
    }

    .dropdown-item.text-danger:hover {
        background-color: #fef2f2;
        color: #dc2626;
    }

    .dropdown-divider {
        margin: 0.5rem 0;
        border-color: #e5e7eb;
    }

    /* User Profile */
    .user-profile {
        cursor: pointer;
        padding: 0.5rem;
        border-radius: 0.5rem;
        transition: all 0.2s;
    }

    .user-profile:hover {
        background-color: #f3f4f6;
    }

    .user-avatar {
        width: 32px;
        height: 32px;
        background-color: #2563eb;
        color: white;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 500;
    }
</style>

<!-- Top Navigation -->
<nav class="top-nav">
    <div class="d-flex justify-content-between align-items-center">
        <div class="d-flex align-items-center gap-4">
            <!-- Window Dots -->
            <div class="window-dots">
                <div class="window-dot dot-red"></div>
                <div class="window-dot dot-yellow"></div>
                <div class="window-dot dot-green"></div>
            </div>

            <!-- Logo -->
            <div>
                <a href="${pageContext.request.contextPath}/<%= "ADMIN".equals(role) ? "dashboard.jsp" : "dashboard.jsp" %>"
                   class="text-decoration-none">
                <div style="display: flex; gap: 20px">
                    <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                        <img src="${pageContext.request.contextPath}/assets/a.svg" alt="logo" width="32" height="32">
                    </svg>
                    <span class="nav-logo">Novoxia</span>
                </div>
                </a>
            </div>

            <!-- Navigation Links -->
            <div class="d-flex gap-3 container">
                <% if ("ADMIN".equals(role)) { %>
                <a href="${pageContext.request.contextPath}/dashboard.jsp"
                   class="nav-link <%= currentPage.contains("/dashboard.jsp") ? "active" : "" %>">
                    <i class="bi bi-speedometer2 me-1"></i>Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/products"
                   class="nav-link <%= currentPage.contains("/products") ? "active" : "" %>">
                    <i class="bi bi-box-seam me-1"></i>Products
                </a>
                <a href="${pageContext.request.contextPath}/categories"
                   class="nav-link <%= currentPage.contains("/categories") ? "active" : "" %>">
                    <i class="bi bi-grid me-1"></i>Categories
                </a>
                <a href="${pageContext.request.contextPath}/orders"
                   class="nav-link <%= currentPage.contains("/orders") ? "active" : "" %>">
                    <i class="bi bi-cart-check me-1"></i>Orders
                </a>
                <a href="${pageContext.request.contextPath}/user"
                   class="nav-link <%= currentPage.contains("/user") ? "active" : "" %>">
                    <i class="bi bi-people me-1"></i>Users
                </a>
                <% } else { %>
                <a href="${pageContext.request.contextPath}/dashboard.jsp"
                   class="nav-link <%= currentPage.contains("/dashboard.jsp") ? "active" : "" %>">
                    <i class="bi bi-house-door me-1"></i>Home
                </a>
                <a href="${pageContext.request.contextPath}/products"
                   class="nav-link <%= currentPage.contains("/products") ? "active" : "" %>">
                    <i class="bi bi-box-seam me-1"></i>Products
                </a>
                <a href="${pageContext.request.contextPath}/orders"
                   class="nav-link <%= currentPage.contains("/orders") ? "active" : "" %>">
                    <i class="bi bi-clock-history me-1"></i>My Orders
                </a>
                <% } %>
            </div>
        </div>

        <!-- Right Side Items -->
        <div class="d-flex align-items-center gap-3">
            <% if (!"ADMIN".equals(role)) { %>
            <!-- Cart Button -->
            <button class="cart-btn" title="Shopping Cart">
                <a href="${pageContext.request.contextPath}/cart" class="position-relative">
                    <i class="bi bi-cart fs-5"></i>
                    <% if (cartCount != null && cartCount > 0) { %>
                    <span class="cart-badge" id="cartCountBadge"><%= cartCount %></span>
                    <% } %>
                </a>
            </button>
            <% } %>

            <!-- User Profile Dropdown -->
            <!-- User Profile Dropdown -->
            <div class="dropdown">
                <div class="user-profile d-flex align-items-center gap-2"
                     data-bs-toggle="dropdown"
                     data-user-role="<%= role %>"
                     aria-expanded="false">
                    <div class="user-avatar">
                        <%= firstName != null ? firstName.charAt(0) : "U" %>
                    </div>
                    <div class="d-none d-sm-block">
                        <div class="fw-medium" style="font-size: 0.875rem;">
                            <%= firstName != null ? firstName + " " + lastName : "User" %>
                        </div>
                        <div style="font-size: 0.75rem; color: #64748b;">
                            <%= role != null ? role : "Guest" %>
                        </div>
                    </div>
                    <i class="bi bi-chevron-down ms-1"></i>
                </div>

                <!-- Dropdown Menu -->
                <ul class="dropdown-menu dropdown-menu-end">
                    <% if (!"ADMIN".equals(role)) { %>
                    <li>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                            <i class="bi bi-person me-2"></i>Profile
                        </a>
                    </li>
                    <li>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/orders">
                            <i class="bi bi-clock-history me-2"></i>Order History
                        </a>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <% } %>
                    <li>
                        <form id="logoutForm" action="${pageContext.request.contextPath}/index.jsp" method="post" class="m-0">
                            <button type="submit" class="dropdown-item text-danger">
                                <i class="bi bi-box-arrow-right me-2"></i>Logout
                            </button>
                        </form>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    // Active link highlight
    const currentPage = window.location.pathname.split('/').pop();
    document.querySelectorAll('.nav-link').forEach(link => {
        if (link.getAttribute('href').includes(currentPage)) {
            link.classList.add('active');
        } else {
            link.classList.remove('active');
        }
    });

    // Cart count update function
    function updateCartCount(count) {
        const cartBtn = document.querySelector('.cart-btn a');
        if (!cartBtn) return;

        let badge = document.querySelector('#cartCountBadge');

        if (count > 0) {
            if (!badge) {
                badge = document.createElement('span');
                badge.id = 'cartCountBadge';
                badge.className = 'cart-badge';
                cartBtn.appendChild(badge);
            }
            badge.textContent = count;
        } else {
            if (badge) {
                badge.remove();
            }
        }
    }

    // Listen for cart updates
    window.addEventListener('cartUpdate', function(e) {
        if (e.detail && typeof e.detail.count !== 'undefined') {
            updateCartCount(e.detail.count);
        }
    });

    // Logout confirmation
    document.getElementById('logoutForm')?.addEventListener('submit', function(e) {
        e.preventDefault();
        const form = e.target;

        Swal.fire({
            title: 'Logout Confirmation',
            text: 'Are you sure you want to logout?',
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#2563eb',
            cancelButtonColor: '#64748b',
            confirmButtonText: 'Yes, logout!',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                form.submit();
            }
        });
    });
</script>