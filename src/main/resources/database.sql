    create database ecommerce;
    use ecommerce;

    -- Users table
    CREATE TABLE IF NOT EXISTS user (
        id INT PRIMARY KEY AUTO_INCREMENT,
        first_name VARCHAR(100) NOT NULL,
        last_name VARCHAR(100) NOT NULL,
        username VARCHAR(50) NOT NULL UNIQUE,
        password VARCHAR(255) NOT NULL,
        email VARCHAR(100) NOT NULL UNIQUE,
        role VARCHAR(20) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY uk_username (username),
        UNIQUE KEY uk_email (email)
        );

    -- Categories table
    CREATE TABLE categories (
                                id INT PRIMARY KEY AUTO_INCREMENT,
                                name VARCHAR(100) NOT NULL,
                                description TEXT
    );

    -- Products table
    CREATE TABLE products (
                              id INT PRIMARY KEY AUTO_INCREMENT,
                              name VARCHAR(200) NOT NULL,
                              description TEXT,
                              price DECIMAL(10,2) NOT NULL,
                              category_id INT,
                              stock INT NOT NULL DEFAULT 0,
                              image_path VARCHAR(255),  -- New column for storing image path
                              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                              FOREIGN KEY (category_id) REFERENCES categories(id)
    );

    -- Orders table
    CREATE TABLE orders (
                            id INT PRIMARY KEY AUTO_INCREMENT,
                            user_id INT,
                            total_amount DECIMAL(10,2) NOT NULL,
                            status VARCHAR(50) NOT NULL, -- 'PENDING', 'COMPLETED', 'CANCELLED'
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                            FOREIGN KEY (user_id) REFERENCES user(id)
    );

    -- Order details table
    CREATE TABLE order_details (
                                   id INT PRIMARY KEY AUTO_INCREMENT,
                                   order_id INT,
                                   product_id INT,
                                   quantity INT NOT NULL,
                                   price DECIMAL(10,2) NOT NULL,
                                   FOREIGN KEY (order_id) REFERENCES orders(id),
                                   FOREIGN KEY (product_id) REFERENCES products(id)
    );

    -- Cart table
    CREATE TABLE cart (
                          id INT PRIMARY KEY AUTO_INCREMENT,
                          user_id INT,
                          product_id INT,
                          quantity INT NOT NULL,
                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          FOREIGN KEY (user_id) REFERENCES user(id),
                          FOREIGN KEY (product_id) REFERENCES products(id)
    );