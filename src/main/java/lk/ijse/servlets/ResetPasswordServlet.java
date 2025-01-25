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
import org.hibernate.query.Query;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "ResetPasswordServlet", urlPatterns = "/resetPassword")
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Session session = FactoryConfiguration.getInstance().getSession();
        Transaction transaction = null;

        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();
        JsonObject jsonResponse = new JsonObject();

        try {
            String username = validateInput(req.getParameter("username"), "Username");
            String email = validateInput(req.getParameter("email"), "Email");
            String newPassword = validateInput(req.getParameter("newPassword"), "New Password");
            String confirmPassword = validateInput(req.getParameter("confirmPassword"), "Confirm Password");

            if (!newPassword.equals(confirmPassword)) {
                sendErrorResponse(out, "Passwords do not match!");
                return;
            }

            if (!isValidPassword(newPassword)) {
                sendErrorResponse(out, "Password must be at least 8 characters and include letters, numbers, and special characters!");
                return;
            }

            Query<User> query = session.createQuery(
                    "FROM User WHERE username = :username AND email = :email", User.class);
            query.setParameter("username", username);
            query.setParameter("email", email);
            User user = query.uniqueResult();

            if (user == null) {
                sendErrorResponse(out, "No account found with these credentials!");
                return;
            }

            transaction = session.beginTransaction();
            user.setPassword(PasswordEncoder.encode(newPassword));
            session.merge(user);
            transaction.commit();


            jsonResponse.addProperty("status", "success");
            jsonResponse.addProperty("message", "Password reset successful!");
            out.print(jsonResponse.toString());

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            sendErrorResponse(out, "Password reset failed: " + e.getMessage());
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    private String validateInput(String input, String fieldName) throws Exception {
        if (input == null || input.trim().isEmpty()) {
            throw new Exception(fieldName + " is required!");
        }
        return input.trim();
    }

    private boolean isValidPassword(String password) {
        // Password must be at least 8 characters and include letters, numbers, and special characters
        String passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$";
        return password.matches(passwordRegex);
    }

    private void sendErrorResponse(PrintWriter out, String message) {
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("status", "error");
        jsonResponse.addProperty("message", message);
        out.print(jsonResponse.toString());
    }
}