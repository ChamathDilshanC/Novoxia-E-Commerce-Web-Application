let userModal;

document.addEventListener('DOMContentLoaded', function() {
    userModal = new bootstrap.Modal(document.getElementById('userModal'));

    // Form validation
    const forms = document.querySelectorAll('.needs-validation');
    Array.from(forms).forEach(form => {
        form.addEventListener('submit', event => {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    });

    // Password toggle
    const togglePassword = document.querySelector('#togglePassword');
    const password = document.querySelector('#password');
    togglePassword.addEventListener('click', function() {
        const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
        password.setAttribute('type', type);
        this.classList.toggle('bi-eye');
        this.classList.toggle('bi-eye-slash');
    });
});

function openCreateModal() {
    document.getElementById('userForm').reset();
    document.getElementById('userId').value = '';
    document.getElementById('modalTitle').textContent = 'Add New User';
    document.getElementById('password').required = true;
    document.getElementById('passwordLabel').textContent = 'Password';
    document.getElementById('userForm').classList.remove('was-validated');
    userModal.show();
}

function openEditModal(id, username, email, firstName, lastName, role) {
    document.getElementById('userForm').reset();
    document.getElementById('userId').value = id;
    document.getElementById('username').value = username;
    document.getElementById('email').value = email;
    document.getElementById('firstName').value = firstName;
    document.getElementById('lastName').value = lastName;
    document.getElementById('role').value = role;
    document.getElementById('modalTitle').textContent = 'Edit User';
    document.getElementById('password').required = false;
    document.getElementById('passwordLabel').textContent = 'New Password (Optional)';
    document.getElementById('userForm').classList.remove('was-validated');
    userModal.show();
}

function saveUser() {
    const form = document.getElementById('userForm');
    if (!form.checkValidity()) {
        form.classList.add('was-validated');
        return;
    }

    const formData = new FormData(form);
    const userId = formData.get('id');
    const isEdit = userId && userId.trim() !== '';

    Swal.fire({
        title: 'Processing...',
        text: isEdit ? 'Updating user' : 'Creating new user',
        allowOutsideClick: false,
        didOpen: () => {
            Swal.showLoading();
        }
    });

    $.ajax({
        url: isEdit ? 'user?action=update' : 'user?action=create',
        type: 'POST',
        data: new URLSearchParams(formData).toString(),
        contentType: 'application/x-www-form-urlencoded'
    })
        .done(function(response) {
            userModal.hide();
            Swal.fire({
                icon: 'success',
                title: 'Success!',
                text: response,
                showConfirmButton: false,
                timer: 1500
            }).then(() => {
                window.location.href = 'dashboard.jsp';
            });
        })
        .fail(function(xhr) {
            Swal.fire({
                icon: 'error',
                title: 'Error!',
                text: xhr.responseText || 'An error occurred while processing your request',
                confirmButtonColor: '#2563EB'
            });
        });
}

function confirmDelete(userId, username) {
    Swal.fire({
        title: 'Are you sure?',
        text: `Do you want to delete user "${username}"? This action cannot be undone!`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#dc3545',
        cancelButtonColor: '#6c757d',
        confirmButtonText: 'Yes, delete it!',
        showLoaderOnConfirm: true,
        preConfirm: () => {
            return $.ajax({
                url: 'user?action=delete&id=' + userId,
                type: 'POST'
            })
                .then(response => {
                    return response;
                })
                .catch(error => {
                    Swal.showValidationMessage(error.responseText || 'Failed to delete user');
                    throw error;
                });
        },
        allowOutsideClick: () => !Swal.isLoading()
    }).then((result) => {
        if (result.isConfirmed) {
            Swal.fire({
                icon: 'success',
                title: 'Deleted!',
                text: 'User has been deleted.',
                showConfirmButton: false,
                timer: 1500
            }).then(() => {
                window.location.href = 'dashboard.jsp';
            });
        }
    });
}