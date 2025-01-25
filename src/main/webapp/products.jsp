<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products - Novoxia E-Commerce</title>
    <link rel="icon" type="image/x-icon" href="assets/a.svg">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #00a8ff;
            --secondary-color: #3fd3df;
            --text-dark: #2d3436;
            --text-light: #636e72;
            --border-color: #e1f6ff;
        }

        body {
            background-color: #f8f9fa;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            padding-top: 60px;
        }

        .header-section {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 2.5rem 0;
            margin-bottom: 2rem;
            border-radius: 15px;
            margin-top: 1rem;
        }

        .filters-section {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 2rem;
        }

        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 2rem;
            padding: 1rem;
        }

        .product-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            overflow: hidden;
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .product-image-wrapper {
            position: relative;
            padding-top: 75%;
            overflow: hidden;
        }

        .product-image {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .category-badge {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: rgba(255, 255, 255, 0.95);
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.8rem;
            color: var(--primary-color);
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            z-index: 1;
        }

        .product-content {
            padding: 1.5rem;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .product-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        .product-description {
            color: var(--text-light);
            font-size: 0.9rem;
            margin-bottom: 1rem;
            flex-grow: 1;
        }

        .product-footer {
            margin-top: auto;
        }

        .product-price {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }

        .stock-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            margin-bottom: 1rem;
        }

        .stock-badge.in-stock {
            background-color: #d4edda;
            color: #155724;
        }

        .stock-badge.out-of-stock {
            background-color: #f8d7da;
            color: #721c24;
        }

        .btn-action {
            padding: 0.5rem;
            border: none;
            border-radius: 8px;
            background: #f8f9fa;
            color: var(--text-dark);
            transition: all 0.2s ease;
            width: 36px;
            height: 36px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
        }

        .btn-action:hover {
            background: #e9ecef;
        }

        .btn-action.delete:hover {
            background: #dc3545;
            color: white;
        }

        .btn-cart {
            width: 100%;
            padding: 0.75rem;
            border: none;
            border-radius: 8px;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
        }

        .btn-cart:hover:not(:disabled) {
            opacity: 0.9;
            transform: translateY(-1px);
        }

        .btn-cart:disabled {
            background: #ced4da;
            cursor: not-allowed;
        }

        .required:after {
            content: " *";
            color: red;
        }
    </style>
</head>
<body>
<jsp:include page="components/topnav.jsp" />

<div class="container">
    <div class="header-section">
        <div class="d-flex justify-content-between align-items-center mx-4">
            <div>
                <h1 class="mb-2">Products</h1>
                <p class="mb-0">Browse our collection</p>
            </div>
            <c:if test="${sessionScope.role == 'ADMIN'}">
                <button class="btn btn-light px-4 py-2" data-bs-toggle="modal" data-bs-target="#productModal">
                    <i class="bi bi-plus-lg me-2"></i>Add New Product
                </button>
            </c:if>
        </div>
    </div>

    <div class="filters-section">
        <div class="row g-3">
            <div class="col-12 col-md-4">
                <div class="input-group">
                        <span class="input-group-text bg-transparent border-end-0">
                            <i class="bi bi-search"></i>
                        </span>
                    <input type="text" class="form-control border-start-0 ps-0"
                           id="searchInput" placeholder="Search products..."
                           value="${param.term}">
                </div>
            </div>
            <div class="col-12 col-md-4">
                <select class="form-select" id="categorySelect">
                    <option value="">All Categories</option>
                    <c:forEach items="${categories}" var="category">
                        <option value="${category.id}" ${param.category == category.id ? 'selected' : ''}>
                                ${category.name}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-12 col-md-4">
                <select class="form-select" id="sortSelect">
                    <option value="newest">Newest First</option>
                    <option value="priceAsc">Price: Low to High</option>
                    <option value="priceDesc">Price: High to Low</option>
                    <option value="nameAsc">Name: A to Z</option>
                </select>
            </div>
        </div>
    </div>

    <div class="modal fade" id="productModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalTitle">Add New Product</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="productForm" method="post" enctype="multipart/form-data">
                    <div class="modal-body">
                        <input type="hidden" id="productId" name="id">
                        <input type="hidden" id="methodField" name="_method" value="POST">

                        <div class="mb-3">
                            <label class="form-label required">Product Name</label>
                            <input type="text" class="form-control" name="name" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea class="form-control" name="description"></textarea>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label required">Price (Rs.)</label>
                                <input type="number" class="form-control" name="price" step="0.01" min="0" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label required">Stock</label>
                                <input type="number" class="form-control" name="stock" min="0" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label required">Category</label>
                            <select class="form-select" name="categoryId" required>
                                <option value="">Select Category</option>
                                <c:forEach items="${categories}" var="category">
                                    <option value="${category.id}">${category.name}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Product Image</label>
                            <input type="file" class="form-control" name="image" accept="image/*">
                            <div class="image-preview mt-2" style="display: none;">
                                <img id="imagePreview" src="#" alt="Preview" style="max-width: 100%; height: 200px; object-fit: contain;">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Product</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="product-grid">
        <c:forEach items="${products}" var="product">
            <div class="product-card">
                <div class="product-image-wrapper">
                        <span class="category-badge">
                            <i class="bi bi-tag-fill me-1"></i>${product.category.name}
                        </span>
                    <img src="${pageContext.request.contextPath}/${product.imagePath != null ? product.imagePath : 'assets/images/default-product.jpg'}"
                         class="product-image" alt="${product.name}">
                </div>
                <div class="product-content">
                    <h3 class="product-title">${product.name}</h3>
                    <p class="product-description">${product.description}</p>
                    <div class="product-footer">
                        <div class="product-price">
                            Rs. <fmt:formatNumber value="${product.price}" pattern="#,##0.00"/>
                        </div>
                        <div class="stock-badge ${product.stock > 0 ? 'in-stock' : 'out-of-stock'}">
                            <i class="bi ${product.stock > 0 ? 'bi-check-circle-fill' : 'bi-x-circle-fill'} me-1"></i>
                                ${product.stock > 0 ? 'In Stock' : 'Out of Stock'}
                        </div>
                        <div class="d-flex gap-2">
                            <c:if test="${sessionScope.role == 'ADMIN'}">
                                <button class="btn-action" onclick="editProduct(${product.id})"
                                        title="Edit Product">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <button class="btn-action delete" onclick="deleteProduct(${product.id}, '${product.name}')"
                                        title="Delete Product">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </c:if>
                            <button class="btn-cart"
                                    data-product-id="${product.id}"
                                    onclick="addToCart(${product.id}, '${product.name}')"
                                ${product.stock <= 0 ? 'disabled' : ''}>
                                <i class="bi bi-cart-plus"></i>
                                Add to Cart
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const productForm = document.getElementById('productForm');
        const imageInput = productForm.querySelector('input[name="image"]');
        const imagePreview = document.getElementById('imagePreview');
        const previewContainer = document.querySelector('.image-preview');

        imageInput.addEventListener('change', function(e) {
            const file = this.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    imagePreview.src = e.target.result;
                    previewContainer.style.display = 'block';
                }
                reader.readAsDataURL(file);
            } else {
                previewContainer.style.display = 'none';
            }
        });

        productForm.addEventListener('submit', async function(e) {
            e.preventDefault();
            const submitBtn = this.querySelector('button[type="submit"]');
            submitBtn.disabled = true;

            try {
                const formData = new FormData(this);

                const response = await fetch('${pageContext.request.contextPath}/products', {
                    method: 'POST',
                    body: formData
                });

                const contentType = response.headers.get('content-type');
                if (!response.ok || !contentType || !contentType.includes('application/json')) {
                    throw new Error('Server error: ' + response.status);
                }

                const result = await response.json();

                if (result.success) {
                    const modal = bootstrap.Modal.getInstance(document.getElementById('productModal'));
                    modal.hide();

                    Swal.fire({
                        icon: 'success',
                        title: 'Success!',
                        text: 'Product saved successfully',
                        showConfirmButton: false,
                        timer: 1500
                    }).then(() => {
                        window.location.reload();
                    });
                } else {
                    throw new Error(result.message || 'Failed to save product');
                }
            } catch (error) {
                console.error('Error:', error);
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: error.message || 'Failed to save product. Please try again.'
                });
            } finally {
                submitBtn.disabled = false;
            }
        });

        const searchInput = document.getElementById('searchInput');
        const categorySelect = document.getElementById('categorySelect');
        const sortSelect = document.getElementById('sortSelect');

        function debounce(func, wait) {
            let timeout;
            return function executedFunction(...args) {
                const later = () => {
                    clearTimeout(timeout);
                    func(...args);
                };
                clearTimeout(timeout);
                timeout = setTimeout(later, wait);
            };
        }

        function applyFilters() {
            const searchTerm = searchInput.value.trim();
            const categoryId = categorySelect.value;
            const sortBy = sortSelect.value;

            const params = new URLSearchParams();
            if (searchTerm) params.append('term', searchTerm);
            if (categoryId) params.append('category', categoryId);
            if (sortBy) params.append('sort', sortBy);

            window.location.href = '${pageContext.request.contextPath}/products/search?' + params.toString();
        }

        searchInput.addEventListener('input', debounce(applyFilters, 500));
        categorySelect.addEventListener('change', applyFilters);
        sortSelect.addEventListener('change', applyFilters);
    });

    async function editProduct(productId) {
        try {
            const response = await fetch('${pageContext.request.contextPath}/products?id=' + productId);
            const product = await response.json();

            const form = document.getElementById('productForm');
            form.querySelector('[name="name"]').value = product.name || '';
            form.querySelector('[name="description"]').value = product.description || '';
            form.querySelector('[name="price"]').value = product.price || '';
            form.querySelector('[name="stock"]').value = product.stock || '';
            if (product.category) {
                form.querySelector('[name="categoryId"]').value = product.category.id;
            }

            document.getElementById('productId').value = product.id;
            document.getElementById('methodField').value = 'PUT';
            document.getElementById('modalTitle').textContent = 'Edit Product';

            const imagePreview = document.querySelector('.image-preview');
            const previewImg = document.getElementById('imagePreview');
            if (product.imagePath) {
                previewImg.src = '${pageContext.request.contextPath}/' + product.imagePath;
                imagePreview.style.display = 'block';
            } else {
                imagePreview.style.display = 'none';
            }

            const modal = new bootstrap.Modal(document.getElementById('productModal'));
            modal.show();
        } catch (error) {
            console.error('Edit error:', error);
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Failed to load product details'
            });
        }
    }

    async function deleteProduct(productId, productName) {
        try {
            const result = await Swal.fire({
                title: 'Delete Product',
                text: `Are you sure you want to delete "${productName}"?`,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Yes, delete it!'
            });

            if (result.isConfirmed) {
                const response = await fetch('${pageContext.request.contextPath}/products?id=' + productId, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: '_method=DELETE'
                });

                const data = await response.json();

                if (data.success) {
                    Swal.fire({
                        icon: 'success',
                        title: 'Deleted!',
                        text: `${productName} has been deleted successfully`,
                        showConfirmButton: false,
                        timer: 1500
                    }).then(() => {
                        window.location.reload();
                    });
                } else {
                    throw new Error(data.message || 'Failed to delete product');
                }
            }
        } catch (error) {
            console.error('Delete error:', error);
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: error.message || 'Failed to delete product'
            });
        }
    }

    async function addToCart(productId, productName) {
        // Find the button
        const addToCartBtn = document.querySelector(`button.btn-cart[onclick*="addToCart(${productId}"]`);

        try {
            // Update button state
            if (addToCartBtn) {
                addToCartBtn.disabled = true;
                addToCartBtn.innerHTML = '<i class="bi bi-hourglass-split"></i> Adding...';
            }

            console.log('Sending request to add product:', productId); // Debug log

            const response = await fetch(`${pageContext.request.contextPath}/cart/add`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest',
                    'Accept': 'application/json'
                },
                body: new URLSearchParams({
                    productId: productId,
                    quantity: 1
                }).toString()
            });

            console.log('Response status:', response.status); // Debug log
            console.log('Response headers:', Object.fromEntries(response.headers.entries())); // Debug log

            // Handle redirects (e.g., to login page)
            if (response.redirected) {
                window.location.href = response.url;
                return;
            }

            let responseText;
            try {
                responseText = await response.text(); // Get raw response text
                console.log('Raw response:', responseText); // Debug log

                const data = JSON.parse(responseText); // Try to parse as JSON

                if (!response.ok) {
                    throw new Error(data.message || `Server error: ${response.status}`);
                }

                if (data.success) {
                    // Update cart badge
                    const cartBadge = document.getElementById('cartCountBadge');
                    if (cartBadge) {
                        if (data.cartCount > 0) {
                            cartBadge.textContent = data.cartCount;
                            cartBadge.classList.remove('d-none');
                        } else {
                            cartBadge.classList.add('d-none');
                        }
                    }

                    // Dispatch cart update event
                    window.dispatchEvent(new CustomEvent('cartUpdate', {
                        detail: { count: data.cartCount }
                    }));

                    // Show success message
                    await Swal.fire({
                        icon: 'success',
                        title: 'Added to Cart!',
                        text: `${productName} has been added to your cart`,
                        showConfirmButton: false,
                        timer: 1500
                    });
                } else {
                    throw new Error(data.message || 'Failed to add to cart');
                }
            } catch (parseError) {
                console.error('Response parsing error:', parseError); // Debug log
                console.log('Response text was:', responseText); // Debug log
                throw new Error('Invalid server response format');
            }
        } catch (error) {
            console.error('Add to cart error:', error);

            // Show appropriate error message
            if (error.message.includes('login')) {
                const result = await Swal.fire({
                    icon: 'warning',
                    title: 'Login Required',
                    text: 'Please login to add items to your cart',
                    showCancelButton: true,
                    confirmButtonText: 'Login',
                    confirmButtonColor: '#2563eb',
                    cancelButtonText: 'Cancel',
                    cancelButtonColor: '#64748b'
                });

                if (result.isConfirmed) {
                    const currentPage = encodeURIComponent(window.location.pathname + window.location.search);
                    window.location.href = `${pageContext.request.contextPath}/login?redirect=${currentPage}`;
                    return;
                }
            } else {
                await Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: error.message || 'Failed to add product to cart'
                });
            }
        } finally {
            // Restore button state
            if (addToCartBtn) {
                addToCartBtn.disabled = false;
                addToCartBtn.innerHTML = '<i class="bi bi-cart-plus"></i> Add to Cart';
            }
        }
    }
</script>
</body>
</html>