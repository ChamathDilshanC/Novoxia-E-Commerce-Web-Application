package lk.ijse.servlets;

import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.ijse.config.FactoryConfiguration;
import lk.ijse.entity.Category;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "CategoryServlet", urlPatterns = "/categories")
public class CategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Session session = null;
        try {
            session = FactoryConfiguration.getInstance().getSession();
            Query<Category> query = session.createQuery("FROM Category ORDER BY name", Category.class);
            List<Category> categories = query.list();

            req.setAttribute("categories", categories);
            req.getRequestDispatcher("categories.jsp").forward(req, resp);

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
                createCategory(req, resp);
                break;
            case "update":
                updateCategory(req, resp);
                break;
            case "delete":
                deleteCategory(req, resp);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    private void createCategory(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Session session = null;
        Transaction transaction = null;

        try {
            String name = req.getParameter("name");
            String description = req.getParameter("description");

            if (name == null || name.trim().isEmpty()) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("Category name is required");
                return;
            }

            session = FactoryConfiguration.getInstance().getSession();

            // Check if category exists
            Query<Category> query = session.createQuery(
                    "FROM Category WHERE LOWER(name) = LOWER(:name)",
                    Category.class
            );
            query.setParameter("name", name.trim());

            if (!query.list().isEmpty()) {
                resp.setStatus(HttpServletResponse.SC_CONFLICT);
                resp.getWriter().write("Category already exists");
                return;
            }

            Category category = new Category();
            category.setName(name.trim());
            category.setDescription(description != null ? description.trim() : null);

            transaction = session.beginTransaction();
            session.persist(category);
            transaction.commit();

            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("Category created successfully");

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("Error creating category: " + e.getMessage());
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    private void updateCategory(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Session session = null;
        Transaction transaction = null;

        try {
            Integer id = Integer.parseInt(req.getParameter("id"));
            String name = req.getParameter("name");
            String description = req.getParameter("description");

            if (name == null || name.trim().isEmpty()) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("Category name is required");
                return;
            }

            session = FactoryConfiguration.getInstance().getSession();

            // Check for duplicate name excluding current category
            Query<Category> query = session.createQuery(
                    "FROM Category WHERE LOWER(name) = LOWER(:name) AND id != :id",
                    Category.class
            );
            query.setParameter("name", name.trim());
            query.setParameter("id", id);

            if (!query.list().isEmpty()) {
                resp.setStatus(HttpServletResponse.SC_CONFLICT);
                resp.getWriter().write("Category name already exists");
                return;
            }

            transaction = session.beginTransaction();
            Category category = session.get(Category.class, id);

            if (category == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("Category not found");
                return;
            }

            category.setName(name.trim());
            category.setDescription(description != null ? description.trim() : null);

            session.merge(category);
            transaction.commit();

            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("Category updated successfully");

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("Error updating category: " + e.getMessage());
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    private void deleteCategory(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Session session = null;
        Transaction transaction = null;

        try {
            Integer id = Integer.parseInt(req.getParameter("id"));

            session = FactoryConfiguration.getInstance().getSession();

            // Check if category has products
            Query<?> productQuery = session.createQuery(
                    "SELECT COUNT(p) FROM Product p WHERE p.category.id = :categoryId"
            );
            productQuery.setParameter("categoryId", id);
            Long productCount = (Long) productQuery.uniqueResult();

            if (productCount > 0) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("Cannot delete category with associated products");
                return;
            }

            transaction = session.beginTransaction();
            Category category = session.get(Category.class, id);

            if (category == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("Category not found");
                return;
            }

            session.remove(category);
            transaction.commit();

            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("Category deleted successfully");

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("Error deleting category: " + e.getMessage());
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }
}