$(document).ready(function() {
    // Validation patterns
    const patterns = {
        username: /^[a-zA-Z0-9_]{4,20}$/,
        email: /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/,
        password: /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/
    };

    // Real-time validation
    $('input').on('input', function() {
        const input = $(this);
        const inputName = input.attr('name');
        const value = input.val();

        if (inputName === 'username' || inputName === 'email' || inputName === 'newPassword') {
            validateField(input, patterns[inputName === 'newPassword' ? 'password' : inputName]);
        } else if (inputName === 'confirmPassword') {
            validateConfirmPassword();
        }
    });

    function validateField(input, pattern) {
        const value = input.val();
        const errorDiv = $(`#${input.attr('name')}-error`);

        if (value === '') {
            input.removeClass('is-valid is-invalid');
            errorDiv.hide();
            return false;
        }

        if (pattern.test(value)) {
            input.removeClass('is-invalid').addClass('is-valid');
            errorDiv.hide();
            return true;
        } else {
            input.removeClass('is-valid').addClass('is-invalid');
            errorDiv.show();
            return false;
        }
    }

    function validateConfirmPassword() {
        const password = $('input[name="newPassword"]').val();
        const confirmPassword = $('input[name="confirmPassword"]');
        const confirmValue = confirmPassword.val();
        const errorDiv = $('#confirmPassword-error');

        if (confirmValue === '') {
            confirmPassword.removeClass('is-valid is-invalid');
            errorDiv.hide();
            return false;
        }

        if (password === confirmValue) {
            confirmPassword.removeClass('is-invalid').addClass('is-valid');
            errorDiv.hide();
            return true;
        } else {
            confirmPassword.removeClass('is-valid').addClass('is-invalid');
            errorDiv.show();
            return false;
        }
    }

    // Password strength indicator
    $('input[name="newPassword"]').on('input', function() {
        const password = $(this).val();
        let strength = 0;

        if (password.length >= 8) strength++;
        if (password.match(/[A-Z]/)) strength++;
        if (password.match(/[0-9]/)) strength++;
        if (password.match(/[^A-Za-z0-9]/)) strength++;

        const strengthTexts = ['Weak', 'Fair', 'Good', 'Excellent'];
        const strengthColors = ['#dc3545', '#ffc107', '#198754', '#0dcaf0'];

        if (password.length > 0) {
            $('.password-strength').html(`Password Strength: <span style="color: ${strengthColors[strength - 1]}">${strengthTexts[strength - 1] || 'Very Weak'}</span>`);
        } else {
            $('.password-strength').html('');
        }
    });

    // Form submission
    $('#resetPasswordForm').on('submit', function(e) {
        e.preventDefault();

        // Validate all fields
        let isValid = true;
        isValid = validateField($('input[name="username"]'), patterns.username) && isValid;
        isValid = validateField($('input[name="email"]'), patterns.email) && isValid;
        isValid = validateField($('input[name="newPassword"]'), patterns.password) && isValid;
        isValid = validateConfirmPassword() && isValid;

        if (!isValid) {
            Swal.fire({
                title: 'Error!',
                text: 'Please fix the errors in the form',
                icon: 'error',
                confirmButtonText: 'OK'
            });
            return;
        }

        const submitBtn = $('#submitBtn');
        submitBtn.prop('disabled', true);
        submitBtn.html('<span class="spinner-border spinner-border-sm"></span>Resetting Password...');

        $.ajax({
            url: $(this).attr('action'),
            type: 'POST',
            data: $(this).serialize(),
            dataType: 'json',
            success: function(response) {
                if (response.status === 'success') {
                    Swal.fire({
                        title: 'Success!',
                        text: 'Password reset successful! Redirecting to login...',
                        icon: 'success',
                        timer: 2000,
                        showConfirmButton: false
                    }).then(() => {
                        window.location.href = 'index.jsp';
                    });
                } else {
                    Swal.fire({
                        title: 'Error!',
                        text: response.message,
                        icon: 'error',
                        confirmButtonText: 'OK'
                    });
                    submitBtn.prop('disabled', false);
                    submitBtn.html('Reset Password');
                }
            },
            error: function() {
                Swal.fire({
                    title: 'Error!',
                    text: 'Something went wrong. Please try again.',
                    icon: 'error',
                    confirmButtonText: 'OK'
                });
                submitBtn.prop('disabled', false);
                submitBtn.html('Reset Password');
            }
        });
    });
});