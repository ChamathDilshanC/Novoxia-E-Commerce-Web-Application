package lk.ijse.servlets;

import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lk.ijse.config.FactoryConfiguration;
import lk.ijse.entity.Cart;
import lk.ijse.entity.Product;
import lk.ijse.entity.User;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart/*"})
public class CartServlet extends HttpServlet {

    private void updateCartCount(HttpSession httpSession, Session session, Integer userId) {
        try {
            Long cartCount = session.createQuery(
                            "SELECT COALESCE(SUM(c.quantity), 0) FROM Cart c WHERE c.user.id = :userId",
                            Long.class)
                    .setParameter("userId", userId)
                    .uniqueResult();

            httpSession.setAttribute("cartCount", cartCount.intValue());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession httpSession = request.getSession(false);
        if (httpSession == null || httpSession.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try (Session session = FactoryConfiguration.getInstance().getSession()) {
            Integer userId = (Integer) httpSession.getAttribute("userId");

            // Update cart count when viewing cart
            updateCartCount(httpSession, session, userId);

            List<Cart> cartItems = session.createQuery(
                            "FROM Cart c LEFT JOIN FETCH c.product WHERE c.user.id = :userId",
                            Cart.class)
                    .setParameter("userId", userId)
                    .list();

            request.setAttribute("cartItems", cartItems);
            request.getRequestDispatcher("/cart.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error loading cart items");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String pathInfo = request.getPathInfo();
        System.out.println("PathInfo: " + pathInfo); // Debug log

        try {
            if ("/add".equals(pathInfo)) {
                handleAddToCart(request, response);
            } else if ("/update".equals(pathInfo)) {
                handleUpdateCart(request, response);
            } else if ("/remove".equals(pathInfo)) {
                handleRemoveFromCart(request, response);
            } else {
                throw new ServletException("Invalid path: " + pathInfo);
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log the full stack trace
            sendErrorResponse(response, "Server error: " + e.getMessage());
        }
    }

    private void handleAddToCart(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // Set response type immediately
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession httpSession = request.getSession(false);
        Session hibernateSession = null;
        Transaction transaction = null;

        try {
            // Validate login state
            if (httpSession == null || httpSession.getAttribute("userId") == null) {
                sendErrorResponse(response, "Please login to add items to cart",
                        HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }

            // Get required parameters
            Integer userId = (Integer) httpSession.getAttribute("userId");
            Integer productId;
            Integer quantity;

            try {
                productId = Integer.parseInt(request.getParameter("productId"));
                quantity = Integer.parseInt(request.getParameter("quantity"));

                if (productId == null || quantity == null || quantity <= 0) {
                    throw new IllegalArgumentException("Invalid product ID or quantity");
                }
            } catch (NumberFormatException e) {
                sendErrorResponse(response, "Invalid parameters");
                return;
            }

            // Start database transaction
            hibernateSession = FactoryConfiguration.getInstance().getSession();
            transaction = hibernateSession.beginTransaction();

            // Get product and validate stock
            Product product = hibernateSession.get(Product.class, productId);
            if (product == null) {
                sendErrorResponse(response, "Product not found");
                return;
            }

            if (product.getStock() < quantity) {
                sendErrorResponse(response, "Not enough stock available");
                return;
            }

            // Get or create cart item
            Cart existingItem = hibernateSession.createQuery(
                            "FROM Cart c WHERE c.user.id = :userId AND c.product.id = :productId",
                            Cart.class)
                    .setParameter("userId", userId)
                    .setParameter("productId", productId)
                    .uniqueResult();

            if (existingItem != null) {
                // Update existing cart item
                int newQuantity = existingItem.getQuantity() + quantity;
                if (product.getStock() < newQuantity) {
                    sendErrorResponse(response, "Not enough stock available for requested quantity");
                    return;
                }
                existingItem.setQuantity(newQuantity);
                hibernateSession.merge(existingItem);
            } else {
                // Create new cart item
                Cart cartItem = new Cart();
                User user = hibernateSession.get(User.class, userId);
                if (user == null) {
                    sendErrorResponse(response, "User not found");
                    return;
                }
                cartItem.setUser(user);
                cartItem.setProduct(product);
                cartItem.setQuantity(quantity);
                cartItem.setCreatedAt(LocalDateTime.now());
                hibernateSession.persist(cartItem);
            }

            // Commit transaction
            transaction.commit();

            // Update cart count in session
            Long cartCount = hibernateSession.createQuery(
                            "SELECT COALESCE(SUM(c.quantity), 0) FROM Cart c WHERE c.user.id = :userId",
                            Long.class)
                    .setParameter("userId", userId)
                    .uniqueResult();

            httpSession.setAttribute("cartCount", cartCount.intValue());

            // Send success response
            JsonObject json = new JsonObject();
            json.addProperty("success", true);
            json.addProperty("message", "Product added to cart successfully");
            json.addProperty("cartCount", cartCount.intValue());

            response.getWriter().write(json.toString());

        } catch (Exception e) {
            // Log the error
            e.printStackTrace();

            // Rollback transaction if active
            if (transaction != null && transaction.isActive()) {
                try {
                    transaction.rollback();
                } catch (Exception rollbackException) {
                    rollbackException.printStackTrace();
                }
            }

            // Send error response
            sendErrorResponse(response, "Failed to add product to cart: " + e.getMessage());
        } finally {
            // Clean up hibernate session
            if (hibernateSession != null && hibernateSession.isOpen()) {
                try {
                    hibernateSession.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        sendErrorResponse(response, message, HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }

    private void handleUpdateCart(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession httpSession = request.getSession(false);
        if (httpSession == null || httpSession.getAttribute("userId") == null) {
            sendErrorResponse(response, "Please login to update cart",
                    HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        Integer userId = (Integer) httpSession.getAttribute("userId");
        Integer cartId = Integer.parseInt(request.getParameter("cartId"));
        Integer quantity = Integer.parseInt(request.getParameter("quantity"));

        try (Session session = FactoryConfiguration.getInstance().getSession()) {
            Transaction transaction = session.beginTransaction();

            try {
                Cart cartItem = session.get(Cart.class, cartId);
                if (cartItem == null) {
                    throw new Exception("Cart item not found");
                }

                if (!cartItem.getUser().getId().equals(userId)) {
                    throw new Exception("Unauthorized access to cart item");
                }

                if (cartItem.getProduct().getStock() < quantity) {
                    throw new Exception("Not enough stock available");
                }

                if (quantity <= 0) {
                    session.remove(cartItem);
                } else {
                    cartItem.setQuantity(quantity);
                    session.merge(cartItem);
                }

                transaction.commit();

                // Update cart count after successful update
                updateCartCount(httpSession, session, userId);

                Integer updatedCount = (Integer) httpSession.getAttribute("cartCount");
                JsonObject json = new JsonObject();
                json.addProperty("success", true);
                json.addProperty("message", "Cart updated successfully");
                json.addProperty("cartCount", updatedCount);

                response.setContentType("application/json");
                response.getWriter().write(json.toString());

            } catch (Exception e) {
                if (transaction != null && transaction.isActive()) {
                    transaction.rollback();
                }
                throw e;
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, e.getMessage());
        }
    }

    private void handleRemoveFromCart(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession httpSession = request.getSession(false);
        if (httpSession == null || httpSession.getAttribute("userId") == null) {
            sendErrorResponse(response, "Please login to remove items from cart",
                    HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        Integer userId = (Integer) httpSession.getAttribute("userId");
        Integer cartId = Integer.parseInt(request.getParameter("cartId"));

        try (Session session = FactoryConfiguration.getInstance().getSession()) {
            Transaction transaction = session.beginTransaction();

            try {
                Cart cartItem = session.get(Cart.class, cartId);
                if (cartItem == null) {
                    throw new Exception("Cart item not found");
                }

                if (!cartItem.getUser().getId().equals(userId)) {
                    throw new Exception("Unauthorized access to cart item");
                }

                session.remove(cartItem);
                transaction.commit();

                // Update cart count after successful removal
                updateCartCount(httpSession, session, userId);

                Integer updatedCount = (Integer) httpSession.getAttribute("cartCount");
                JsonObject json = new JsonObject();
                json.addProperty("success", true);
                json.addProperty("message", "Item removed from cart successfully");
                json.addProperty("cartCount", updatedCount);

                response.setContentType("application/json");
                response.getWriter().write(json.toString());

            } catch (Exception e) {
                if (transaction != null && transaction.isActive()) {
                    transaction.rollback();
                }
                throw e;
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, e.getMessage());
        }
    }
    private void sendErrorResponse(HttpServletResponse response, String message, int statusCode)
            throws IOException {
        System.err.println("Sending error response: " + message); // Debug log

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(statusCode);

        JsonObject json = new JsonObject();
        json.addProperty("success", false);
        json.addProperty("message", message);

        String jsonResponse = json.toString();
        System.err.println("Error response JSON: " + jsonResponse); // Debug log

        response.getWriter().write(jsonResponse);
        response.getWriter().flush();
    }

}