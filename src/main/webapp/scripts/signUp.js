$(document).ready(function() {
    // Validation patterns
    const patterns = {
        firstName: /^[A-Za-z]{2,}$/,
        lastName: /^[A-Za-z]{2,}$/,
        email: /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/,
        username: /^[a-zA-Z0-9_]{4,20}$/,
        password: /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/
    };

    // Error messages
    const errorMessages = {
        firstName: 'First name must contain only letters and be at least 2 characters long',
        lastName: 'Last name must contain only letters and be at least 2 characters long',
        email: 'Please enter a valid email address',
        username: 'Username must be 4-20 characters and can only contain letters, numbers, and underscores',
        password: 'Password must be at least 8 characters long and include letters, numbers, and special characters',
        confirmPassword: 'Passwords do not match'
    };

    // Add error feedback divs after each input
    $('input').each(function() {
        const name = $(this).attr('name');
        if (errorMessages[name]) {
            $(this).after(`<div class="error-feedback" id="${name}-error">${errorMessages[name]}</div>`);
        }
    });

    // Real-time validation for all fields
    $('input').on('input', function() {
        const input = $(this);
        const field = input.attr('name');
        const value = input.val();

        if (field === 'confirmPassword') {
            validateConfirmPassword(input);
        } else if (patterns[field]) {
            validateField(input, patterns[field], errorMessages[field]);
        }
    });

    function validateField(input, pattern, errorMessage) {
        const value = input.val();
        const errorDiv = $(`#${input.attr('name')}-error`);

        if (value === '') {
            input.removeClass('is-valid is-invalid');
            errorDiv.hide();
        } else if (pattern.test(value)) {
            input.removeClass('is-invalid').addClass('is-valid');
            errorDiv.hide();
        } else {
            input.removeClass('is-valid').addClass('is-invalid');
            errorDiv.show();
        }
    }

    function validateConfirmPassword(input) {
        const password = $('input[name="password"]').val();
        const confirmPassword = input.val();
        const errorDiv = $('#confirmPassword-error');

        if (confirmPassword === '') {
            input.removeClass('is-valid is-invalid');
            errorDiv.hide();
        } else if (password === confirmPassword) {
            input.removeClass('is-invalid').addClass('is-valid');
            errorDiv.hide();
        } else {
            input.removeClass('is-valid').addClass('is-invalid');
            errorDiv.show();
        }
    }

    // Form submission with validation
    $('#registrationForm').on('submit', function(e) {
        e.preventDefault();

        // Check all validations
        let isValid = true;
        $('input').each(function() {
            const field = $(this).attr('name');
            if (field === 'confirmPassword') {
                validateConfirmPassword($(this));
            } else if (patterns[field]) {
                validateField($(this), patterns[field], errorMessages[field]);
            }
            if ($(this).hasClass('is-invalid')) {
                isValid = false;
            }
        });

        if (!isValid) {
            Swal.fire({
                title: 'Error!',
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

        // Ajax submission
        $.ajax({
            url: $(this).attr('action'),
            type: 'POST',
            data: $(this).serialize(),
            dataType: 'json',
            success: function(response) {
                if (response.status === 'success') {
                    Swal.fire({
                        title: 'Success!',
                        text: 'Registration successful! Redirecting to login...',
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
                    submitBtn.html(originalBtnText);
                }
            },
            error: function(xhr, status, error) {
                Swal.fire({
                    title: 'Error!',
                    text: 'Something went wrong. Please try again.',
                    icon: 'error',
                    confirmButtonText: 'OK'
                });
                submitBtn.prop('disabled', false);
                submitBtn.html(originalBtnText);
            }
        });
    });
});