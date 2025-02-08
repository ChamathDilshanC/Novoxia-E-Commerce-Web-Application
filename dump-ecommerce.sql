-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: ecommerce
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `quantity` int NOT NULL,
  `product_id` int NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKpu4bcbluhsxagirmbdn7dilm5` (`product_id`),
  KEY `FKl70asp4l4w0jmbm1tqyofho4o` (`user_id`),
  CONSTRAINT `FKl70asp4l4w0jmbm1tqyofho4o` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `FKpu4bcbluhsxagirmbdn7dilm5` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` VALUES (9,'2025-02-02 16:33:20.520933',1,21,3);
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'VR Controller For Gaming','VR Controller'),(2,'Gaming KeyBoards','KeyBoards'),(3,'Gaming @ Relaxing Headsets','Headsets'),(4,'SmartGlases For Future World','SmartGlases'),(5,'Gaming Mouses','Mouse'),(6,'I Phones By Designed In Apple','I Phones'),(7,'Samsung Phones By Designed In Samsung','Samsung Phones'),(8,'Graphics Cards New Generation','Graphics Cards'),(9,'High Performance Gaming Pc Brand  New','Gaming Pc'),(10,'Google Pixel','Google Pixel'),(11,'Apple Air Pods Barnd New','Air Pods');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_details`
--

DROP TABLE IF EXISTS `order_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `price` decimal(10,2) NOT NULL,
  `quantity` int NOT NULL,
  `order_id` int DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKjyu2qbqt8gnvno9oe9j2s2ldk` (`order_id`),
  KEY `FK4q98utpd73imf4yhttm3w0eax` (`product_id`),
  CONSTRAINT `FK4q98utpd73imf4yhttm3w0eax` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `FKjyu2qbqt8gnvno9oe9j2s2ldk` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_details`
--

LOCK TABLES `order_details` WRITE;
/*!40000 ALTER TABLE `order_details` DISABLE KEYS */;
INSERT INTO `order_details` VALUES (1,350000.00,1,1,1),(2,358000.00,1,2,21),(3,2600.00,1,2,20),(4,2000.00,1,2,18),(5,699000.00,1,3,13),(6,405000.00,2,3,19);
/*!40000 ALTER TABLE `order_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `payment_method` varchar(255) NOT NULL,
  `shipping_address` varchar(255) NOT NULL,
  `shipping_city` varchar(255) NOT NULL,
  `shipping_cost` decimal(38,2) NOT NULL,
  `shipping_first_name` varchar(255) NOT NULL,
  `shipping_last_name` varchar(255) NOT NULL,
  `shipping_zip` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `total_amount` decimal(38,2) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKel9kyl84ego2otj2accfd8mr7` (`user_id`),
  CONSTRAINT `FKel9kyl84ego2otj2accfd8mr7` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,'2025-02-01 22:18:03.824209','CASH_ON_DELIVERY','No.75,polduwa,dargatown','Dargatown',200.00,'Dilshan','colonne','1280','COMPLETED',350200.00,3),(2,'2025-02-02 09:39:39.184214','CASH_ON_DELIVERY','No.75,polduwa,dargatown','Dargatown',200.00,'Dilshan','colonne','1280','COMPLETED',362800.00,3),(3,'2025-02-02 10:48:46.374274','CASH_ON_DELIVERY','No.75,polduwa,dargatown','Dargatown',200.00,'Dilshan','colonne','1280','COMPLETED',1509200.00,3);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int NOT NULL,
  `category_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKog2rp4qthbtt2lfyhfo32lsw9` (`category_id`),
  CONSTRAINT `FKog2rp4qthbtt2lfyhfo32lsw9` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'2025-02-01 20:01:15.396689','I Phone 13 Pro Brand New','uploads/products\\b15a6ddc-8c44-4498-9550-dbdbae042211_2a55045e7eacab0c5982fb5d3125ff27.jpg','I Phone 13 Pro',350000.00,19,6),(2,'2025-02-01 20:24:33.314378','Gaming Mouse For Gamers','uploads/products\\69198010-05d2-4598-bc4b-3b1f40b2880a_2cd1c37eeb0fa4adf8818bf58c71a478.jpg','Gaming Mouse',4500.00,50,5),(3,'2025-02-01 20:25:28.279800','Vr Headset brand New','uploads/products\\093c1c88-d262-412f-8719-0355b907fd41_3c10c188b14486ab45d24a86a1cf6755.jpg','Vr Headset',150000.00,15,1),(4,'2025-02-01 20:26:21.185667','Gaming Keyboard | Full Keyboard','uploads/products\\1d66cd0b-a95b-4dab-ac1e-1fc017228bc5_6fffe1bd1b0e1eecd5e9e93df376c695.jpg','Gaming Keyboard',6500.00,250,2),(5,'2025-02-01 20:27:09.833629','Hero Smart Glass Brand New','uploads/products\\dac77cc4-a08c-490d-9f49-46c58720e58f_7c26c797982020435d613eb4c5d3ce1f.jpg','Hero Smart Glass',175000.00,55,4),(6,'2025-02-01 20:28:34.285489','I7 Gaming Pc Full Pack 32 Gb RAM | 512 Nvme','uploads/products\\aa7500cc-e810-4cab-a1a5-eedc03c54872_13dd267a0c01cc38c459f1c5e29ba0ed.jpg','I7 Gaming Pc Full Pack',450000.00,10,9),(7,'2025-02-01 20:29:43.712784','Apple Headset Air Brand New','uploads/products\\9be7468d-d78f-40e9-948f-62763c5ec2bc_68f9a5bb3eabfae2d16bbe993b0cc92b.jpg','Apple Headset Air',55000.00,65,3),(8,'2025-02-01 20:30:53.258294','Google Pixel 9 Pro Brand New Devices','uploads/products\\e5891614-e93a-459b-8c8b-978ceda14d6b_74b01c530b6eb077f52d2c641bd82fd0.jpg','Google Pixel 9 Pro',399000.00,0,10),(9,'2025-02-01 20:32:56.271469','AsRock Graphic Card Brand New Condition','uploads/products\\6af5d633-af0b-42de-adf3-6c8c06ecf846_87acbfe9df1ff16e2a8a68a33cf61c48.jpg','AsRock Graphic Card',409000.00,15,8),(10,'2025-02-01 20:34:09.727811','Apple Vision  Pro Brand New','uploads/products\\0f754fdc-5f7b-496f-b1d9-d6b1a4aa376a_122a8e43a104e0165de51fe8e0b92a4a.jpg','Apple Vision  Pro',190000.00,25,1),(11,'2025-02-01 20:35:01.940995','Beats Studio Wireless','uploads/products\\7bbbcd14-626d-48bf-af47-189a12340a3e_738d2543203c4d2a12a02ae33abdae69.jpg','Beats Studio',10500.00,250,3),(12,'2025-02-01 20:36:31.549992','Gaming Pc Rysen 7 | 64 Gb Ram | 1 Tb Nvme','uploads/products\\172dd860-34d9-4b90-86ae-d070c6f2c0b7_4516c705b6e8ebdbf4f828f22b98c575.jpg','Gaming Pc',559000.00,5,9),(13,'2025-02-01 20:37:27.839490','Gaming Pc Rysen 9 | 128 Gb Ram | 1 Tb Nvme','uploads/products\\2727430b-da3a-4496-b94c-132cc8ede31b_5779e6d7995b04e74f7546400b429660.jpg','Gaming Pc',699000.00,4,9),(14,'2025-02-01 20:38:31.291649','Meta Quest By Facebook','uploads/products\\d8775038-ea8b-4261-b20a-ff639896674b_6246c74e3d7d9f2a4d298f911aad9dcf.jpg','Meta Quest',255000.00,12,1),(15,'2025-02-01 20:39:33.799239','Gaming Mouse Jedel Low Budget','uploads/products\\2014c6b0-5a06-45da-b33c-08da9f23fbc4_9343ae86a21e6cb3c667fd13d7232281.jpg','Gaming Mouse Jedel',2000.00,450,5),(16,'2025-02-01 20:40:31.812925','GigaByte Graphic Card ','uploads/products\\8e0033a0-6dc3-464e-97d9-411523b17c84_106860469d079c049532451c3302d6f9.jpg','Graphics Cards',450000.00,16,8),(17,'2025-02-01 20:41:54.882420','Gaming Pc Rysen 3 | 8 Gb Ram | 256 Gb Nvme','uploads/products\\b6b1edc0-bf76-4abc-bb8c-3f6c4362f6d5_b0b8978e0b3e3ed978322d426f796d70.jpg','Gaming Pc',250000.00,5,9),(18,'2025-02-01 20:43:01.447879','Gaming Mouse Asus','uploads/products\\58808f12-7ec7-40e6-b6c4-a04ed4102104_bb31c26fcffdf72b62c5895e96d42b7a.jpg','Gaming Mouse',2000.00,199,5),(19,'2025-02-01 20:43:54.708416','I phone 15 pro Brand New','uploads/products\\c55f32da-0370-4432-ad53-6294c6000755_cb2ad0bbc24149758f88797d22b54ab7.jpg','I phone 15 pro',405000.00,13,6),(20,'2025-02-01 20:44:42.795465','Gaming Keyboard Jedel','uploads/products\\623e3f5e-407d-4549-96d1-942a715da174_e85eef47b93ed18ea6a2e38e975f3ecf.jpg','Gaming Keyboard',2600.00,51,2),(21,'2025-02-01 20:45:31.914008','Samsung S25 Ultra Brand New','uploads/products\\8ec785b0-c157-451c-9830-28654718857b_e06936903e3f4f471a16d1dfb0e37455.jpg','Samsung S25 Ultra',358000.00,55,7);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(20) NOT NULL,
  `username` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_ob8kqyqqgmefl0aco34akdtpe` (`email`),
  UNIQUE KEY `UK_sb8bbouer5wak8vyiiy4pf2bx` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'2025-02-01 20:01:15.115757','admin@novoxia.com','Admin','User','$2a$10$DvWlGgoisYbwa2H6fF9Liel6LxyyzZ4.yy2fVYiDPAnd8.ppEhXIS','ADMIN','admin'),(3,'2025-02-01 20:13:32.120968','dilshancolonne123@gmail.com','Dilshan','colonne','$2a$10$JssIQx2xyLmsjLTFSMGNI.582N1lPOaEBEivD9wC/ra7tu17F8BZi','CUSTOMER','chamath'),(4,'2025-02-01 20:48:03.244175','Amandi@gmail.com','Amandi','Kalpani','$2a$10$cJ4nLHCWCi0DwO8xzXCMkeDLpzJiz29Zb3Allq2jyfdNhBaQKroAC','ADMIN','Amandi');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'ecommerce'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-02-08 20:55:52
