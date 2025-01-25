package lk.ijse.servlets;

import com.google.gson.JsonArray;
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

@WebServlet("/cart/*")
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            switch (pathInfo) {
                case "/count":
                    getCartCount(request, response);
                    break;
                case "/items":
                    getCartItems(request, response);
                    break;
                default:
                    sendErrorResponse(response, "Invalid path", HttpServletResponse.SC_BAD_REQUEST);
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Error processing request: " + e.getMessage());
        }
    }

    private void getCartCount(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession httpSession = request.getSession();
        Integer userId = (Integer) httpSession.getAttribute("userId");

        if (userId == null) {
            sendErrorResponse(response, "User not logged in", HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        try (Session session = FactoryConfiguration.getInstance().getSession()) {
            Long cartCount = session.createQuery(
                            "SELECT COUNT(c) FROM Cart c WHERE c.user.id = :userId",
                            Long.class)
                    .setParameter("userId", userId)
                    .uniqueResult();

            JsonObject json = new JsonObject();
            json.addProperty("success", true);
            json.addProperty("count", cartCount);

            response.setContentType("application/json");
            response.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Error getting cart count: " + e.getMessage());
        }
    }

    private void getCartItems(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession httpSession = request.getSession();
        Integer userId = (Integer) httpSession.getAttribute("userId");

        if (userId == null) {
            sendErrorResponse(response, "User not logged in", HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        try (Session session = FactoryConfiguration.getInstance().getSession()) {
            List<Cart> cartItems = session.createQuery(
                            "FROM Cart c LEFT JOIN FETCH c.product WHERE c.user.id = :userId",
                            Cart.class)
                    .setParameter("userId", userId)
                    .list();

            JsonArray itemsArray = new JsonArray();
            for (Cart item : cartItems) {
                JsonObject cartItem = new JsonObject();
                cartItem.addProperty("id", item.getId());
                cartItem.addProperty("quantity", item.getQuantity());

                Product product = item.getProduct();
                JsonObject productObj = new JsonObject();
                productObj.addProperty("id", product.getId());
                productObj.addProperty("name", product.getName());
                productObj.addProperty("price", product.getPrice().toString());
                productObj.addProperty("stock", product.getStock());
                if (product.getImagePath() != null) {
                    productObj.addProperty("imagePath", product.getImagePath());
                }
                cartItem.add("product", productObj);

                itemsArray.add(cartItem);
            }

            JsonObject json = new JsonObject();
            json.addProperty("success", true);
            json.add("items", itemsArray);

            response.setContentType("application/json");
            response.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Error getting cart items: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if ("/add".equals(pathInfo)) {
                addToCart(request, response);
            } else if ("/update".equals(pathInfo)) {
                updateCartItem(request, response);
            } else {
                sendErrorResponse(response, "Invalid path", HttpServletResponse.SC_BAD_REQUEST);
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Error processing request: " + e.getMessage());
        }
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession httpSession = request.getSession();
        Integer userId = (Integer) httpSession.getAttribute("userId");

        if (userId == null) {
            sendErrorResponse(response, "User not logged in", HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String productId = request.getParameter("productId");
        String quantity = request.getParameter("quantity");

        if (productId == null || quantity == null) {
            sendErrorResponse(response, "Missing required parameters", HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try (Session session = FactoryConfiguration.getInstance().getSession()) {
            Transaction transaction = session.beginTransaction();

            try {
                Product product = session.get(Product.class, Integer.parseInt(productId));
                User user = session.get(User.class, userId);

                if (product == null || user == null) {
                    sendErrorResponse(response, "Product or user not found", HttpServletResponse.SC_NOT_FOUND);
                    return;
                }

                int requestedQuantity = Integer.parseInt(quantity);
                if (requestedQuantity <= 0) {
                    sendErrorResponse(response, "Invalid quantity", HttpServletResponse.SC_BAD_REQUEST);
                    return;
                }

                // Check stock availability
                if (product.getStock() < requestedQuantity) {
                    sendErrorResponse(response, "Insufficient stock available", HttpServletResponse.SC_BAD_REQUEST);
                    return;
                }

                // Check if product already in cart
                Cart existingCart = session.createQuery(
                                "FROM Cart c WHERE c.user.id = :userId AND c.product.id = :productId",
                                Cart.class)
                        .setParameter("userId", userId)
                        .setParameter("productId", product.getId())
                        .uniqueResult();

                if (existingCart != null) {
                    // Update quantity
                    int newQuantity = existingCart.getQuantity() + requestedQuantity;
                    if (newQuantity > product.getStock()) {
                        sendErrorResponse(response, "Insufficient stock available", HttpServletResponse.SC_BAD_REQUEST);
                        return;
                    }
                    existingCart.setQuantity(newQuantity);
                    session.merge(existingCart);
                } else {
                    // Create new cart item
                    Cart cart = new Cart();
                    cart.setUser(user);
                    cart.setProduct(product);
                    cart.setQuantity(requestedQuantity);
                    cart.setCreatedAt(LocalDateTime.now());
                    session.persist(cart);
                }

                transaction.commit();

                // Get updated cart count
                Long cartCount = session.createQuery(
                                "SELECT COUNT(c) FROM Cart c WHERE c.user.id = :userId",
                                Long.class)
                        .setParameter("userId", userId)
                        .uniqueResult();

                // Update session
                httpSession.setAttribute("cartCount", cartCount.intValue());

                JsonObject json = new JsonObject();
                json.addProperty("success", true);
                json.addProperty("message", "Product added to cart successfully");
                json.addProperty("cartCount", cartCount);

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
            sendErrorResponse(response, "Error adding to cart: " + e.getMessage());
        }
    }

    private void updateCartItem(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession httpSession = request.getSession();
        Integer userId = (Integer) httpSession.getAttribute("userId");

        if (userId == null) {
            sendErrorResponse(response, "User not logged in", HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String cartId = request.getParameter("cartId");
        String quantity = request.getParameter("quantity");

        if (cartId == null || quantity == null) {
            sendErrorResponse(response, "Missing required parameters", HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try (Session session = FactoryConfiguration.getInstance().getSession()) {
            Transaction transaction = session.beginTransaction();

            try {
                Cart cart = session.createQuery(
                                "FROM Cart c WHERE c.id = :cartId AND c.user.id = :userId",
                                Cart.class)
                        .setParameter("cartId", Integer.parseInt(cartId))
                        .setParameter("userId", userId)
                        .uniqueResult();

                if (cart == null) {
                    sendErrorResponse(response, "Cart item not found", HttpServletResponse.SC_NOT_FOUND);
                    return;
                }

                int newQuantity = Integer.parseInt(quantity);
                if (newQuantity <= 0) {
                    // Remove item if quantity is 0 or negative
                    session.remove(cart);
                } else {
                    // Check stock availability
                    if (cart.getProduct().getStock() < newQuantity) {
                        sendErrorResponse(response, "Insufficient stock available", HttpServletResponse.SC_BAD_REQUEST);
                        return;
                    }
                    cart.setQuantity(newQuantity);
                    session.merge(cart);
                }

                transaction.commit();

                JsonObject json = new JsonObject();
                json.addProperty("success", true);
                json.addProperty("message", newQuantity <= 0 ? "Item removed from cart" : "Cart updated successfully");

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
            sendErrorResponse(response, "Error updating cart: " + e.getMessage());
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession httpSession = request.getSession();
        Integer userId = (Integer) httpSession.getAttribute("userId");

        if (userId == null) {
            sendErrorResponse(response, "User not logged in", HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String cartId = request.getParameter("id");
        if (cartId == null) {
            sendErrorResponse(response, "Missing cart item id", HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try (Session session = FactoryConfiguration.getInstance().getSession()) {
            Transaction transaction = session.beginTransaction();

            try {
                Cart cart = session.createQuery(
                                "FROM Cart c WHERE c.id = :cartId AND c.user.id = :userId",
                                Cart.class)
                        .setParameter("cartId", Integer.parseInt(cartId))
                        .setParameter("userId", userId)
                        .uniqueResult();

                if (cart == null) {
                    sendErrorResponse(response, "Cart item not found", HttpServletResponse.SC_NOT_FOUND);
                    return;
                }

                session.remove(cart);
                transaction.commit();

                // Get updated cart count
                Long cartCount = session.createQuery(
                                "SELECT COUNT(c) FROM Cart c WHERE c.user.id = :userId",
                                Long.class)
                        .setParameter("userId", userId)
                        .uniqueResult();

                // Update session
                httpSession.setAttribute("cartCount", cartCount.intValue());

                JsonObject json = new JsonObject();
                json.addProperty("success", true);
                json.addProperty("message", "Item removed from cart successfully");
                json.addProperty("cartCount", cartCount);

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
            sendErrorResponse(response, "Error removing item from cart: " + e.getMessage());
        }
    }

    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        sendErrorResponse(response, message, HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }

    private void sendErrorResponse(HttpServletResponse response, String message, int statusCode)
            throws IOException {
        JsonObject json = new JsonObject();
        json.addProperty("success", false);
        json.addProperty("message", message);

        response.setContentType("application/json");
        response.setStatus(statusCode);
        response.getWriter().write(json.toString());
    }
}