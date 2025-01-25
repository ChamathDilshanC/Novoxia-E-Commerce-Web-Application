let categoryModal;

document.addEventListener('DOMContentLoaded', function() {
    categoryModal = new bootstrap.Modal(document.getElementById('categoryModal'));

    // Form validation
    const form = document.getElementById('categoryForm');
    form.addEventListener('submit', function(event) {
        event.preventDefault();
        if (!form.checkValidity()) {
            event.stopPropagation();
            form.classList.add('was-validated');
            return;
        }
        saveCategory();
    });
});

function openEditModal(id, name, description) {
    document.getElementById('categoryForm').reset();
    document.getElementById('categoryId').value = id;
    document.getElementById('categoryName').value = name;
    document.getElementById('categoryDescription').value = description;
    document.getElementById('modalTitle').textContent = 'Edit Category';
    document.getElementById('categoryForm').classList.remove('was-validated');
    categoryModal.show();
}

function saveCategory() {
    const form = document.getElementById('categoryForm');
    const formData = new FormData(form);
    const categoryId = formData.get('id');
    const action = categoryId && categoryId.trim() !== '' ? 'update' : 'create';
    formData.append('action', action);

    Swal.fire({
        title: 'Processing...',
        didOpen: () => {
            Swal.showLoading();
        },
        allowOutsideClick: false,
        allowEscapeKey: false,
        showConfirmButton: false
    });

    fetch('categories', {
        method: 'POST',
        body: new URLSearchParams(formData)
    })
        .then(response => {
            if (!response.ok) {
                return response.text().then(text => {
                    throw new Error(text);
                });
            }
            return response.text();
        })
        .then(() => {
            categoryModal.hide();
            Swal.fire({
                icon: 'success',
                title: 'Success!',
                text: `Category ${action}d successfully`,
                timer: 1500,
                showConfirmButton: false
            }).then(() => {
                location.reload();
            });
        })
        .catch(error => {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: error.message,
                confirmButtonColor: '#2563eb'
            });
        });
}

function confirmDelete(categoryId, categoryName) {
    Swal.fire({
        title: 'Are you sure?',
        text: `Do you want to delete category "${categoryName}"?`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#dc3545',
        cancelButtonColor: '#6c757d',
        confirmButtonText: 'Yes, delete it!',
        showLoaderOnConfirm: true,
        preConfirm: () => {
            return fetch('categories', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams({
                    action: 'delete',
                    id: categoryId
                })
            })
                .then(response => {
                    if (!response.ok) {
                        return response.text().then(text => {
                            throw new Error(text);
                        });
                    }
                    return response.text();
                })
                .catch(error => {
                    Swal.showValidationMessage(`Failed to delete: ${error.message}`);
                });
        },
        allowOutsideClick: () => !Swal.isLoading()
    }).then((result) => {
        if (result.isConfirmed) {
            Swal.fire({
                icon: 'success',
                title: 'Deleted!',
                text: 'Category has been deleted successfully.',
                timer: 1500,
                showConfirmButton: false
            }).then(() => {
                location.reload();
            });
        }
    });
}