<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Novoxia - Reset Password</title>
    <link rel="icon" type="image/x-icon" href="assets/a.svg">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.min.css" rel="stylesheet">
    <link rel="stylesheet" href="styles/forgotPassword.css">
</head>

<body>
<div class="app-container">
    <div class="window-controls">
        <div class="window-dot dot-red"></div>
        <div class="window-dot dot-yellow"></div>
        <div class="window-dot dot-green"></div>
    </div>

    <a href="index.jsp" class="brand-logo">
        <svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
            <img src="assets/a.svg" alt="logo" width="32" height="32">
        </svg>
        <span class="logo-text">Novoxia</span>
    </a>

    <div class="content">
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
                <a href="index.jsp" style="color: #2563EB; text-decoration: none; font-weight: 500;">Sign in</a>
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

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.all.min.js"></script>
<script src="scripts/resetPasswordScript.js"></script>

</body>
</html>