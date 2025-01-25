<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - Novoxia</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <style>
        .cart-header {
            background: linear-gradient(135deg, #05c46b 0%, #ffffff 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            margin-top: 1rem;
            border-radius: 15px;
        }
        .cart-item {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 1rem;
            padding: 1rem;
        }
        .cart-item img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 5px;
        }
        .quantity-control {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .quantity-btn {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            cursor: pointer;
        }
        .quantity-input {
            width: 60px;
            text-align: center;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            padding: 0.25rem;
        }
        .remove-btn {
            color: #dc3545;
            background: none;
            border: none;
            cursor: pointer;
        }
        .remove-btn:hover {
            color: #c82333;
        }
        .cart-summary {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 1.5rem;
            position: sticky;
            top: 1rem;
        }
        .empty-cart {
            text-align: center;
            padding: 3rem;
        }
        .empty-cart i {
            font-size: 4rem;
            color: #dee2e6;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body class="bg-light">
<!-- Top Navigation -->
<jsp:include page="components/topnav.jsp" />

<!-- Cart Header -->
<div class="cart-header">
    <div class="container">
        <h1>Shopping Cart</h1>
        <p class="mb-0">Review and modify your items before checkout</p>
    </div>
</div>

<div class="container mb-5">
    <c:choose>
        <c:when test="${empty cartItems}">
            <div class="empty-cart">
                <i class="bi bi-cart-x"></i>
                <h3>Your cart is empty</h3>
                <p>Looks like you haven't added any items to your cart yet.</p>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">
                    Continue Shopping
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row">
                <!-- Cart Items -->
                <div class="col-lg-8">
                    <c:forEach items="${cartItems}" var="item">
                        <div class="cart-item" data-cart-id="${item.id}">
                            <div class="row align-items-center">
                                <div class="col-md-2">
                                    <img src="${pageContext.request.contextPath}/${item.product.imagePath != null ? item.product.imagePath : 'assets/default-product.jpg'}"
                                         alt="${item.product.name}" class="img-fluid">
                                </div>
                                <div class="col-md-4">
                                    <h5>${item.product.name}</h5>
                                    <p class="text-muted mb-0">
                                        Category: ${item.product.category.name}
                                    </p>
                                </div>
                                <div class="col-md-3">
                                    <div class="quantity-control">
                                        <button class="quantity-btn" onclick="updateQuantity(${item.id}, -1)">-</button>
                                        <input type="number" class="quantity-input" value="${item.quantity}"
                                               min="1" max="${item.product.stock}"
                                               onchange="handleQuantityChange(${item.id}, this.value)">
                                        <button class="quantity-btn" onclick="updateQuantity(${item.id}, 1)">+</button>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="fw-bold">Rs. ${item.product.price}</div>
                                </div>
                                <div class="col-md-1">
                                    <button class="remove-btn" onclick="removeFromCart(${item.id})">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Cart Summary -->
                <div class="col-lg-4">
                    <div class="cart-summary">
                        <h4>Cart Summary</h4>
                        <hr>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Subtotal</span>
                            <span class="fw-bold" id="subtotal">Rs. 0.00</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Shipping</span>
                            <span class="fw-bold" id="shipping">Rs. 0.00</span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between mb-3">
                            <span>Total</span>
                            <span class="fw-bold" id="total">Rs. 0.00</span>
                        </div>
                        <button class="btn btn-primary w-100" onclick="proceedToCheckout()">
                            Proceed to Checkout
                        </button>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    // Initialize cart summary on page load
    document.addEventListener('DOMContentLoaded', function() {
        updateCartSummary();
    });

    function updateQuantity(cartId, change) {
        const input = document.querySelector(`.cart-item[data-cart-id="\${cartId}"] .quantity-input`);
        const newValue = parseInt(input.value) + change;
        if (newValue >= 1 && newValue <= parseInt(input.max)) {
            input.value = newValue;
            handleQuantityChange(cartId, newValue);
        }
    }

    function handleQuantityChange(cartId, quantity) {
        fetch('${pageContext.request.contextPath}/cart/update', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `cartId=\${cartId}&quantity=\${quantity}`
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    updateCartSummary();
                } else {
                    throw new Error(data.message || 'Failed to update cart');
                }
            })
            .catch(error => {
                Swal.fire({
                    icon: 'error',
                    title: 'Error!',
                    text: error.message
                });
            });
    }

    function removeFromCart(cartId) {
        Swal.fire({
            title: 'Remove Item?',
            text: "Are you sure you want to remove this item from your cart?",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Yes, remove it!'
        }).then((result) => {
            if (result.isConfirmed) {
                fetch('${pageContext.request.contextPath}/cart/remove', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `cartId=\${cartId}`
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            const cartItem = document.querySelector(`.cart-item[data-cart-id="\${cartId}"]`);
                            cartItem.remove();
                            updateCartSummary();

                            // Check if cart is empty and reload if necessary
                            if (document.querySelectorAll('.cart-item').length === 0) {
                                location.reload();
                            }
                        } else {
                            throw new Error(data.message || 'Failed to remove item');
                        }
                    })
                    .catch(error => {
                        Swal.fire({
                            icon: 'error',
                            title: 'Error!',
                            text: error.message
                        });
                    });
            }
        });
    }

    function updateCartSummary() {
        let subtotal = 0;
        document.querySelectorAll('.cart-item').forEach(item => {
            const price = parseFloat(item.querySelector('.fw-bold').textContent.replace('Rs. ', ''));
            const quantity = parseInt(item.querySelector('.quantity-input').value);
            subtotal += price * quantity;
        });

        const shipping = subtotal > 0 ? 200 : 0; // Fixed shipping cost
        const total = subtotal + shipping;

        document.getElementById('subtotal').textContent = `Rs. \${subtotal.toFixed(2)}`;
        document.getElementById('shipping').textContent = `Rs. \${shipping.toFixed(2)}`;
        document.getElementById('total').textContent = `Rs. \${total.toFixed(2)}`;
    }

    function proceedToCheckout() {
        window.location.href = '${pageContext.request.contextPath}/checkout';
    }
</script>
</body>
</html>