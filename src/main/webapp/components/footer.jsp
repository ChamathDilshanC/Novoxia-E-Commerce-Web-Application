<!-- Modern Animated Footer -->
<style>
    .minimal-footer {
        padding: 4rem 0 2rem 0;
        background-color: #ffffff;
        border-top: 1px solid #eee;
        position: relative;
        overflow: hidden;
        border-radius: 15px;
    }

    /* Animated background gradient */
    .minimal-footer::before {
        content: '';
        position: absolute;
        top: 0;
        left: -50%;
        width: 200%;
        height: 100%;
        background: linear-gradient(45deg,
        rgba(136, 51, 255, 0.03) 0%,
        rgba(255, 255, 255, 0) 50%,
        rgba(136, 51, 255, 0.03) 100%);
        animation: gradientMove 15s linear infinite;
        pointer-events: none;
    }

    @keyframes gradientMove {
        0% { transform: translateX(-30%); }
        100% { transform: translateX(30%); }
    }

    .footer-content {
        display: grid;
        grid-template-columns: 2fr 1fr 1fr 1fr;
        gap: 2rem;
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 1rem;
        position: relative;
    }

    .footer-brand {
        position: relative;
    }

    .footer-brand h4 {
        font-size: 1.5rem;
        font-weight: 600;
        margin-bottom: 1rem;
        background: linear-gradient(135deg, #8833ff, #ff33dd);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        transform-origin: left;
        transition: transform 0.3s ease;
    }

    .footer-brand h4:hover {
        transform: scale(1.05);
    }

    .footer-brand p {
        color: #666;
        font-size: 0.95rem;
        line-height: 1.6;
        margin-top: 1rem;
        opacity: 0.9;
        transition: opacity 0.3s ease;
    }

    .footer-brand:hover p {
        opacity: 1;
    }

    .footer-section h4 {
        color: #000;
        font-size: 1.1rem;
        font-weight: 600;
        margin-bottom: 1rem;
        position: relative;
        padding-bottom: 0.5rem;
    }

    .footer-section h4::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        width: 30px;
        height: 2px;
        background: #8833ff;
        transition: width 0.3s ease;
    }

    .footer-section:hover h4::after {
        width: 50px;
    }

    .footer-links {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .footer-links li {
        margin-bottom: 0.8rem;
        transform: translateX(0);
        transition: transform 0.3s ease;
    }

    .footer-links a {
        color: #666;
        text-decoration: none;
        font-size: 0.8rem;
        transition: all 0.3s ease;
        display: inline-block;
        position: relative;
        padding: 2px 0;
    }

    .footer-links a::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        width: 0;
        height: 1px;
        background: #8833ff;
        transition: width 0.3s ease;
    }

    .footer-links a:hover {
        color: #8833ff;
        transform: translateX(5px);
    }

    .footer-links a:hover::after {
        width: 100%;
    }

    .footer-bottom {
        max-width: 1200px;
        margin: 0 auto;
        padding: 2rem 1rem 0 1rem;
        border-top: 1px solid #eee;
        margin-top: 3rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
        color: #666;
        font-size: 0.9rem;
    }

    .footer-social {
        display: flex;
        gap: 1.5rem;
    }

    .footer-social a {
        color: #666;
        text-decoration: none;
        transition: all 0.3s ease;
        position: relative;
        display: flex;
        align-items: center;
        justify-content: center;
        width: 35px;
        height: 35px;
        border-radius: 50%;
        background: transparent;
        overflow: hidden;
    }

    .footer-social a::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: linear-gradient(45deg, #8833ff, #ff33dd);
        opacity: 0;
        transform: scale(0);
        transition: all 0.3s ease;
        border-radius: 50%;
    }

    .footer-social a:hover {
        color: white;
        transform: translateY(-3px);
    }

    .footer-social a:hover::before {
        opacity: 1;
        transform: scale(1);
    }

    .footer-social i {
        position: relative;
        z-index: 1;
        transition: transform 0.3s ease;
    }

    .footer-social a:hover i {
        transform: scale(1.1);
    }

    .footer-legal {
        display: flex;
        gap: 1.5rem;
    }

    .footer-legal a {
        color: #666;
        text-decoration: none;
        transition: all 0.3s ease;
        position: relative;
        padding: 2px 0;
    }

    .footer-legal a::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        width: 0;
        height: 1px;
        background: #8833ff;
        transition: width 0.3s ease;
    }

    .footer-legal a:hover {
        color: #8833ff;
    }

    .footer-legal a:hover::after {
        width: 100%;
    }

    /* Added animations for initial load */
    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .footer-section {
        animation: fadeInUp 0.6s ease forwards;
        opacity: 0;
    }

    .footer-section:nth-child(1) { animation-delay: 0.1s; }
    .footer-section:nth-child(2) { animation-delay: 0.2s; }
    .footer-section:nth-child(3) { animation-delay: 0.3s; }
    .footer-section:nth-child(4) { animation-delay: 0.4s; }

    .footer-bottom {
        animation: fadeInUp 0.6s ease forwards 0.5s;
        opacity: 0;
    }

    /* Responsive Design */
    @media (max-width: 768px) {
        .footer-content {
            grid-template-columns: repeat(2, 1fr);
        }

        .footer-brand {
            grid-column: 1 / -1;
        }

        .footer-bottom {
            flex-direction: column;
            gap: 1.5rem;
            text-align: center;
        }

        .footer-social {
            justify-content: center;
        }

        .footer-legal {
            flex-direction: column;
            align-items: center;
            gap: 1rem;
        }
    }

    @media (max-width: 480px) {
        .footer-content {
            grid-template-columns: 1fr;
        }

        .footer-section {
            text-align: center;
        }

        .footer-section h4::after {
            left: 50%;
            transform: translateX(-50%);
        }

        .footer-social {
            flex-wrap: wrap;
            justify-content: center;
        }
    }
</style>

<!-- Rest of the footer HTML remains the same as previous version -->
<footer class="minimal-footer">
    <div class="footer-content">
        <!-- Brand Section -->
        <div class="footer-brand">
            <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                <img src="${pageContext.request.contextPath}/assets/a.svg" alt="logo" width="32" height="32">
            </svg>
            <h4>Novoxia</h4>
            <p>UI & UX Designer and Developer passionate about creating meaningful and delightful digital experiences.</p>
        </div>

        <!-- Quick Links -->
        <div class="footer-section">
            <h4>Quick Links</h4>
            <ul class="footer-links">
                <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/about">About</a></li>
                <li><a href="${pageContext.request.contextPath}/services">Services</a></li>
                <li><a href="${pageContext.request.contextPath}/projects">Projects</a></li>
            </ul>
        </div>

        <!-- Services -->
        <div class="footer-section">
            <h4>Services</h4>
            <ul class="footer-links">
                <li><a href="#">Product Branding</a></li>
                <li><a href="#">Product Selling</a></li>
                <li><a href="#">Product Buying</a></li>
                <li><a href="#">Customer Delivery</a></li>
            </ul>
        </div>

        <!-- Contact -->
        <div class="footer-section">
            <h4>Contact</h4>
            <ul class="footer-links">
                <li>Colombo, Sri Lanka</li>
                <li><a href="mailto:contact@novoxia.com">contact@novoxia.com</a></li>
                <li><a href="tel:+94775616104">+94 775 - 616 - 104</a></li>
            </ul>
        </div>
    </div>

    <!-- Footer Bottom -->
    <div class="footer-bottom">
        <div class="footer-legal">
            <a href="#">Privacy Policy</a>
            <a href="#">Terms of Service</a>
            <span>&copy; ${LocalDateTime.now().getYear()} Novoxia. All rights reserved.</span>
        </div>

        <div class="footer-social">
            <a href="#" target="_blank" rel="noopener">
                <i class="bi bi-linkedin"></i>
            </a>
            <a href="#" target="_blank" rel="noopener">
                <i class="bi bi-github"></i>
            </a>
            <a href="#" target="_blank" rel="noopener">
                <i class="bi bi-facebook"></i>
            </a>
            <a href="#" target="_blank" rel="noopener">
                <i class="bi bi-instagram"></i>
            </a>
        </div>
    </div>
</footer>