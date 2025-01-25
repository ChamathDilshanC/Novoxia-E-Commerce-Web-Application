<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Novoxia - Login</title>
    <link rel="icon" type="image/x-icon" href="assets/a.svg">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.min.css" rel="stylesheet">
    <link rel="stylesheet" href="styles/loginStyles.css">
</head>

<body>
<div class="app-container">
    <div class="window-controls">
        <div class="window-dot dot-red"></div>
        <div class="window-dot dot-yellow"></div>
        <div class="window-dot dot-green"></div>
    </div>

    <a href="#" class="brand-logo">
        <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
            <img src="assets/a.svg" alt="logo" width="32" height="32">
        </svg>
        <span class="logo-text">Novoxia</span>
    </a>

    <div class="content">
        <div class="steps-container">
            <div class="step-item step-active">
                <div class="step-circle">1</div>
                <div class="step-content">
                    <div class="step-title">Login</div>
                    <div class="step-description">Enter your credentials</div>
                </div>
            </div>
            <div class="step-item">
                <div class="step-circle">2</div>
                <div class="step-content">
                    <div class="step-title">Authentication</div>
                    <div class="step-description">Verify identity</div>
                </div>
            </div>
            <div class="step-item">
                <div class="step-circle">3</div>
                <div class="step-content">
                    <div class="step-title">Success</div>
                    <div class="step-description">Ready to shop</div>
                </div>
            </div>
        </div>

        <div class="form-container">
            <div class="form-header">
                <h1 class="form-title">Welcome back</h1>
                <p class="form-subtitle">Enter your credentials to continue</p>
            </div>

            <form id="loginForm" action="<%=request.getContextPath()%>/login" method="post">
                <div class="input-group">
                    <div>
                        <label class="input-label required">Username or Email</label><br>
                        <input type="text" name="username" class="form-input" placeholder="Enter your username or email" required>
                    </div>
                    <div>
                        <div class="d-flex justify-content-between align-items-center">
                            <label class="input-label required">Password</label>
                            <a href="forgotPassword.jsp" style="font-size: 14px; color: #2563EB; text-decoration: none;">Forgot password?</a>
                        </div><br>
                        <input type="password" name="password" class="form-input" placeholder="••••••••" required>
                    </div>

                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="rememberMe" name="rememberMe">
                        <label class="form-check-label" for="rememberMe">Remember me</label>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary w-100 mt-4" id="loginBtn">Sign in</button>

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
<script src="scripts/loginScripts.js"></script>
</body>
</html>