package lk.ijse.listners;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import lk.ijse.config.FactoryConfiguration;
import lk.ijse.entity.User;
import lk.ijse.util.PasswordEncoder;
import org.apache.commons.dbcp2.BasicDataSource;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.sql.SQLException;
import java.time.LocalDateTime;

@WebListener
public class DBListener implements ServletContextListener {
    private BasicDataSource basicDataSource;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            System.out.println("Initializing database connection pool...");

            // Initialize connection pool
            basicDataSource = new BasicDataSource();
            basicDataSource.setDriverClassName("com.mysql.cj.jdbc.Driver");
            basicDataSource.setUrl("jdbc:mysql://localhost:3306/ecommerce?createDatabaseIfNotExist=true");
            basicDataSource.setUsername("root");
            basicDataSource.setPassword("Ijse@123");

            // Connection pool configuration
            basicDataSource.setInitialSize(5);
            basicDataSource.setMaxTotal(20);
            basicDataSource.setMaxIdle(10);
            basicDataSource.setMinIdle(5);
            basicDataSource.setMaxWaitMillis(10000);

            // Enable connection testing
            basicDataSource.setTestOnBorrow(true);
            basicDataSource.setTestWhileIdle(true);
            basicDataSource.setValidationQuery("SELECT 1");

            // Store the datasource in servlet context
            ServletContext servletContext = sce.getServletContext();
            servletContext.setAttribute("db", basicDataSource);

            // Initialize Hibernate
            FactoryConfiguration.initialize(basicDataSource);

            // Test the connection and create admin if needed
            Session testSession = null;
            Transaction transaction = null;
            try {
                testSession = FactoryConfiguration.getInstance().getSession();
                transaction = testSession.beginTransaction();

                // Check if any users exist
                Query<Long> query = testSession.createQuery(
                        "SELECT COUNT(u) FROM User u",
                        Long.class
                );
                Long userCount = query.uniqueResult();

                // If no users exist, create admin user
                if (userCount == 0) {
                    System.out.println("No users found. Creating admin user...");

                    User adminUser = new User();
                    adminUser.setUsername("admin");
                    adminUser.setEmail("admin@novoxia.com");
                    adminUser.setPassword(PasswordEncoder.encode("Admin@123"));
                    adminUser.setFirstName("Admin");
                    adminUser.setLastName("User");
                    adminUser.setRole("ADMIN");
                    adminUser.setCreatedAt(LocalDateTime.now());

                    testSession.persist(adminUser);
                    System.out.println("Admin user created successfully");
                }

                transaction.commit();
                System.out.println("Database connection and Hibernate initialization successful");
            } catch (Exception e) {
                if (transaction != null) {
                    transaction.rollback();
                }
                throw new RuntimeException("Failed to initialize Hibernate: " + e.getMessage(), e);
            } finally {
                if (testSession != null && testSession.isOpen()) {
                    testSession.close();
                }
            }

        } catch (Exception e) {
            System.err.println("Failed to initialize database connection: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Database initialization failed", e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        try {
            System.out.println("Shutting down database connection pool...");
            if (basicDataSource != null) {
                basicDataSource.close();
            }
            System.out.println("Database connection pool closed successfully");
        } catch (SQLException e) {
            System.err.println("Error closing database connection pool: " + e.getMessage());
            e.printStackTrace();
        }
    }
}