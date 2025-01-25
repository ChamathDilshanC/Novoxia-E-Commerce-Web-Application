<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Novoxia - Reset Password</title>
    <link rel="icon" type="image/x-icon" href="../assets/a.svg">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../styles/forgotPassword.css">
    <style>
        .form-input.is-invalid {
            border-color: #dc3545;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 12 12' width='12' height='12' fill='none' stroke='%23dc3545'%3e%3ccircle cx='6' cy='6' r='4.5'/%3e%3cpath stroke-linejoin='round' d='M5.8 3.6h.4L6 6.5z'/%3e%3ccircle cx='6' cy='8.2' r='.6' fill='%23dc3545' stroke='none'/%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right calc(0.375em + 0.1875rem) center;
            background-size: calc(0.75em + 0.375rem) calc(0.75em + 0.375rem);
        }

        .form-input.is-valid {
            border-color: #198754;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 8 8'%3e%3cpath fill='%23198754' d='M2.3 6.73L.6 4.53c-.4-1.04.46-1.4 1.1-.8l1.1 1.4 3.4-3.8c.6-.63 1.6-.27 1.2.7l-4 4.6c-.43.5-.8.4-1.1.1z'/%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right calc(0.375em + 0.1875rem) center;
            background-size: calc(0.75em + 0.375rem) calc(0.75em + 0.375rem);
        }

        .error-feedback {
            display: none;
            width: 100%;
            margin-top: 0.25rem;
            font-size: 0.875em;
            color: #dc3545;
        }

        .password-strength {
            margin-top: 0.25rem;
            font-size: 0.875rem;
        }

        .required:after {
            content: " *";
            color: red;
        }

        .spinner-border {
            width: 1rem;
            height: 1rem;
            margin-right: 0.5rem;
        }
    </style>
</head>
<body>
<div class="app-container">
    <!-- Window Controls -->
    <div class="window-controls">
        <div class="window-dot dot-red"></div>
        <div class="window-dot dot-yellow"></div>
        <div class="window-dot dot-green"></div>
    </div>

    <!-- Brand Logo -->
    <a href="../index.jsp" class="brand-logo">
        <svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
            <img src="../assets/a.svg" alt="logo" width="32" height="32">
        </svg>
        <span class="logo-text">Novoxia</span>
    </a>

    <div class="content">
        <!-- Steps -->
        <div class="steps-container">
            <div class="steps-group">
                <div class="step-item step-active">
                    <div class="step-circle">1</div>
                    <div class="step-content">
                        <div class="step-title">Verify Account</div>
                        <div class="step-description">Confirm identity</div>
                    </div>
                </div>
                <div class="step-item">
                    <div class="step-circle">2</div>
                    <div class="step-content">
                        <div class="step-title">New Password</div>
                        <div class="step-description">Create password</div>
                    </div>
                </div>
                <div class="step-item">
                    <div class="step-circle">3</div>
                    <div class="step-content">
                        <div class="step-title">Complete</div>
                        <div class="step-description">Password updated</div>
                    </div>
                </div>
            </div>
            <div class="signin-link" style="font-size: 14px; color: #6B7280;">
                Remember your password?
                <a href="../index.jsp" style="color: #2563EB; text-decoration: none; font-weight: 500;">Sign in</a>
            </div>
        </div>

        <!-- Form -->
        <div class="form-container">
            <div class="form-header">
                <h1 class="form-title">Reset Password</h1>
                <p class="form-subtitle">Enter your account details and new password</p>
            </div>

            <form id="resetPasswordForm" action="<%=request.getContextPath()%>/resetPassword" method="post">
                <div class="input-group">
                    <div>
                        <label class="input-label required">Username</label>
                        <input type="text" name="username" class="form-input" placeholder="Enter your username" required>
                        <div class="error-feedback" id="username-error">Username must be at least 4 characters</div>
                    </div>

                    <div>
                        <label class="input-label required">Email address</label>
                        <input type="email" name="email" class="form-input" placeholder="Enter your email address" required>
                        <div class="error-feedback" id="email-error">Please enter a valid email address</div>
                    </div>

                    <div>
                        <label class="input-label required">New Password</label>
                        <input type="password" name="newPassword" class="form-input" placeholder="Enter new password" required>
                        <div class="error-feedback" id="newPassword-error">Password must meet the requirements</div>
                        <div class="password-strength"></div>
                    </div>

                    <div>
                        <label class="input-label required">Confirm Password</label>
                        <input type="password" name="confirmPassword" class="form-input" placeholder="Confirm new password" required>
                        <div class="error-feedback" id="confirmPassword-error">Passwords must match</div>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary w-100 mt-4" id="submitBtn">Reset Password</button>

                <div class="text-center mt-4" style="font-size: 14px; color: #6B7280;">
                    Don't have an account?
                    <a href="signUp.jsp" style="color: #2563EB; text-decoration: none; font-weight: 500;">Sign up</a>
                </div>
            </form>
        </div>
    </div>

    <!-- Footer -->
    <div class="footer">
        <span>© Novoxia @ Copy Right Reserved</span>
        <span>help@novoxia.com</span>
        <div class="dots">
            <div class="dot active"></div>
            <div class="dot"></div>
            <div class="dot"></div>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.all.min.js"></script>

<script>
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
</script>

</body>
</html>