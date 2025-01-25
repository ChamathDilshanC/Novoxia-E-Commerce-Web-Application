<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Orders - Novoxia</title>
    <link rel="icon" type="image/x-icon" href="assets/a.svg">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .orders-header {
            background: linear-gradient(135deg, #05c46b 0%, #ffffff 100%);
            color: white;
            padding: 2rem 5rem 2rem 5rem;
            margin-top: 1rem;
            margin-bottom: 2rem;
            border-radius: 15px;
        }
        .order-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 1rem;
            transition: transform 0.2s;
        }
        .order-card:hover {
            transform: translateY(-2px);
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
        .order-detail-btn {
            padding: 0.5rem 1rem;
            border-radius: 8px;
            background-color: #f3f4f6;
            color: #4b5563;
            text-decoration: none;
            transition: all 0.2s;
        }
        .order-detail-btn:hover {
            background-color: #e5e7eb;
            color: #1f2937;
        }
    </style>
</head>
<body class="bg-light">

<jsp:include page="components/topnav.jsp" />

<div class="orders-header">
    <div class="d-flex justify-content-between align-items-center mx-4">
        <div>
            <h1 class="mb-2">Orders</h1>
            <p class="mb-0 text-white-50">Browse our Orders</p>
        </div>
    </div>
</div>

<div class="container mb-5">
    <c:choose>
        <c:when test="${empty orders}">
            <div class="text-center py-5">
                <i class="bi bi-inbox fs-1 text-muted"></i>
                <h3 class="mt-3">No Orders Found</h3>
                <p class="text-muted">You haven't placed any orders yet.</p>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">
                    Start Shopping
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Orders List -->
            <div class="row">
                <div class="col-12">
                    <c:forEach items="${orders}" var="order">
                        <div class="order-card p-4">
                            <div class="d-flex justify-content-between align-items-center flex-wrap">
                                <div>
                                    <div class="d-flex align-items-center gap-3 mb-2">
                                        <h5 class="mb-0">Order #${order.id}</h5>
                                        <span class="status-badge status-${order.status.toLowerCase()}">
                                                ${order.status}
                                        </span>
                                    </div>
                                    <div class="text-muted">
                                        <fmt:parseDate value="${order.createdAt}"
                                                       pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" />
                                        <fmt:formatDate value="${parsedDate}"
                                                        pattern="MMMM dd, yyyy 'at' hh:mm a" />
                                    </div>
                                </div>
                                <div class="d-flex align-items-center gap-4">
                                    <div class="text-end">
                                        <div class="text-muted">Total Amount</div>
                                        <div class="fw-bold">Rs. ${order.totalAmount}</div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/orders/view?id=${order.id}"
                                       class="order-detail-btn">
                                        View Details
                                    </a>
                                </div>
                            </div>

                            <!-- Order Summary -->
                            <div class="mt-3 pt-3 border-top">
                                <div class="row g-3">
                                    <div class="col-md-4">
                                        <div class="text-muted">Shipping Address</div>
                                        <div>${order.shippingFirstName} ${order.shippingLastName}</div>
                                        <div>${order.shippingAddress}</div>
                                        <div>${order.shippingCity}, ${order.shippingZip}</div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="text-muted">Payment Method</div>
                                        <div>${order.paymentMethod}</div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="text-muted">Items</div>
                                        <div>${order.orderDetails.size()} items</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>