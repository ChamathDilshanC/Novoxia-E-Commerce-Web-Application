$(document).ready(function() {
    // Validation patterns
    const patterns = {
        username: /^[a-zA-Z0-9_]{4,20}$/,
        email: /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/,
        newPassword: /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/
    };

    // Error messages
    const errorMessages = {
        username: "Username must be 4-20 characters and can only contain letters, numbers, and underscores",
        email: "Please include an '@' in the email address",
        newPassword: "Password must include letters, numbers, and special characters",
        confirmPassword: "Passwords do not match"
    };

    function showError(input, message) {
        const errorDiv = $(`#${input.attr('name')}-error`);
        input.removeClass('is-valid').addClass('is-invalid');
        errorDiv.html(`<span class="alert-circle">!</span>${message}`).addClass('show');
    }

    function showSuccess(input) {
        const errorDiv = $(`#${input.attr('name')}-error`);
        input.removeClass('is-invalid').addClass('is-valid');
        errorDiv.removeClass('show');
    }

    // Real-time validation
    $('input').on('input', function() {
        const input = $(this);
        const value = input.val().trim();
        const field = input.attr('name');

        if (value === '') {
            input.removeClass('is-valid is-invalid');
            $(`#${field}-error`).removeClass('show');
            if (field === 'newPassword') {
                $('.password-strength').hide();
            }
            return;
        }

        if (field === 'confirmPassword') {
            validateConfirmPassword();
        } else {
            validateField(input);
        }

        if (field === 'newPassword') {
            updatePasswordStrength(value);
            if ($('input[name="confirmPassword"]').val()) {
                validateConfirmPassword();
            }
        }
    });

    function validateField(input) {
        const field = input.attr('name');
        const value = input.val().trim();
        const pattern = patterns[field];

        if (!pattern) return;

        if (field === 'email' && !value.includes('@')) {
            showError(input, "Please include an '@' in the email address");
            return false;
        }

        if (!pattern.test(value)) {
            showError(input, errorMessages[field]);
            return false;
        }

        showSuccess(input);
        return true;
    }

    function validateConfirmPassword() {
        const confirmInput = $('input[name="confirmPassword"]');
        const password = $('input[name="newPassword"]').val();
        const confirmValue = confirmInput.val();

        if (!confirmValue) {
            confirmInput.removeClass('is-valid is-invalid');
            $('#confirmPassword-error').removeClass('show');
            return false;
        }

        if (password !== confirmValue) {
            showError(confirmInput, "Passwords do not match");
            return false;
        }

        showSuccess(confirmInput);
        return true;
    }

    function updatePasswordStrength(password) {
        let strength = 0;

        if (password.length >= 8) strength++;
        if (/[A-Z]/.test(password)) strength++;
        if (/[0-9]/.test(password)) strength++;
        if (/[^A-Za-z0-9]/.test(password)) strength++;

        const strengthTexts = ['Weak', 'Fair', 'Good', 'Strong'];
        const strengthColors = ['#dc3545', '#ffc107', '#198754', '#0dcaf0'];

        $('.password-strength')
            .show()
            .html(`Password Strength: <span style="color: ${strengthColors[strength - 1]}">${strengthTexts[strength - 1] || 'Very Weak'}</span>`);
    }

    // Form submission
    $('#resetPasswordForm').on('submit', function(e) {
        e.preventDefault();

        let isValid = true;
        $('input').each(function() {
            const input = $(this);
            if (!input.val().trim()) {
                showError(input, `${input.prev('label').text().replace(' *', '')} is required`);
                isValid = false;
            } else if (input.attr('name') === 'confirmPassword') {
                isValid = validateConfirmPassword() && isValid;
            } else {
                isValid = validateField(input) && isValid;
            }
        });

        if (!isValid) {
            Swal.fire({
                title: 'Error!',
                text: 'Please fix all errors before submitting',
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
                        window.location.href = '../index.jsp';
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