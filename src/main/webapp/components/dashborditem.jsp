<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Expires", "0");

    // Session check
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    String username = (String) session.getAttribute("username");
    String firstName = (String) session.getAttribute("firstName");
    String lastName = (String) session.getAttribute("lastName");
    String email = (String) session.getAttribute("email");
    String role = (String) session.getAttribute("role");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Novoxia - Dashboard</title>
    <link rel="icon" type="image/x-icon" href="../assets/a.svg">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<style>
    body {
        background-color: #f8f9fa;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
        padding: 1rem 2rem 0 2rem;
    }
    .image-container-wrapper {
        margin-top: 1rem;
        margin-bottom: 2rem;
        padding: 0rem 15rem;
    }

    .image-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        grid-gap: 1.5rem;
    }

    .image-item {
        position: relative;
        overflow: hidden;
        border-radius: 0.5rem;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    .image-item img {
        width: 100%;
        height: auto;
        object-fit: cover;
        transition: transform 0.3s ease;
    }

    .image-item:hover img {
        transform: scale(1.05);
    }

    .image-overlay {
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        background-color: rgba(0, 0, 0, 0.7);
        padding: 1.5rem;
        color: #fff;
        text-align: center;
        opacity: 0;
        transition: opacity 0.3s ease;
    }

    .image-item:hover .image-overlay {
        opacity: 1;
    }

    .image-overlay h3 {
        font-size: 1.5rem;
        font-weight: 600;
        margin-bottom: 0.5rem;
    }

    .image-overlay p {
        font-size: 1rem;
    }

    .image-overlay a {
        display: inline-block;
        margin-top: 1rem;
        background-color: #fff;
        color: #000;
        padding: 0.5rem 1rem;
        border-radius: 9999px;
        font-weight: 600;
        text-decoration: none;
        transition: background-color 0.3s ease;
    }

    .image-overlay a:hover {
        background-color: #f1f1f1;
    }
</style>

<body>
<div class="image-container-wrapper">
    <div class="image-grid">
        <div class="image-item">
            <img src="assets/img_1.png" alt="Product 1" class="w-full h-auto object-cover rounded-lg shadow-md">
            <div class="image-overlay">
                <h3 class="text-xl font-semibold text-white mb-2">New Arrivals</h3>
                <p class="text-sm text-white">Check out our latest collection</p>
                <a href="#" class="mt-4 inline-block bg-white text-black py-2 px-4 rounded-full font-semibold hover:bg-gray-200 transition duration-300">Shop Now</a>
            </div>
        </div>

        <div class="image-item">
            <img src="assets/img_2.png" alt="Product 2" class="w-full h-auto object-cover rounded-lg shadow-md">
            <div class="image-overlay">
                <h3 class="text-xl font-semibold text-white mb-2">Summer Sale</h3>
                <p class="text-sm text-white">Up to 50% off select items</p>
                <a href="#" class="mt-4 inline-block bg-white text-black py-2 px-4 rounded-full font-semibold hover:bg-gray-200 transition duration-300">Shop Sale</a>
            </div>
        </div>

        <div class="image-item">
            <img src="assets/img_3.png" alt="Product 3" class="w-full h-auto object-cover rounded-lg shadow-md">
            <div class="image-overlay">
                <h3 class="text-xl font-semibold text-white mb-2">Trending Now</h3>
                <p class="text-sm text-white">Discover the hottest styles</p>
                <a href="#" class="mt-4 inline-block bg-white text-black py-2 px-4 rounded-full font-semibold hover:bg-gray-200 transition duration-300">Explore Trends</a>
            </div>
        </div>
    </div>
</div>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.all.min.js"></script>
</body>
</html>