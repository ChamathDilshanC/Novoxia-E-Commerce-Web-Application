# 🛍️ Novoxia E-Commerce Platform

[![Watch the video](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://youtu.be/XgEDiRGkxNQ)

[Watch Full Platform Demo on YouTube 🎥](https://youtu.be/XgEDiRGkxNQ)

A modern, full-featured e-commerce web application built with JavaEE and modern web technologies. This platform offers a seamless shopping experience with robust admin capabilities for effective product and order management.

## ✨ Key Features

### Administrator Features
The platform provides comprehensive tools for administrators to manage the entire e-commerce operation:

- Product Management: Complete CRUD operations with image handling and real-time updates
- Category Management: Organize products efficiently with dynamic category system
- Order Management: Track and manage customer orders with status updates
- User Management: Control customer accounts and access levels


![Screenshot 2025-02-02 174428](https://github.com/user-attachments/assets/fa9cec10-5749-4420-a37e-37b9700df414)
![Screenshot 2025-02-02 174451](https://github.com/user-attachments/assets/615cd232-0c4f-4b5c-8ae5-76c534670ec6)
![Screenshot 2025-02-02 174510](https://github.com/user-attachments/assets/70285e67-1d91-4cac-b434-b00d167da03f)

### Customer Features
Customers enjoy a smooth, intuitive shopping experience with:

- User Authentication: Secure registration and login system
- Product Browsing: Advanced search and filter capabilities
- Shopping Cart: Real-time cart management with instant updates
- Order Processing: Streamlined checkout and order history
- Profile Management: Personal information and preferences control

## 🛠️ Technology Stack

### Backend
- Java EE (Jakarta EE)
- Hibernate ORM 6.3.1
- Apache Tomcat 10.1
- MySQL Database
- JDBC Connection Pool (Apache DBCP2)
- Jakarta Servlet API

### Frontend
- JSP (JavaServer Pages)
- Bootstrap 5.3
- SweetAlert2 for notifications
- Bootstrap Icons
- Modern CSS with Custom Properties
- Fetch API for AJAX operations

### Development Tools
- Maven for dependency management
- Git for version control
- IntelliJ IDEA Ultimate
- MySQL Workbench

## 📲 Quick Start Guide

1. Prerequisites:
```bash
# Install required software
- JDK 17 or later
- Apache Tomcat 10.1
- MySQL 8.0 or later
```

2. Database Setup:
```sql
# Create database and user
CREATE DATABASE ecommerce;
CREATE USER 'ecommerce_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON ecommerce.* TO 'ecommerce_user'@'localhost';
```

3. Configure Application:
```properties
# Update database connection in DBListener.java
db.url=jdbc:mysql://localhost:3306/ecommerce
db.username=ecommerce_user
db.password=your_password
```

4. Build and Deploy:
```bash
# Clone repository
git clone https://github.com/yourusername/e-commerce-platform.git

# Navigate to project directory
cd e-commerce-platform

# Build project
mvn clean install

# Deploy to Tomcat
cp target/e-commerce-platform.war /path/to/tomcat/webapps/
```

5. Configure Tomcat URL:
```properties
# Update server.xml in Tomcat configuration to set the context path
<Context path="/E_Commerce" docBase="e-commerce-platform" />

# Access the application at
http://localhost:8080/E_Commerce/
```

## 🎯 Project Structure

The application follows a clean, modular architecture:

```
src/
├── main/
│   ├── java/
│   │   └── lk/ijse/
│   │       ├── config/
│   │       ├── entity/
│   │       ├── listener/
│   │       ├── servlets/
│   │       └── util/
│   ├── resources/
│   └── webapp/
│       ├── WEB-INF/
│       ├── assets/
│       └── components/
```

## 🚀 Advanced Features

- Real-time search with debouncing
- Dynamic image preview
- Responsive design for all devices
- Connection pooling for optimal performance
- Transaction management
- Cross-site request forgery (CSRF) protection
- Secure password hashing
- Input validation and sanitization
- Error handling and user feedback

## 🎥 Video Demonstration

For a comprehensive overview of the platform's features and functionality, watch our [demonstration video on YouTube](your-youtube-link). The video covers:

- Complete admin dashboard walkthrough
- Product management workflow
- Customer shopping experience
- Order processing demonstration
- Advanced features showcase

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Contact

- Developer: Chamath Dilshan
- Email: dilshancolonne123@gmail.com
- LinkedIn: https://www.linkedin.com/in/chamathdilsahnc/
- GitHub: https://github.com/ChamathDilshanC/

## 🙏 Acknowledgments

Special thanks to:
- IJSE for project guidance and support
- The open-source community for excellent tools and libraries
- All contributors who helped improve this platform
