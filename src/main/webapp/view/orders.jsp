<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Place Order</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        :root {
            --primary-color: #6366f1;
            --secondary-bg: #f8fafc;
            --border-color: #e2e8f0;
        }

        body {
            background-color: var(--secondary-bg);
            font-family: 'Inter', system-ui, -apple-system, sans-serif;
        }

        .page-container {
            max-width: 1400px;
            margin: 2rem auto;
            padding: 0 1.5rem;
        }

        .product-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            overflow: hidden;
            cursor: pointer;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .product-img {
            height: 200px;
            object-fit: cover;
        }

        .product-selected {
            border: 2px solid var(--primary-color);
        }

        .order-summary {
            background: white;
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 2rem;
        }

        .quantity-control {
            width: 120px;
        }

        .step-indicator {
            display: flex;
            margin-bottom: 2rem;
        }

        .step {
            flex: 1;
            text-align: center;
            padding: 1rem;
            position: relative;
        }

        .step::after {
            content: '';
            position: absolute;
            width: 100%;
            height: 2px;
            background: var(--border-color);
            top: 50%;
            left: 50%;
            z-index: -1;
        }

        .step:last-child::after {
            display: none;
        }

        .step-number {
            width: 32px;
            height: 32px;
            background: white;
            border: 2px solid var(--border-color);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 0.5rem;
        }

        .step.active .step-number {
            background: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }

        .search-container {
            position: relative;
            max-width: 300px;
        }

        .search-input {
            padding: 0.75rem 1rem 0.75rem 2.5rem;
            border-radius: 12px;
            border: 1px solid var(--border-color);
            width: 100%;
        }

        .search-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #64748b;
        }
    </style>
</head>
<body>
<div class="page-container">
    <!-- Step Indicator -->
    <div class="step-indicator">
        <div class="step active">
            <div class="step-number">1</div>
            <div>Select Products</div>
        </div>
        <div class="step">
            <div class="step-number">2</div>
            <div>Review Order</div>
        </div>
        <div class="step">
            <div class="step-number">3</div>
            <div>Checkout</div>
        </div>
    </div>

    <div class="row g-4">
        <!-- Products Selection -->
        <div class="col-lg-8">
            <!-- Search and Filters -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div class="search-container">
                    <i class="bi bi-search search-icon"></i>
                    <input type="text" class="search-input" placeholder="Search products...">
                </div>
                <div class="d-flex gap-2">
                    <select class="form-select" style="width: 150px;">
                        <option value="">All Categories</option>
                        <option>Electronics</option>
                        <option>Fashion</option>
                        <option>Books</option>
                    </select>
                    <select class="form-select" style="width: 150px;">
                        <option value="">Sort By Price</option>
                        <option>Low to High</option>
                        <option>High to Low</option>
                    </select>
                </div>
            </div>

            <!-- Products Grid -->
            <div class="row g-4">
                <!-- Product Card -->
                <div class="col-md-6">
                    <div class="product-card">
                        <img src="/api/placeholder/400/320" class="product-img w-100" alt="Product">
                        <div class="p-3">
                            <h6 class="mb-1">iPhone 14 Pro</h6>
                            <div class="text-primary fw-semibold mb-2">$999.00</div>
                            <p class="text-muted small mb-3">Latest iPhone with advanced features</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="quantity-control input-group">
                                    <button class="btn btn-outline-secondary">-</button>
                                    <input type="number" class="form-control text-center" value="1" min="1">
                                    <button class="btn btn-outline-secondary">+</button>
                                </div>
                                <button class="btn btn-primary">Add</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- More Product Cards -->
                <div class="col-md-6">
                    <div class="product-card">
                        <img src="/api/placeholder/400/320" class="product-img w-100" alt="Product">
                        <div class="p-3">
                            <h6 class="mb-1">MacBook Air</h6>
                            <div class="text-primary fw-semibold mb-2">$1,299.00</div>
                            <p class="text-muted small mb-3">M2 chip, all-day battery life</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="quantity-control input-group">
                                    <button class="btn btn-outline-secondary">-</button>
                                    <input type="number" class="form-control text-center" value="1" min="1">
                                    <button class="btn btn-outline-secondary">+</button>
                                </div>
                                <button class="btn btn-primary">Add</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Order Summary -->
        <div class="col-lg-4">
            <div class="order-summary">
                <h5 class="mb-4">Order Summary</h5>

                <!-- Selected Products -->
                <div class="selected-products mb-4">
                    <div class="selected-product mb-3">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h6 class="mb-1">iPhone 14 Pro</h6>
                                <div class="text-muted small">Quantity: 1</div>
                            </div>
                            <div class="text-end">
                                <div class="fw-semibold">$999.00</div>
                                <button class="btn btn-link btn-sm text-danger p-0">Remove</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Price Details -->
                <div class="price-details mb-4">
                    <div class="d-flex justify-content-between mb-2">
                        <span>Subtotal</span>
                        <span class="fw-semibold">$999.00</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Tax (10%)</span>
                        <span class="fw-semibold">$99.90</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Shipping</span>
                        <span class="fw-semibold">$10.00</span>
                    </div>
                    <hr>
                    <div class="d-flex justify-content-between">
                        <span class="fw-semibold">Total</span>
                        <span class="fw-bold text-primary">$1,108.90</span>
                    </div>
                </div>

                <!-- Actions -->
                <div class="d-grid gap-2">
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#checkoutModal">
                        <i class="bi bi-credit-card me-2"></i>Proceed to Checkout
                    </button>
                    <button class="btn btn-outline-secondary">
                        <i class="bi bi-cart me-2"></i>Continue Shopping
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Checkout Modal -->
<div class="modal fade" id="checkoutModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header border-0">
                <h5 class="modal-title">Checkout</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="checkoutForm">
                    <!-- Shipping Information -->
                    <h6 class="mb-3">Shipping Information</h6>
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="form-label">First Name</label>
                            <input type="text" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Last Name</label>
                            <input type="text" class="form-control" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Address</label>
                            <input type="text" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">City</label>
                            <input type="text" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">ZIP Code</label>
                            <input type="text" class="form-control" required>
                        </div>
                    </div>

                    <!-- Payment Information -->
                    <h6 class="mb-3">Payment Information</h6>
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label">Card Number</label>
                            <input type="text" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Expiry Date</label>
                            <input type="text" class="form-control" placeholder="MM/YY" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">CVV</label>
                            <input type="text" class="form-control" required>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-0">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary">Place Order</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Handle quantity controls
    document.querySelectorAll('.quantity-control').forEach(control => {
        const input = control.querySelector('input');
        const decreaseBtn = control.querySelector('button:first-child');
        const increaseBtn = control.querySelector('button:last-child');

        decreaseBtn.addEventListener('click', () => {
            if (input.value > 1) {
                input.value = parseInt(input.value) - 1;
            }
        });

        increaseBtn.addEventListener('click', () => {
            input.value = parseInt(input.value) + 1;
        });
    });

    // Handle product selection
    document.querySelectorAll('.product-card').forEach(card => {
        card.addEventListener('click', () => {
            card.classList.toggle('product-selected');
        });
    });
</script>
</body>
</html>