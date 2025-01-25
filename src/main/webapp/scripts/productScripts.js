function showLoading() {
    document.getElementById('loadingSpinner').style.display = 'block';
}

function hideLoading() {
    document.getElementById('loadingSpinner').style.display = 'none';
}

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

document.getElementById('productForm').addEventListener('submit', async function(e) {
    e.preventDefault();
    showLoading();

    try {
        const formData = new FormData(this);
        const isEdit = formData.get('_method') === 'PUT';

        const response = await fetch('${pageContext.request.contextPath}/products', {
            method: 'POST',
            body: formData,
            credentials: 'same-origin'
        });

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();
        if (data.success) {
            const modal = bootstrap.Modal.getInstance(document.getElementById('productModal'));
            modal.hide();

            Swal.fire({
                icon: 'success',
                title: 'Success!',
                text: isEdit
                    ? `Product "${data.productName}" updated successfully`
                    : `Product "${data.productName}" added successfully`,
                showConfirmButton: false,
                timer: 1500
            }).then(() => {
                window.location.reload();
            });
        } else {
            throw new Error(data.message || 'Operation failed');
        }
    } catch (error) {
        console.error('Form submission error:', error);
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: error.message || 'Failed to process your request. Please try again.'
        });
    } finally {
        hideLoading();
    }
});

async function editProduct(productId) {
    try {
        showLoading();
        const response = await fetch('${pageContext.request.contextPath}/products?id=' + productId, {
            method: 'GET',
            headers: {
                'Accept': 'application/json'
            },
            credentials: 'same-origin'
        });

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        const product = await response.json();
        const form = document.getElementById('productForm');
        form.reset();

        document.getElementById('productId').value = product.id;
        document.getElementById('methodField').value = 'PUT';
        document.getElementById('modalTitle').textContent = 'Edit Product';

        form.querySelector('[name="name"]').value = product.name || '';
        form.querySelector('[name="description"]').value = product.description || '';
        form.querySelector('[name="price"]').value = product.price || '';
        form.querySelector('[name="stock"]').value = product.stock || '';

        if (product.category && product.category.id) {
            form.querySelector('[name="categoryId"]').value = product.category.id;
        }

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
        console.error('Edit product error:', error);
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Failed to load product details. Please try again.'
        });
    } finally {
        hideLoading();
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
            showLoading();

            const response = await fetch('${pageContext.request.contextPath}/products?id=' + productId, {
                method: 'DELETE',
                credentials: 'same-origin'
            });

            const data = await response.json();

            if (data.success) {
                Swal.fire({
                    icon: 'success',
                    title: 'Deleted!',
                    text: `${data.productName} has been deleted successfully`,
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
            title: 'Error!',
            text: error.message || 'Failed to delete product. Please try again.'
        });
    } finally {
        hideLoading();
    }
}

async function addToCart(productId, productName) {
    try {
        const response = await fetch('${pageContext.request.contextPath}/cart/add', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'productId=' + encodeURIComponent(productId) + '&quantity=1',
            credentials: 'same-origin'
        });

        // Check if response is redirect to login page
        if (response.redirected) {
            window.location.href = response.url;
            return;
        }

        // Check if response is OK and contains JSON
        const contentType = response.headers.get('content-type');
        if (!response.ok || !contentType || !contentType.includes('application/json')) {
            throw new Error('Session expired or server error. Please refresh the page and try again.');
        }

        const data = await response.json();

        if (data.success) {
            // Show success message
            Swal.fire({
                icon: 'success',
                title: 'Success!',
                text: productName + ' has been added to your cart',
                showConfirmButton: false,
                timer: 1500
            }).then(() => {
                // After success message, navigate to cart page
                window.location.href = '${pageContext.request.contextPath}/cart';
            });

            // Update cart count in navigation if needed before redirect
            if (data.cartCount !== undefined) {
                const cartCountElement = document.querySelector('.cart-count');
                if (cartCountElement) {
                    cartCountElement.textContent = data.cartCount;
                }
            }
        } else {
            throw new Error(data.message || 'Failed to add to cart');
        }
    } catch (error) {
        console.error('Add to cart error:', error);
        Swal.fire({
            icon: 'error',
            title: 'Error!',
            text: error.message || 'Failed to add product to cart. Please try again.',
            confirmButtonText: 'OK'
        }).then((result) => {
            if (error.message.includes('Session expired')) {
                window.location.reload();
            }
        });
    }
}


function previewImage(input) {
    const imagePreview = document.querySelector('.image-preview');
    const previewImg = document.getElementById('imagePreview');

    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function(e) {
            previewImg.src = e.target.result;
            imagePreview.style.display = 'block';
        };
        reader.readAsDataURL(input.files[0]);
    } else {
        imagePreview.style.display = 'none';
    }
}

document.querySelector('[data-bs-target="#productModal"]')?.addEventListener('click', function() {
    const form = document.getElementById('productForm');
    form.reset();
    document.getElementById('modalTitle').textContent = 'Add New Product';
    document.getElementById('productId').value = '';
    document.getElementById('methodField').value = 'POST';
    document.querySelector('.image-preview').style.display = 'none';
});