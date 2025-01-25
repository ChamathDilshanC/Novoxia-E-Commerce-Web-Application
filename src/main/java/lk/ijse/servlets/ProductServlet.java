package lk.ijse.servlets;

import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import lk.ijse.config.FactoryConfiguration;
import lk.ijse.entity.Category;
import lk.ijse.entity.Product;
import lk.ijse.util.FileUploadUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(urlPatterns = {"/products", "/products/*"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 15
)
public class ProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try (Session session = FactoryConfiguration.getInstance().getSession()) {
            if (pathInfo != null && pathInfo.equals("/search")) {
                handleSearch(request, response, session);
            } else if (request.getParameter("id") != null) {
                handleGetSingleProduct(request, response, session);
            } else {
                handleGetAllProducts(request, response, session);
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Error processing request: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession httpSession = request.getSession(false);
        if (httpSession == null || !"ADMIN".equals(httpSession.getAttribute("role"))) {
            sendErrorResponse(response, "Unauthorized access", HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String method = request.getParameter("_method");
        if ("PUT".equalsIgnoreCase(method)) {
            doPut(request, response);
        } else if ("DELETE".equalsIgnoreCase(method)) {
            doDelete(request, response);
        } else if ("POST".equalsIgnoreCase(method)) {
            handleCreate(request, response);
        } else {
            handleCreate(request, response);
        }
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Session session = null;
        Transaction transaction = null;

        try {
            System.out.println("Content Type: " + request.getContentType());
            System.out.println("Request Method: " + request.getMethod());

            session = FactoryConfiguration.getInstance().getSession();
            transaction = session.beginTransaction();

            if (!request.getContentType().toLowerCase().contains("multipart/form-data")) {
                throw new ServletException("Content type must be multipart/form-data");
            }

            String name = request.getParameter("name");
            String priceStr = request.getParameter("price");
            String stockStr = request.getParameter("stock");
            String categoryId = request.getParameter("categoryId");

            System.out.println("Received parameters:");
            System.out.println("Name: " + name);
            System.out.println("Price: " + priceStr);
            System.out.println("Stock: " + stockStr);
            System.out.println("Category ID: " + categoryId);

            if (name == null || name.trim().isEmpty() ||
                    priceStr == null || priceStr.trim().isEmpty() ||
                    stockStr == null || stockStr.trim().isEmpty() ||
                    categoryId == null || categoryId.trim().isEmpty()) {
                throw new IllegalArgumentException("All required fields must be provided");
            }

            Product product = new Product();
            product.setName(name.trim());
            product.setDescription(request.getParameter("description"));

            try {
                product.setPrice(new BigDecimal(priceStr.trim()));
                product.setStock(Integer.parseInt(stockStr.trim()));
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Invalid price or stock value: " + e.getMessage());
            }

            Category category = session.get(Category.class, Integer.parseInt(categoryId));
            if (category == null) {
                throw new IllegalArgumentException("Category not found with ID: " + categoryId);
            }
            product.setCategory(category);

            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                String imagePath = FileUploadUtil.saveFile(filePart,
                        request.getServletContext().getRealPath(""));
                product.setImagePath(imagePath);
            }

            product.setCreatedAt(LocalDateTime.now());
            session.persist(product);
            transaction.commit();

            JsonObject json = new JsonObject();
            json.addProperty("success", true);
            json.addProperty("message", "Product created successfully");
            json.addProperty("productId", product.getId());
            json.addProperty("productName", product.getName());

            response.setContentType("application/json");
            response.getWriter().write(json.toString());

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            sendErrorResponse(response, "Error creating product: " + e.getMessage());
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Session session = null;
        Transaction transaction = null;

        try {
            session = FactoryConfiguration.getInstance().getSession();
            transaction = session.beginTransaction();

            Integer productId = Integer.parseInt(request.getParameter("id"));
            Product product = session.get(Product.class, productId);

            if (product == null) {
                throw new IllegalArgumentException("Product not found");
            }

            String name = request.getParameter("name");
            product.setName(name);
            product.setDescription(request.getParameter("description"));
            product.setPrice(new BigDecimal(request.getParameter("price")));
            product.setStock(Integer.parseInt(request.getParameter("stock")));

            String categoryId = request.getParameter("categoryId");
            if (categoryId != null && !categoryId.trim().isEmpty()) {
                Category category = session.get(Category.class, Integer.parseInt(categoryId));
                if (category == null) {
                    throw new IllegalArgumentException("Invalid category selected");
                }
                product.setCategory(category);
            }

            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                if (product.getImagePath() != null) {
                    FileUploadUtil.deleteFile(product.getImagePath(),
                            request.getServletContext().getRealPath(""));
                }
                String imagePath = FileUploadUtil.saveFile(filePart,
                        request.getServletContext().getRealPath(""));
                product.setImagePath(imagePath);
            }

            session.merge(product);
            transaction.commit();

            JsonObject json = new JsonObject();
            json.addProperty("success", true);
            json.addProperty("message", "Product updated successfully");
            json.addProperty("productName", product.getName());

            response.setContentType("application/json");
            response.getWriter().write(json.toString());

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            sendErrorResponse(response, e.getMessage());
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Session session = null;
        Transaction transaction = null;

        try {
            session = FactoryConfiguration.getInstance().getSession();
            transaction = session.beginTransaction();

            Integer productId = Integer.parseInt(request.getParameter("id"));
            Product product = session.get(Product.class, productId);

            if (product == null) {
                throw new IllegalArgumentException("Product not found");
            }

            String productName = product.getName();

            // Check if product is in any orders
            Long orderCount = session.createQuery(
                            "SELECT COUNT(od) FROM OrderDetail od WHERE od.product.id = :productId",
                            Long.class)
                    .setParameter("productId", productId)
                    .uniqueResult();

            if (orderCount > 0) {
                throw new IllegalArgumentException("Cannot delete product that has been ordered");
            }

            // Remove from all carts first
            session.createQuery("DELETE FROM Cart c WHERE c.product.id = :productId")
                    .setParameter("productId", productId)
                    .executeUpdate();

            // Delete product image if exists
            if (product.getImagePath() != null) {
                FileUploadUtil.deleteFile(product.getImagePath(),
                        request.getServletContext().getRealPath(""));
            }

            session.remove(product);
            transaction.commit();

            JsonObject json = new JsonObject();
            json.addProperty("success", true);
            json.addProperty("message", "Product deleted successfully");
            json.addProperty("productName", productName);

            response.setContentType("application/json");
            response.getWriter().write(json.toString());

        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            sendErrorResponse(response, e.getMessage());
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    private void handleGetSingleProduct(HttpServletRequest request, HttpServletResponse response,
                                        Session session) throws IOException {
        try {
            Integer productId = Integer.parseInt(request.getParameter("id"));
            Product product = session.get(Product.class, productId);

            if (product == null) {
                sendErrorResponse(response, "Product not found", HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            JsonObject json = new JsonObject();
            json.addProperty("id", product.getId());
            json.addProperty("name", product.getName());
            json.addProperty("description", product.getDescription());
            json.addProperty("price", product.getPrice().toString());
            json.addProperty("stock", product.getStock());

            if (product.getCategory() != null) {
                JsonObject category = new JsonObject();
                category.addProperty("id", product.getCategory().getId());
                category.addProperty("name", product.getCategory().getName());
                json.add("category", category);
            }

            if (product.getImagePath() != null) {
                json.addProperty("imagePath", product.getImagePath());
            }

            response.setContentType("application/json");
            response.getWriter().write(json.toString());
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid product ID", HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void handleGetAllProducts(HttpServletRequest request, HttpServletResponse response,
                                      Session session) throws ServletException, IOException {
        try {
            List<Product> products = session.createQuery(
                            "FROM Product p LEFT JOIN FETCH p.category ORDER BY p.createdAt DESC",
                            Product.class)
                    .list();

            List<Category> categories = session.createQuery(
                            "FROM Category ORDER BY name",
                            Category.class)
                    .list();

            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/products.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Error fetching products: " + e.getMessage());
        }
    }

    private void handleSearch(HttpServletRequest request, HttpServletResponse response,
                              Session session) throws ServletException, IOException {
        try {
            String searchTerm = request.getParameter("term");
            String categoryId = request.getParameter("category");
            String sortBy = request.getParameter("sort");

            StringBuilder hql = new StringBuilder("FROM Product p LEFT JOIN FETCH p.category WHERE 1=1");

            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                hql.append(" AND LOWER(p.name) LIKE LOWER(:term)");
            }
            if (categoryId != null && !categoryId.trim().isEmpty()) {
                hql.append(" AND p.category.id = :categoryId");
            }

            if ("priceAsc".equals(sortBy)) {
                hql.append(" ORDER BY p.price ASC");
            } else if ("priceDesc".equals(sortBy)) {
                hql.append(" ORDER BY p.price DESC");
            } else if ("nameAsc".equals(sortBy)) {
                hql.append(" ORDER BY p.name ASC");
            } else {
                hql.append(" ORDER BY p.createdAt DESC");
            }

            Query<Product> query = session.createQuery(hql.toString(), Product.class);

            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                query.setParameter("term", "%" + searchTerm.trim() + "%");
            }
            if (categoryId != null && !categoryId.trim().isEmpty()) {
                query.setParameter("categoryId", Integer.parseInt(categoryId));
            }

            List<Product> products = query.list();

            List<Category> categories = session.createQuery(
                            "FROM Category ORDER BY name",
                            Category.class)
                    .list();

            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/products.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Error searching products: " + e.getMessage());
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