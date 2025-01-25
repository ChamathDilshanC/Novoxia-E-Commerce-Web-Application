package lk.ijse.servlets;

import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lk.ijse.config.FactoryConfiguration;
import lk.ijse.entity.User;
import lk.ijse.util.PasswordEncoder;
import org.hibernate.Session;
import org.hibernate.query.Query;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "LoginServlet", urlPatterns = "/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Session session = FactoryConfiguration.getInstance().getSession();

        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();
        JsonObject jsonResponse = new JsonObject();

        try {
            String username = req.getParameter("username");
            String password = req.getParameter("password");
            String rememberMe = req.getParameter("rememberMe");

            // Basic validation
            if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "Username and password are required");
                out.print(jsonResponse.toString());
                return;
            }

            Query<User> query = session.createQuery(
                    "FROM User WHERE username = :username OR email = :email",
                    User.class
            );
            query.setParameter("username", username.trim());
            query.setParameter("email", username.trim());

            User user = query.uniqueResult();

            if (user != null && PasswordEncoder.verify(password, user.getPassword())) {

                HttpSession httpSession = req.getSession(true); // Create new session if none exists
                httpSession.setAttribute("userId", user.getId());
                httpSession.setAttribute("username", user.getUsername());
                httpSession.setAttribute("role", user.getRole());
                httpSession.setAttribute("firstName", user.getFirstName());
                httpSession.setAttribute("lastName", user.getLastName());
                httpSession.setAttribute("email", user.getEmail());

                // Set session timeout
                if (rememberMe != null && rememberMe.equals("on")) {
                    httpSession.setMaxInactiveInterval(7 * 24 * 60 * 60); // 7 days
                } else {
                    httpSession.setMaxInactiveInterval(30 * 60); // 30 minutes
                }

                jsonResponse.addProperty("status", "success");
                jsonResponse.addProperty("redirect", "dashboard.jsp");
            } else {
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "Invalid username or password");
            }

        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("status", "error");
            jsonResponse.addProperty("message", "Login failed: An unexpected error occurred");
        } finally {
            if (session != null) {
                session.close();
            }
            out.print(jsonResponse.toString());
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect("index.jsp");
    }
}