$(document).ready(function() {
    // Real-time validation
    $('input[name="firstName"], input[name="lastName"]').on('input', function() {
        const name = $(this).val().trim();
        const isValid = /^[a-zA-Z\s]{2,50}$/.test(name);
        toggleErrorState($(this), isValid, '2-50 letters only');
    });

    $('input[name="email"]').on('input', function() {
        const email = $(this).val().trim();
        const isValid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
        toggleErrorState($(this), isValid, 'Invalid email format');
    });

    $('input[name="username"]').on('input', function() {
        const username = $(this).val().trim();
        const isValid = /^[a-zA-Z0-9_]{4,20}$/.test(username);
        toggleErrorState($(this), isValid, '4-20 chars (letters, numbers, _)');
    });

    $('input[name="password"]').on('input', function() {
        const password = $(this).val();
        const isValid = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$/.test(password);
        toggleErrorState($(this), isValid, '8+ chars with uppercase and number');
        updatePasswordStrength(password);
    });

    $('input[name="confirmPassword"]').on('input', function() {
        const confirm = $(this).val();
        const password = $('input[name="password"]').val();
        const isValid = confirm === password;
        toggleErrorState($(this), isValid, 'Passwords must match');
    });

    function toggleErrorState(input, isValid, message) {
        const parent = input.closest('.col-md-6, div');
        const feedback = parent.find('.invalid-feedback');

        if (!isValid && input.val().trim() !== '') {
            input.addClass('is-invalid').removeClass('is-valid');
            if (feedback.length === 0) {
                parent.append(`<div class="invalid-feedback">${message}</div>`);
            }
        } else {
            input.removeClass('is-invalid');
            if (input.val().trim() === '') {
                input.removeClass('is-valid');
            } else {
                input.addClass('is-valid');
            }
            feedback.remove();
        }
    }

    $('#registrationForm').on('submit', function(e) {
        e.preventDefault();
        let isValid = true;

        // Trigger validation for all fields
        $('input').each(function() {
            $(this).trigger('input');
            if ($(this).hasClass('is-invalid')) isValid = false;
        });

        if (!isValid) {
            Swal.fire({
                title: 'Validation Error',
                text: 'Please fix the errors in the form',
                icon: 'error',
                confirmButtonText: 'OK'
            });
            return;
        }

        // Show loading state
        const submitBtn = $('#submitBtn');
        const originalBtnText = submitBtn.html();
        submitBtn.prop('disabled', true);
        submitBtn.html('<span class="spinner-border spinner-border-sm"></span>Creating Account...');

        $.ajax({
            url: $(this).attr('action'),
            type: 'POST',
            data: $(this).serialize(),
            dataType: 'json',
            success: function(response) {
                if (response.status === 'success') {
                    Swal.fire({
                        title: 'Success!',
                        text: response.message,
                        icon: 'success',
                        timer: 2000,
                        showConfirmButton: false
                    }).then(() => {
                        window.location.href = 'index.jsp';
                    });
                } else {
                    if (response.errors) {
                        // Handle field-specific errors
                        Object.keys(response.errors).forEach(field => {
                            const input = $(`[name="${field}"]`);
                            const parent = input.closest('.col-md-6, div');
                            input.addClass('is-invalid');
                            parent.append(`<div class="invalid-feedback">${response.errors[field]}</div>`);
                        });

                        if (response.errors.general) {
                            Swal.fire({
                                title: 'Error!',
                                text: response.errors.general,
                                icon: 'error',
                                confirmButtonText: 'OK'
                            });
                        }
                    } else {
                        Swal.fire({
                            title: 'Error!',
                            text: response.message,
                            icon: 'error',
                            confirmButtonText: 'OK'
                        });
                    }
                    submitBtn.prop('disabled', false);
                    submitBtn.html(originalBtnText);
                }
            },
            error: function(xhr) {
                Swal.fire({
                    title: 'Error!',
                    text: xhr.responseJSON?.message || 'Something went wrong',
                    icon: 'error',
                    confirmButtonText: 'OK'
                });
                submitBtn.prop('disabled', false);
                submitBtn.html(originalBtnText);
            }
        });
    });

    function updatePasswordStrength(password) {
        let strength = 0;
        if (password.length >= 8) strength++;
        if (/[A-Z]/.test(password)) strength++;
        if (/[0-9]/.test(password)) strength++;
        if (/[^A-Za-z0-9]/.test(password)) strength++;

        const strengthTexts = ['Weak', 'Fair', 'Good', 'Strong'];
        const strengthColors = ['#dc3545', '#ffc107', '#28a745', '#17a2b8'];

        $('.password-strength').html(strength > 0 ?
            `<span style="color: ${strengthColors[strength-1]}">${strengthTexts[strength-1]}</span>` :
            ''
        );
    }
});