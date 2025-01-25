<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products - Novoxia</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        :root {
            --primary-color: #6366f1;
            --primary-bg: #f3f4f6;
        }

        body {
            background-color: var(--primary-bg);
            font-family: system-ui, -apple-system, 'Segoe UI', sans-serif;
        }

        .page-container {
            max-width: 1400px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        .product-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
            height: 100%;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .card-img-top {
            height: 200px;
            object-fit: cover;
            border-top-left-radius: 16px;
            border-top-right-radius: 16px;
        }

        .category-badge {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: rgba(255, 255, 255, 0.9);
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-size: 0.875rem;
            font-weight: 500;
            backdrop-filter: blur(4px);
        }

        .stock-badge {
            font-size: 0.875rem;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-weight: 500;
        }

        .search-container {
            position: relative;
        }

        .search-input {
            padding-left: 2.5rem;
            border-radius: 8px;
        }

        .search-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #6b7280;
        }

        .add-to-cart-btn {
            background-color: var(--primary-color);
            color: white;
            border: none;
            width: 100%;
            padding: 0.75rem;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .add-to-cart-btn:hover:not(:disabled) {
            background-color: #4f46e5;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
<div class="page-container">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-1">Products</h2>
            <p class="text-muted mb-0">Explore our collection</p>
        </div>
        <div class="d-flex gap-3">
            <a href="cart.jsp" class="btn btn-outline-primary position-relative">
                <i class="bi bi-cart me-2"></i>Cart
                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                    ${cartCount}
                </span>
            </a>
        </div>
    </div>

    <!-- Filters -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="search-container">
                <i class="bi bi-search search-icon"></i>
                <input type="text" class="form-control search-input" placeholder="Search products...">
            </div>
        </div>
        <div class="col-md-8">
            <div class="d-flex gap-3">
                <select class="form-select" style="width: 200px;">
                    <option value="">All Categories</option>
                    <c:forEach items="${categories}" var="category">
                        <option value="${category.id}">${category.name}</option>
                    </c:forEach>
                </select>
                <select class="form-select" style="width: 200px;">
                    <option value="">Sort By</option>
                    <option value="price_asc">Price: Low to High</option>
                    <option value="price_desc">Price: High to Low</option>
                    <option value="name">Name</option>
                </select>
            </div>
        </div>
    </div>

    <!-- Products Grid -->
    <div class="row g-4">
        <c:forEach items="${products}" var="product">
            <div class="col-sm-6 col-lg-3">
                <div class="card product-card">
                    <img src="/api/placeholder/400/320" class="card-img-top" alt="${product.name}">
                    <span class="category-badge">${product.category.name}</span>
                    <div class="card-body">
                        <h5 class="card-title mb-1">${product.name}</h5>
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="h5 mb-0">$${String.format("%.2f", product.price)}</span>
                            <c:choose>
                                <c:when test="${product.stock > 10}">
                                    <span class="stock-badge bg-success bg-opacity-10 text-success">
                                        In Stock
                                    </span>
                                </c:when>
                                <c:when test="${product.stock > 0}">
                                    <span class="stock-badge bg-warning bg-opacity-10 text-warning">
                                        Low Stock
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="stock-badge bg-danger bg-opacity-10 text-danger">
                                        Out of Stock
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <p class="card-text text-muted mb-4">${product.description}</p>
                        <button onclick="addToCart(${product.id})" class="add-to-cart-btn"
                            ${product.stock == 0 ? 'disabled' : ''}>
                            <i class="bi bi-cart-plus me-2"></i>
                                ${product.stock == 0 ? 'Out of Stock' : 'Add to Cart'}
                        </button>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function addToCart(productId) {
        fetch('add-to-cart', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'productId=' + productId
        })
            .then(response => {
                if (response.ok) {
                    // Show success message
                    alert('Product added to cart!');
                    // Optionally reload page to update cart count
                    window.location.reload();
                } else {
                    alert('Failed to add product to cart');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('An error occurred');
            });
    }
</script>
</body>
</html>