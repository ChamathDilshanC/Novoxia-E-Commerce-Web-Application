<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Novoxia</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <style>
        .checkout-header {
            background: linear-gradient(135deg, #05c46b 0%, #ffffff 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            margin-top: 1rem;
            border-radius: 15px;
        }
        .order-summary {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 1.5rem;
            position: sticky;
            top: 1rem;
        }
        .checkout-form {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 1.5rem;
        }
    </style>
</head>
<body class="bg-light">
<!-- Top Navigation -->
<jsp:include page="components/topnav.jsp" />

<!-- Checkout Header -->
<div class="checkout-header">
    <div class="container">
        <h1>Checkout</h1>
        <p class="mb-0">Complete your order</p>
    </div>
</div>

<div class="container mb-5">
    <div class="row g-4">
        <!-- Checkout Form -->
        <div class="col-lg-8">
            <div class="checkout-form">
                <form id="checkoutForm">
                    <h4 class="mb-4">Shipping Information</h4>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">First Name</label>
                            <input type="text" class="form-control" name="firstName" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Last Name</label>
                            <input type="text" class="form-control" name="lastName" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Address</label>
                            <input type="text" class="form-control" name="address" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">City</label>
                            <input type="text" class="form-control" name="city" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">ZIP Code</label>
                            <input type="text" class="form-control" name="zipCode" required>
                        </div>
                    </div>

                    <h4 class="mb-4 mt-4">Payment Method</h4>
                    <div class="mb-4">
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="paymentMethod"
                                   value="CASH_ON_DELIVERY" id="cashOnDelivery" checked>
                            <label class="form-check-label" for="cashOnDelivery">
                                Cash on Delivery
                            </label>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100">
                        Place Order
                    </button>
                </form>
            </div>
        </div>

        <!-- Order Summary -->
        <div class="col-lg-4">
            <div class="order-summary">
                <h4 class="mb-4">Order Summary</h4>

                <div class="order-items mb-4">
                    <c:forEach items="${cartItems}" var="item">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <div>
                                <h6 class="mb-0">${item.product.name}</h6>
                                <small class="text-muted">Quantity: ${item.quantity}</small>
                            </div>
                            <span class="fw-bold">
                                Rs. ${item.product.price * item.quantity}
                            </span>
                        </div>
                    </c:forEach>
                </div>

                <hr>

                <div class="d-flex justify-content-between mb-2">
                    <span>Subtotal</span>
                    <span class="fw-bold">Rs. ${subtotal}</span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span>Shipping</span>
                    <span class="fw-bold">Rs. ${shippingCost}</span>
                </div>
                <hr>
                <div class="d-flex justify-content-between mb-4">
                    <span class="h5 mb-0">Total</span>
                    <span class="h5 mb-0 text-primary">Rs. ${total}</span>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    document.getElementById('checkoutForm').addEventListener('submit', async function(event) {
        event.preventDefault();

        Swal.fire({
            title: 'Processing Order',
            text: 'Please wait...',
            allowOutsideClick: false,
            didOpen: () => {
                Swal.showLoading()
            }
        });

        try {
            const formData = new FormData(this);
            const data = new URLSearchParams();
            for (const [key, value] of formData.entries()) {
                data.append(key, value);
            }

            const response = await fetch('${pageContext.request.contextPath}/checkout', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: data.toString()
            });

            const result = await response.json();

            if (result.success) {
                Swal.fire({
                    icon: 'success',
                    title: 'Order Placed Successfully!',
                    text: 'Thank you for your order.',
                    confirmButtonText: 'View Orders'
                }).then((result) => {
                    window.location.href = '${pageContext.request.contextPath}/orders';
                });
            } else {
                throw new Error(result.message || 'Failed to place order');
            }
        } catch (error) {
            Swal.fire({
                icon: 'error',
                title: 'Order Failed',
                text: error.message || 'Failed to place order. Please try again.',
                confirmButtonText: 'OK'
            });
        }
    });

    document.querySelector('input[name="zipCode"]').addEventListener('input', function(e) {
        // Only allow numbers
        this.value = this.value.replace(/[^0-9]/g, '');
        // Limit to 5 digits
        if (this.value.length > 5) {
            this.value = this.value.slice(0, 5);
        }
    });

    function validateForm() {
        const firstName = document.querySelector('input[name="firstName"]').value.trim();
        const lastName = document.querySelector('input[name="lastName"]').value.trim();
        const address = document.querySelector('input[name="address"]').value.trim();
        const city = document.querySelector('input[name="city"]').value.trim();
        const zipCode = document.querySelector('input[name="zipCode"]').value.trim();

        if (!firstName || !lastName || !address || !city || !zipCode) {
            Swal.fire({
                icon: 'error',
                title: 'Required Fields',
                text: 'Please fill in all required fields'
            });
            return false;
        }

        if (zipCode.length !== 5) {
            Swal.fire({
                icon: 'error',
                title: 'Invalid ZIP Code',
                text: 'Please enter a valid 5-digit ZIP code'
            });
            return false;
        }

        return true;
    }

    document.getElementById('checkoutForm').addEventListener('submit', function(event) {
        if (!validateForm()) {
            event.preventDefault();
            return false;
        }
    });
</script>
</body>
</html>