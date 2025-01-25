<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products - Novoxia</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
    <link rel="stylesheet" href="styles/productStyles.css">
</head>

<body class="bg-light">
<!-- Top Navigation -->
<jsp:include page="components/topnav.jsp" />

<!-- Header Section -->
<div class="header-section">
    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h1 class="m-0 mb-2">Products</h1>
                <p class="m-0 text-white-50">Search Your Essential Products As You Need ❤️🫰</p>
            </div>
            <c:if test="${sessionScope.role == 'ADMIN'}">
                <button class="btn-add-product" data-bs-toggle="modal" data-bs-target="#addProductModal">
                    <i class="bi bi-plus-lg"></i> Add New Product
                </button>
            </c:if>
        </div>
    </div>
</div>

<div class="container-fluid">
    <!-- Filters Section -->
    <div class="filters-section">
        <div class="row g-3">
            <div class="col-12 col-md-4">
                <input type="text"
                       class="search-input"
                       placeholder="Search products..."
                       id="searchInput"
                       onkeyup="filterProducts()">
            </div>
            <div class="col-12 col-md-4">
                <select class="select-control" id="sortSelect" onchange="filterProducts()">
                    <option value="newest">Newest First</option>
                    <option value="priceAsc">Price: Low to High</option>
                    <option value="priceDesc">Price: High to Low</option>
                    <option value="name">Name: A to Z</option>
                </select>
            </div>
            <div class="col-12 col-md-4">
                <select class="select-control" id="categoryFilter" onchange="filterProducts()">
                    <option value="">All Categories</option>
                    <c:forEach items="${categories}" var="category">
                        <option value="${category.id}">${category.name}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
    </div>

    <!-- Products Grid -->
    <div class="row g-4" id="productsGrid">
        <c:forEach items="${products}" var="product">
            <div class="col-12 col-md-6 col-lg-4 col-xl-3 product-item"
                 data-name="${product.name.toLowerCase()}"
                 data-price="${product.price}"
                 data-category="${product.category.id}"
                 data-date="${product.createdAt}">
                <div class="product-card">
                    <div class="product-image-wrapper">
                        <img src="${pageContext.request.contextPath}/${product.imagePath != null ? product.imagePath : 'assets/default-product.jpg'}"
                             class="product-image" alt="${product.name}">
                    </div>
                    <div class="product-content">
                            <span class="category-badge">
                                <i class="bi bi-tag"></i> ${product.category.name}
                            </span>
                        <h3 class="product-title">${product.name}</h3>
                        <p class="product-description">${product.description}</p>

                        <div class="d-flex justify-content-between align-items-center">
                            <div class="product-price">Rs. ${product.price}</div>
                            <span class="stock-badge ${product.stock > 0 ? 'in-stock' : 'out-of-stock'}">
                                    <i class="bi ${product.stock > 0 ? 'bi-check-circle' : 'bi-x-circle'}"></i>
                                    ${product.stock > 0 ? 'In Stock' : 'Out of Stock'}
                                </span>
                        </div>

                        <div class="action-buttons">
                            <c:if test="${sessionScope.role == 'ADMIN'}">
                                <button class="btn-action" onclick="editProduct(${product.id})"
                                        title="Edit Product">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <button class="btn-action delete" onclick="deleteProduct(${product.id})"
                                        title="Delete Product">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </c:if>
                            <button class="btn-cart" onclick="addToCart(${product.id}, '${product.name}')"
                                ${product.stock <= 0 ? 'disabled' : ''}>
                                <i class="bi bi-cart-plus"></i> Add to Cart
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<!-- Add Product Modal -->
<div class="modal fade" id="addProductModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Add New Product</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="addProductForm" action="${pageContext.request.contextPath}/products"
                  method="POST" enctype="multipart/form-data">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Product Name</label>
                        <input type="text" class="form-control" name="name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" name="description" rows="3"></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Price (Rs.)</label>
                        <input type="number" class="form-control" name="price" step="0.01" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Stock</label>
                        <input type="number" class="form-control" name="stock" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Category</label>
                        <div class="category-section">
                            <c:forEach items="${categories}" var="category">
                                <div class="category-item">
                                    <input type="radio" class="form-check-input"
                                           name="categoryId" value="${category.id}"
                                           id="category_${category.id}">
                                    <label class="form-check-label" for="category_${category.id}">
                                            ${category.name}
                                    </label>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Product Image</label>
                        <input type="file" class="form-control" name="image" accept="image/*">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Add Product</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Product Modal -->
<div class="modal fade" id="editProductModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit Product</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="editProductForm" action="${pageContext.request.contextPath}/products"
                  method="POST" enctype="multipart/form-data">
                <input type="hidden" name="_method" value="PUT">
                <input type="hidden" name="id" id="editProductId">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Product Name</label>
                        <input type="text" class="form-control" name="name" id="editName" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" name="description" id="editDescription" rows="3"></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Price (Rs.)</label>
                        <input type="number" class="form-control" name="price" id="editPrice" step="0.01" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Stock</label>
                        <input type="number" class="form-control" name="stock" id="editStock" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Category</label>
                        <div class="category-section">
                            <c:forEach items="${categories}" var="category">
                                <div class="category-item">
                                    <input type="radio" class="form-check-input edit-category"
                                           name="categoryId" value="${category.id}"
                                           id="edit_category_${category.id}">
                                    <label class="form-check-label" for="edit_category_${category.id}">
                                            ${category.name}
                                    </label>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Product Image</label>
                        <input type="file" class="form-control" name="image" accept="image/*">
                        <small class="text-muted">Leave empty to keep current image</small>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update Product</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    function filterProducts() {
        const searchTerm = document.getElementById('searchInput').value.toLowerCase();
        const sortBy = document.getElementById('sortSelect').value;
        const categoryFilter = document.getElementById('categoryFilter').value;
        const products = document.querySelectorAll('.product-item');

        const productsArray = Array.from(products);

        productsArray.sort((a, b) => {
            switch(sortBy) {
                case 'newest':
                    return new Date(b.dataset.date) - new Date(a.dataset.date);
                case 'priceAsc':
                    return parseFloat(a.dataset.price) - parseFloat(b.dataset.price);
                case 'priceDesc':
                    return parseFloat(b.dataset.price) - parseFloat(a.dataset.price);
                case 'name':
                    return a.dataset.name.localeCompare(b.dataset.name);
                default:
                    return 0;
            }
        });

        productsArray.forEach(product => {
            const nameMatch = product.dataset.name.includes(searchTerm);
            const categoryMatch = !categoryFilter || product.dataset.category === categoryFilter;
            product.style.display = nameMatch && categoryMatch ? '' : 'none';
        });

        const productsGrid = document.getElementById('productsGrid');
        productsArray.forEach(product => productsGrid.appendChild(product));
    }

    function addToCart(productId, productName) {
        fetch('${pageContext.request.contextPath}/cart/add', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `productId=${productId}&quantity=1`
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    Swal.fire({
                        icon: 'success',
                        title: 'Success!',
                        text: `${productName} has been added to your cart`,
                        showConfirmButton: false,
                        timer: 1500
                    });
                    // Update cart count if needed
                    if (data.cartCount) {
                        updateCartCount(data.cartCount);
                    }
                } else {
                    throw new Error(data.message || 'Failed to add to cart');
                }
            })
            .catch(error => {
                Swal.fire({
                    icon: 'error',
                    title: 'Error!',
                    text: error.message || 'Failed to add product to cart',
                });
            });
    }

    function editProduct(productId) {
        fetch(`${pageContext.request.contextPath}/products?id=${productId}`)
            .then(response => response.json())
            .then(product => {
                document.getElementById('editProductId').value = product.id;
                document.getElementById('editName').value = product.name;
                document.getElementById('editDescription').value = product.description;
                document.getElementById('editPrice').value = product.price;
                document.getElementById('editStock').value = product.stock;

                if (product.category) {
                    const categoryRadio = document.querySelector(`#edit_category_${product.category.id}`);
                    if (categoryRadio) {
                        categoryRadio.checked = true;
                    }
                }

                const modal = new bootstrap.Modal(document.getElementById('editProductModal'));
                modal.show();
            })
            .catch(error => {
                Swal.fire({
                    icon: 'error',
                    title: 'Error!',
                    text: 'Failed to load product details',
                });
            });
    }

    function deleteProduct(productId) {
        Swal.fire({
            title: 'Are you sure?',
            text: "You won't be able to revert this!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, delete it!'
        }).then((result) => {
            if (result.isConfirmed) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = `${pageContext.request.contextPath}/products`;

                const methodInput = document.createElement('input');
                methodInput.type = 'hidden';
                methodInput.name = '_method';
                methodInput.value = 'DELETE';

                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = productId;

                form.appendChild(methodInput);
                form.appendChild(idInput);
                document.body.appendChild(form);
                form.submit();
            }
        });
    }

    function updateCartCount(count) {
        const cartCountElement = document.querySelector('.cart-count');
        if (cartCountElement) {
            cartCountElement.textContent = count;
        }
    }

    // Form validation
    document.addEventListener('DOMContentLoaded', function() {
        const addProductForm = document.getElementById('addProductForm');
        const editProductForm = document.getElementById('editProductForm');

        [addProductForm, editProductForm].forEach(form => {
            if (form) {
                form.addEventListener('submit', function(e) {
                    const categorySelected = this.querySelector('input[name="categoryId"]:checked');
                    if (!categorySelected) {
                        e.preventDefault();
                        Swal.fire({
                            icon: 'error',
                            title: 'Error!',
                            text: 'Please select a category'
                        });
                    }
                });
            }
        });
    });
</script>
</body>
</html>