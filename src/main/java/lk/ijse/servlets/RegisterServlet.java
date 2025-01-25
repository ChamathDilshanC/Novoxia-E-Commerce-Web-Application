package lk.ijse.servlets;

import com.google.gson.JsonObject;
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

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.regex.Pattern;

@WebServlet(name = "RegisterServlet", urlPatterns = "/register")
public class RegisterServlet extends HttpServlet {

    // Validation patterns
    private static final Pattern NAME_PATTERN = Pattern.compile("^[a-zA-Z\\s]{2,50}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");
    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[a-zA-Z0-9_]{4,20}$");
    private static final Pattern PASSWORD_PATTERN = Pattern.compile("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{8,}$");

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Session session = FactoryConfiguration.getInstance().getSession();
        Transaction transaction = null;
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();
        JsonObject jsonResponse = new JsonObject();

        try {
            // Sanitize inputs
            String firstName = sanitizeInput(req.getParameter("firstName"));
            String lastName = sanitizeInput(req.getParameter("lastName"));
            String email = sanitizeInput(req.getParameter("email")).toLowerCase();
            String username = sanitizeInput(req.getParameter("username"));
            String password = req.getParameter("password");
            String confirmPassword = req.getParameter("confirmPassword");

            // Validate inputs
            JsonObject errors = new JsonObject();

            if (!isValidName(firstName)) {
                errors.addProperty("firstName", "Invalid first name (2-50 letters)");
            }

            if (!isValidName(lastName)) {
                errors.addProperty("lastName", "Invalid last name (2-50 letters)");
            }

            if (!isValidEmail(email)) {
                errors.addProperty("email", "Invalid email format");
            }

            if (!isValidUsername(username)) {
                errors.addProperty("username", "4-20 chars (letters, numbers, underscores)");
            }

            if (!isValidPassword(password)) {
                errors.addProperty("password", "8+ chars with uppercase, number, and special");
            }

            if (!password.equals(confirmPassword)) {
                errors.addProperty("confirmPassword", "Passwords don't match");
            }

            // Check for existing user only if no validation errors
            if (errors.size() == 0) {
                boolean userExists = (Long) session.createQuery(
                                "SELECT COUNT(u) FROM User u WHERE LOWER(u.username) = :username OR LOWER(u.email) = :email")
                        .setParameter("username", username.toLowerCase())
                        .setParameter("email", email.toLowerCase())
                        .uniqueResult() > 0;

                if (userExists) {
                    errors.addProperty("general", "Username or email already exists");
                }
            }

            if (errors.size() > 0) {
                jsonResponse.addProperty("status", "error");
                jsonResponse.add("errors", errors);
                out.print(jsonResponse.toString());
                return;
            }

            // Create and save user
            User user = new User();
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setUsername(username);
            user.setPassword(PasswordEncoder.encode(password));
            user.setEmail(email);
            user.setRole("CUSTOMER");
            user.setCreatedAt(LocalDateTime.now());
            user.setOrders(new ArrayList<>());
            user.setCartItems(new ArrayList<>());

            transaction = session.beginTransaction();
            session.persist(user);
            transaction.commit();

            jsonResponse.addProperty("status", "success");
            jsonResponse.addProperty("message", "Registration successful!");
            out.print(jsonResponse.toString());

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            jsonResponse.addProperty("status", "error");
            jsonResponse.addProperty("message", "Server error: " + e.getMessage());
            out.print(jsonResponse.toString());
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    private boolean isValidName(String name) {
        return NAME_PATTERN.matcher(name).matches();
    }

    private boolean isValidEmail(String email) {
        return EMAIL_PATTERN.matcher(email).matches();
    }

    private boolean isValidUsername(String username) {
        return USERNAME_PATTERN.matcher(username).matches();
    }

    private boolean isValidPassword(String password) {
        return PASSWORD_PATTERN.matcher(password).matches();
    }

    private String sanitizeInput(String input) {
        return input != null ? input.trim().replaceAll("<", "&lt;").replaceAll(">", "&gt;") : "";
    }
}