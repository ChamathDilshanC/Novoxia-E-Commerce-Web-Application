package lk.ijse.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lk.ijse.config.FactoryConfiguration;
import lk.ijse.entity.Order;
import org.hibernate.Session;
import org.hibernate.query.Query;

import java.io.IOException;
import java.util.List;

@WebServlet("/orders/*")
public class OrderDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession httpSession = request.getSession(false);
        if (httpSession == null || httpSession.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) httpSession.getAttribute("userId");
        String role = (String) httpSession.getAttribute("role");
        String pathInfo = request.getPathInfo();

        try (Session session = FactoryConfiguration.getInstance().getSession()) {
            if (pathInfo != null && pathInfo.equals("/view")) {
                // View single order
                Integer orderId = Integer.parseInt(request.getParameter("id"));
                Query<Order> query = session.createQuery(
                        "FROM Order o LEFT JOIN FETCH o.orderDetails od " +
                                "LEFT JOIN FETCH od.product " +
                                "WHERE o.id = :orderId " +
                                ("ADMIN".equals(role) ? "" : "AND o.user.id = :userId"),
                        Order.class);

                query.setParameter("orderId", orderId);
                if (!"ADMIN".equals(role)) {
                    query.setParameter("userId", userId);
                }

                Order order = query.uniqueResult();

                if (order != null) {
                    request.setAttribute("order", order);
                    request.getRequestDispatcher("/order-detail.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
                }
            } else {
                // List all orders
                String hql = "FROM Order o LEFT JOIN FETCH o.user WHERE ";
                if ("ADMIN".equals(role)) {
                    hql += "1=1";
                } else {
                    hql += "o.user.id = :userId";
                }
                hql += " ORDER BY o.createdAt DESC";

                Query<Order> query = session.createQuery(hql, Order.class);
                if (!"ADMIN".equals(role)) {
                    query.setParameter("userId", userId);
                }

                List<Order> orders = query.getResultList();
                request.setAttribute("orders", orders);
                request.getRequestDispatcher("/orders.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error processing request: " + e.getMessage());
        }
    }
}