package lk.ijse.servlets;

import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lk.ijse.config.FactoryConfiguration;
import lk.ijse.entity.*;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

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

            // Get cart items
            List<Cart> cartItems = session.createQuery(
                            "FROM Cart c LEFT JOIN FETCH c.product WHERE c.user.id = :userId", Cart.class)
                    .setParameter("userId", userId)
                    .list();

            if (cartItems.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            // Calculate totals
            BigDecimal subtotal = calculateSubtotal(cartItems);
            BigDecimal shippingCost = new BigDecimal("200.00");
            BigDecimal total = subtotal.add(shippingCost);

            // Set attributes for JSP
            request.setAttribute("cartItems", cartItems);
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("shippingCost", shippingCost);
            request.setAttribute("total", total);

            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading checkout");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession httpSession = request.getSession(false);
        if (httpSession == null || httpSession.getAttribute("userId") == null) {
            sendErrorResponse(response, "Please login to place order", HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        Integer userId = (Integer) httpSession.getAttribute("userId");

        try (Session session = FactoryConfiguration.getInstance().getSession()) {
            Transaction transaction = session.beginTransaction();

            try {
                // Get cart items
                List<Cart> cartItems = session.createQuery(
                                "FROM Cart c LEFT JOIN FETCH c.product WHERE c.user.id = :userId", Cart.class)
                        .setParameter("userId", userId)
                        .list();

                if (cartItems.isEmpty()) {
                    throw new Exception("Cart is empty");
                }

                // Verify stock and calculate total
                BigDecimal subtotal = BigDecimal.ZERO;
                for (Cart item : cartItems) {
                    if (item.getProduct().getStock() < item.getQuantity()) {
                        throw new Exception("Not enough stock for " + item.getProduct().getName());
                    }
                    subtotal = subtotal.add(item.getProduct().getPrice()
                            .multiply(BigDecimal.valueOf(item.getQuantity())));
                }

                BigDecimal shippingCost = new BigDecimal("200.00");
                BigDecimal totalAmount = subtotal.add(shippingCost);

                // Create order
                Order order = new Order();
                order.setUser(session.get(User.class, userId));
                order.setShippingFirstName(request.getParameter("firstName"));
                order.setShippingLastName(request.getParameter("lastName"));
                order.setShippingAddress(request.getParameter("address"));
                order.setShippingCity(request.getParameter("city"));
                order.setShippingZip(request.getParameter("zipCode"));
                order.setPaymentMethod(request.getParameter("paymentMethod"));
                order.setShippingCost(shippingCost);
                order.setTotalAmount(totalAmount);
                order.setStatus("COMPLETED");
                order.setCreatedAt(LocalDateTime.now());

                session.persist(order);

                // Create order details and update stock
                for (Cart item : cartItems) {
                    // Create order detail
                    OrderDetail detail = new OrderDetail();
                    detail.setOrder(order);
                    detail.setProduct(item.getProduct());
                    detail.setQuantity(item.getQuantity());
                    detail.setPrice(item.getProduct().getPrice());
                    session.persist(detail);

                    // Update product stock
                    Product product = item.getProduct();
                    product.setStock(product.getStock() - item.getQuantity());
                    session.merge(product);

                    // Remove cart item
                    session.remove(item);
                }

                transaction.commit();

                // Reset cart count in session
                httpSession.setAttribute("cartCount", 0);

                // Send success response
                JsonObject json = new JsonObject();
                json.addProperty("success", true);
                json.addProperty("message", "Order placed successfully");
                json.addProperty("orderId", order.getId());

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

    private BigDecimal calculateSubtotal(List<Cart> cartItems) {
        return cartItems.stream()
                .map(item -> item.getProduct().getPrice()
                        .multiply(BigDecimal.valueOf(item.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);
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

    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        sendErrorResponse(response, message, HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
}