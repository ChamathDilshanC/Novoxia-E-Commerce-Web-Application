package lk.ijse.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.ijse.config.FactoryConfiguration;
import lk.ijse.entity.User;
import lk.ijse.util.PasswordEncoder;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "UserServlet", urlPatterns = "/user")
public class UserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Session session = null;
        try {
            session = FactoryConfiguration.getInstance().getSession();
            Query<User> query = session.createQuery("FROM User ORDER BY createdAt DESC", User.class);
            List<User> users = query.list();

            req.setAttribute("users", users);
            req.getRequestDispatcher("users.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            String errorMessage = e.getMessage();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write(errorMessage);
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");

        switch (action) {
            case "create":
                createUser(req, resp);
                break;
            case "update":
                updateUser(req, resp);
                break;
            case "delete":
                deleteUser(req, resp);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    private void createUser(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Session session = null;
        Transaction transaction = null;

        try {
            String username = req.getParameter("username");
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            String firstName = req.getParameter("firstName");
            String lastName = req.getParameter("lastName");
            String role = req.getParameter("role");

            session = FactoryConfiguration.getInstance().getSession();
            Query<User> query = session.createQuery(
                    "FROM User WHERE username = :username OR email = :email",
                    User.class
            );
            query.setParameter("username", username);
            query.setParameter("email", email);

            if (!query.list().isEmpty()) {
                resp.setStatus(HttpServletResponse.SC_CONFLICT);
                resp.getWriter().write("Username or email already exists");
                return;
            }

            String hashedPassword = PasswordEncoder.encode(password);

            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPassword(hashedPassword);
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setRole(role);
            user.setCreatedAt(LocalDateTime.now());

            transaction = session.beginTransaction();
            session.persist(user);
            transaction.commit();

            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("User created successfully");

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("Error creating user: " + e.getMessage());
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    private void updateUser(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Session session = null;
        Transaction transaction = null;

        try {
            Long userId = Long.parseLong(req.getParameter("id"));
            String username = req.getParameter("username");
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            String firstName = req.getParameter("firstName");
            String lastName = req.getParameter("lastName");
            String role = req.getParameter("role");

            session = FactoryConfiguration.getInstance().getSession();

            Query<User> query = session.createQuery(
                    "FROM User WHERE (username = :username OR email = :email) AND id != :userId",
                    User.class
            );
            query.setParameter("username", username);
            query.setParameter("email", email);
            query.setParameter("userId", userId);

            if (!query.list().isEmpty()) {
                resp.setStatus(HttpServletResponse.SC_CONFLICT);
                resp.getWriter().write("Username or email already exists");
                return;
            }

            transaction = session.beginTransaction();
            User user = session.get(User.class, userId);

            if (user == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("User not found");
                return;
            }

            user.setUsername(username);
            user.setEmail(email);
            if (password != null && !password.trim().isEmpty()) {
                user.setPassword(PasswordEncoder.encode(password));
            }
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setRole(role);

            session.merge(user);
            transaction.commit();

            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("User updated successfully");

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("Error updating user: " + e.getMessage());
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    private void deleteUser(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Session session = null;
        Transaction transaction = null;

        try {
            Long userId = Long.parseLong(req.getParameter("id"));

            session = FactoryConfiguration.getInstance().getSession();
            transaction = session.beginTransaction();

            User user = session.get(User.class, userId);
            if (user == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("User not found");
                return;
            }

            Long currentUserId = (Long) req.getSession().getAttribute("userId");
            if (currentUserId != null && currentUserId.equals(userId)) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("Cannot delete your own account");
                return;
            }

            Query<?> deleteOrderDetailsQuery = session.createQuery(
                    "DELETE FROM OrderDetail od WHERE od.order.user.id = :userId"
            );
            deleteOrderDetailsQuery.setParameter("userId", userId);
            deleteOrderDetailsQuery.executeUpdate();

            Query<?> deleteOrdersQuery = session.createQuery(
                    "DELETE FROM Order o WHERE o.user.id = :userId"
            );
            deleteOrdersQuery.setParameter("userId", userId);
            deleteOrdersQuery.executeUpdate();

            Query<?> deleteCartQuery = session.createQuery(
                    "DELETE FROM Cart c WHERE c.user.id = :userId"
            );
            deleteCartQuery.setParameter("userId", userId);
            deleteCartQuery.executeUpdate();

            session.remove(user);
            transaction.commit();

            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("User deleted successfully");

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("Error deleting user: " + e.getMessage());
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }
}