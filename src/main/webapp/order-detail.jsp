<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Details - Novoxia</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .order-header {
            background: linear-gradient(135deg, #05c46b 0%, #ffffff 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            margin-top: 1rem;
            border-radius: 15px;
        }
        .order-section {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
            padding: 1.5rem;
        }
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 999px;
            font-size: 0.875rem;
            font-weight: 500;
        }
        .status-pending {
            background-color: #05c46b;
            color: #ffffff;
        }
        .status-completed {
            background-color: #d1fae5;
            color: #065f46;
        }
        .status-cancelled {
            background-color: #fee2e2;
            color: #991b1b;
        }
        .product-item {
            border-bottom: 1px solid #e5e7eb;
            padding: 1rem 0;
        }
        .product-item:last-child {
            border-bottom: none;
        }
        .product-img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
        }
    </style>
</head>
<body class="bg-light">
<!-- Top Navigation -->
<jsp:include page="components/topnav.jsp" />

<!-- Order Header -->
<div class="order-header">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h1>Order #${order.id}</h1>
                <p class="mb-0">
                    <fmt:parseDate value="${order.createdAt}"
                                   pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" />
                    <fmt:formatDate value="${parsedDate}"
                                    pattern="MMMM dd, yyyy 'at' hh:mm a" />
                </p>
            </div>
            <span class="status-badge status-${order.status.toLowerCase()}">
                ${order.status}
            </span>
        </div>
    </div>
</div>

<div class="container mb-5">
    <div class="row g-4">
        <!-- Order Details -->
        <div class="col-lg-8">
            <!-- Products -->
            <div class="order-section">
                <h5 class="mb-4">Order Items</h5>
                <c:forEach items="${order.orderDetails}" var="item">
                <div class="product-item">
                    <div class="row align-items-center">
                        <div class="col-auto">
                            <img src="${pageContext.request.contextPath}/${item.product.imagePath != null ? item.product.imagePath : 'assets/default-product.jpg'}"
                                 alt="${item.product.name}"
                                 class="product-img">
                        </div>
                        <div class="col">
                            <h6 class="mb-1">${item.product.name}</h6>
                            <div class="text-muted mb-2">
                                    ${item.product.category.name}
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="text-muted">Quantity: ${item.quantity}</span>
                                </div>
                                <div class="text-end">
                                    <div class="fw-bold">Rs. ${item.price}</div>
                                    <div class="text-muted">
                                        Total: Rs. ${item.price * item.quantity}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                </c:forEach>
            </div>
        </div>

        <!-- Order Summary -->
        <div class="col-lg-4">
            <!-- Price Summary -->
            <div class="order-section">
                <h5 class="mb-4">Order Summary</h5>
                <div class="d-flex justify-content-between mb-2">
                    <span>Subtotal</span>
                    <span>Rs. ${order.totalAmount.subtract(order.shippingCost)}</span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span>Shipping</span>
                    <span>Rs. ${order.shippingCost}</span>
                </div>
                <hr>
                <div class="d-flex justify-content-between mb-0">
                    <span class="h6 mb-0">Total</span>
                    <span class="h6 mb-0">Rs. ${order.totalAmount}</span>
                </div>
            </div>

            <!-- Customer Details -->
            <div class="order-section">
                <h5 class="mb-4">Customer Details</h5>
                <div class="mb-4">
                    <div class="text-muted mb-2">Shipping Information</div>
                    <div>${order.shippingFirstName} ${order.shippingLastName}</div>
                    <div>${order.shippingAddress}</div>
                    <div>${order.shippingCity}, ${order.shippingZip}</div>
                </div>
                <div>
                    <div class="text-muted mb-2">Payment Method</div>
                    <div>${order.paymentMethod}</div>
                </div>
            </div>

            <!-- Actions -->
            <div class="d-grid gap-2">
                <a href="${pageContext.request.contextPath}/orders"
                   class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left me-2"></i>Back to Orders
                </a>
                <% if (request.getSession().getAttribute("role").equals("ADMIN")) { %>
                <div class="btn-group">
                    <button class="btn btn-primary" onclick="updateOrderStatus('COMPLETED')">
                        Mark as Completed
                    </button>
                    <button class="btn btn-danger" onclick="updateOrderStatus('CANCELLED')">
                        Cancel Order
                    </button>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    async function updateOrderStatus(status) {
        try {
            const response = await fetch('${pageContext.request.contextPath}/orders/update-status', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `orderId=${order.id}&status=${status}`
            });

            const result = await response.json();

            if (result.success) {
                Swal.fire({
                    icon: 'success',
                    title: 'Status Updated',
                    text: 'Order status has been updated successfully',
                    showConfirmButton: false,
                    timer: 1500
                }).then(() => {
                    window.location.reload();
                });
            } else {
                throw new Error(result.message || 'Failed to update status');
            }
        } catch (error) {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: error.message || 'Failed to update order status'
            });
        }
    }
</script>
</body>
</html>