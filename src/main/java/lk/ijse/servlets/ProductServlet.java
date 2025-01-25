package lk.ijse.servlets;

import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import lk.ijse.config.FactoryConfiguration;
import lk.ijse.entity.Category;
import lk.ijse.entity.Product;
import lk.ijse.util.FileUploadUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/products/*")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,    // 1MB
        maxFileSize = 1024 * 1024 * 10,     // 10MB
        maxRequestSize = 1024 * 1024 * 15    // 15MB
)
public class ProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String productId = request.getParameter("id");

        try (Session session = FactoryConfiguration.getInstance().getSession()) {
            if (productId != null) {
                // Single product fetch for edit modal
                Product product = session.get(Product.class, Integer.parseInt(productId));
                if (product != null) {
                    JsonObject jsonResponse = new JsonObject();
                    jsonResponse.addProperty("id", product.getId());
                    jsonResponse.addProperty("name", product.getName());
                    jsonResponse.addProperty("description", product.getDescription());
                    jsonResponse.addProperty("price", product.getPrice().toString());
                    jsonResponse.addProperty("stock", product.getStock());

                    if (product.getCategory() != null) {
                        JsonObject category = new JsonObject();
                        category.addProperty("id", product.getCategory().getId());
                        category.addProperty("name", product.getCategory().getName());
                        jsonResponse.add("category", category);
                    }

                    if (product.getImagePath() != null) {
                        jsonResponse.addProperty("imagePath", product.getImagePath());
                    }

                    response.setContentType("application/json");
                    response.getWriter().write(jsonResponse.toString());
                } else {
                    sendErrorResponse(response, "Product not found", HttpServletResponse.SC_NOT_FOUND);
                }
            } else {
                // Fetch all products and categories
                List<Product> products = session.createQuery(
                        "FROM Product p LEFT JOIN FETCH p.category ORDER BY p.createdAt DESC",
                        Product.class
                ).list();

                List<Category> categories = session.createQuery(
                        "FROM Category ORDER BY name",
                        Category.class
                ).list();

                request.setAttribute("products", products);
                request.setAttribute("categories", categories);
                request.getRequestDispatcher("/products.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Error loading products");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String method = request.getParameter("_method");

        if ("PUT".equals(method)) {
            doPut(request, response);
        } else if ("DELETE".equals(method)) {
            doDelete(request, response);
        } else {
            handleCreate(request, response);
        }
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try (Session session = FactoryConfiguration.getInstance().getSession()) {
            Transaction transaction = session.beginTransaction();

            try {
                Product product = new Product();
                product.setName(request.getParameter("name"));
                product.setDescription(request.getParameter("description"));
                product.setPrice(new BigDecimal(request.getParameter("price")));
                product.setStock(Integer.parseInt(request.getParameter("stock")));

                // Handle category
                String categoryIdStr = request.getParameter("categoryId");
                if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
                    Category category = session.get(Category.class, Integer.parseInt(categoryIdStr));
                    if (category == null) {
                        throw new RuntimeException("Selected category not found");
                    }
                    product.setCategory(category);
                } else {
                    throw new RuntimeException("Category is required");
                }

                // Handle image upload
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
            sendErrorResponse(response, "Error creating product: " + e.getMessage());
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try (Session session = FactoryConfiguration.getInstance().getSession()) {
            Transaction transaction = session.beginTransaction();

            try {
                Integer productId = Integer.parseInt(request.getParameter("id"));
                Product product = session.get(Product.class, productId);

                if (product != null) {
                    product.setName(request.getParameter("name"));
                    product.setDescription(request.getParameter("description"));
                    product.setPrice(new BigDecimal(request.getParameter("price")));
                    product.setStock(Integer.parseInt(request.getParameter("stock")));

                    String categoryIdStr = request.getParameter("categoryId");
                    if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
                        Category category = session.get(Category.class, Integer.parseInt(categoryIdStr));
                        if (category == null) {
                            throw new RuntimeException("Selected category not found");
                        }
                        product.setCategory(category);
                    }

                    Part filePart = request.getPart("image");
                    if (filePart != null && filePart.getSize() > 0) {
                        // Delete old image
                        if (product.getImagePath() != null) {
                            FileUploadUtil.deleteFile(product.getImagePath(),
                                    request.getServletContext().getRealPath(""));
                        }

                        // Save new image
                        String imagePath = FileUploadUtil.saveFile(filePart,
                                request.getServletContext().getRealPath(""));
                        product.setImagePath(imagePath);
                    }

                    session.merge(product);
                    transaction.commit();

                    JsonObject json = new JsonObject();
                    json.addProperty("success", true);
                    json.addProperty("message", "Product updated successfully");
                    json.addProperty("productId", product.getId());

                    response.setContentType("application/json");
                    response.getWriter().write(json.toString());
                } else {
                    sendErrorResponse(response, "Product not found", HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (Exception e) {
                if (transaction != null && transaction.isActive()) {
                    transaction.rollback();
                }
                throw e;
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Error updating product: " + e.getMessage());
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try (Session session = FactoryConfiguration.getInstance().getSession()) {
            Transaction transaction = session.beginTransaction();

            try {
                Integer productId = Integer.parseInt(request.getParameter("id"));
                Product product = session.get(Product.class, productId);

                if (product != null) {
                    // Check if product is in any cart
                    Long cartCount = session.createQuery(
                                    "SELECT COUNT(c) FROM Cart c WHERE c.product.id = :productId",
                                    Long.class)
                            .setParameter("productId", productId)
                            .uniqueResult();

                    if (cartCount > 0) {
                        sendErrorResponse(response, "Cannot delete product that is in users' carts",
                                HttpServletResponse.SC_BAD_REQUEST);
                        return;
                    }

                    // Delete image file
                    if (product.getImagePath() != null) {
                        FileUploadUtil.deleteFile(product.getImagePath(),
                                request.getServletContext().getRealPath(""));
                    }

                    session.remove(product);
                    transaction.commit();

                    JsonObject json = new JsonObject();
                    json.addProperty("success", true);
                    json.addProperty("message", "Product deleted successfully");

                    response.setContentType("application/json");
                    response.getWriter().write(json.toString());
                } else {
                    sendErrorResponse(response, "Product not found", HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (Exception e) {
                if (transaction != null && transaction.isActive()) {
                    transaction.rollback();
                }
                throw e;
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Error deleting product: " + e.getMessage());
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