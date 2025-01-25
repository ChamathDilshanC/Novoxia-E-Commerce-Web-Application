<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - Novoxia</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="../styles/cartStyles.css">
</head>
<body>
<div class="cart-container">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-1">Shopping Cart</h2>
            <p class="text-muted mb-0">Review and manage your items</p>
        </div>
        <button class="btn btn-outline-primary">
            <i class="bi bi-arrow-left me-2"></i>Continue Shopping
        </button>
    </div>

    <div class="row g-4">
        <!-- Cart Items -->
        <div class="col-lg-8">
            <c:forEach var="item" items="${cartItems}">
                <div class="cart-item">
                    <div class="row align-items-center">
                        <div class="col-auto">
                            <img src="/api/placeholder/100/100" alt="${item.product.name}" class="product-image">
                        </div>
                        <div class="col">
                            <h5 class="mb-1">${item.product.name}</h5>
                            <p class="text-muted mb-0">${item.product.category.name}</p>
                        </div>
                        <div class="col-auto">
                            <div class="quantity-control input-group">
                                <button class="btn btn-outline-secondary" onclick="updateQuantity(${item.id}, -1)">-</button>
                                <input type="number" class="form-control text-center" value="${item.quantity}" min="1" readonly>
                                <button class="btn btn-outline-secondary" onclick="updateQuantity(${item.id}, 1)">+</button>
                            </div>
                        </div>
                        <div class="col-auto">
                            <div class="fw-bold">$${String.format("%.2f", item.product.price)}</div>
                        </div>
                        <div class="col-auto">
                            <button class="btn btn-outline-danger btn-sm" onclick="removeItem(${item.id})">
                                <i class="bi bi-trash"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty cartItems}">
                <div class="text-center py-5">
                    <i class="bi bi-cart-x" style="font-size: 3rem; color: #9ca3af;"></i>
                    <h5 class="mt-3">Your cart is empty</h5>
                    <p class="text-muted">Start adding items to your cart</p>
                </div>
            </c:if>
        </div>

        <!-- Order Summary -->
        <div class="col-lg-4">
            <div class="card summary-card">
                <div class="card-body">
                    <h5 class="card-title">Order Summary</h5>

                    <div class="summary-item">
                        <span>Subtotal</span>
                        <span>$${String.format("%.2f", subtotal)}</span>
                    </div>
                    <div class="summary-item">
                        <span>Shipping</span>
                        <span>$${String.format("%.2f", shipping)}</span>
                    </div>
                    <div class="summary-item">
                        <span>Tax (10%)</span>
                        <span>$${String.format("%.2f", tax)}</span>
                    </div>

                    <hr>

                    <div class="summary-total">
                        <span>Total</span>
                        <span>$${String.format("%.2f", total)}</span>
                    </div>

                    <button class="btn btn-primary w-100 mt-4" ${empty cartItems ? 'disabled' : ''}>
                        <i class="bi bi-credit-card me-2"></i>Proceed to Checkout
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function updateQuantity(itemId, change) {
        fetch('update-cart', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `itemId=\${itemId}&change=\${change}`
        }).then(response => {
            if (response.ok) {
                window.location.reload();
            }
        });
    }

    function removeItem(itemId) {
        if (confirm('Are you sure you want to remove this item?')) {
            fetch('remove-from-cart?id=' + itemId, {
                method: 'DELETE'
            }).then(response => {
                if (response.ok) {
                    window.location.reload();
                }
            });
        }
    }
</script>
</body>
</html>