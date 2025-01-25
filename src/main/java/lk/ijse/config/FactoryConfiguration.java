package lk.ijse.config;

import lk.ijse.entity.*;
import org.apache.commons.dbcp2.BasicDataSource;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class FactoryConfiguration {
    private static FactoryConfiguration factoryConfiguration;
    private final SessionFactory sessionFactory;

    private FactoryConfiguration(BasicDataSource dataSource) {
        Configuration configuration = new Configuration()
                .configure("hibernate.cfg.xml")
                .addAnnotatedClass(Cart.class)
                .addAnnotatedClass(Category.class)
                .addAnnotatedClass(Order.class)
                .addAnnotatedClass(OrderDetail.class)
                .addAnnotatedClass(Product.class)
                .addAnnotatedClass(User.class);

        // Set the DataSource
        if (dataSource != null) {
            configuration.getProperties().put("hibernate.connection.datasource", dataSource);
        }

        sessionFactory = configuration.buildSessionFactory();
    }

    public static void initialize(BasicDataSource dataSource) {
        if (factoryConfiguration == null) {
            factoryConfiguration = new FactoryConfiguration(dataSource);
        }
    }

    public static FactoryConfiguration getInstance() {
        if (factoryConfiguration == null) {
            throw new IllegalStateException("FactoryConfiguration not initialized. Call initialize() first.");
        }
        return factoryConfiguration;
    }

    public Session getSession() {
        return sessionFactory.openSession();
    }
}