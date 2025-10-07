-- MySQL dump 10.13  Distrib 9.4.0, for macos15 (arm64)
--
-- Host: localhost    Database: bento_pos
-- ------------------------------------------------------
-- Server version	9.4.0

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
-- Table structure for table `CUSTOMER`
--

DROP TABLE IF EXISTS `CUSTOMER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CUSTOMER` (
  `customer_id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_ref` int unsigned NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `street` varchar(50) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `state_code` char(2) DEFAULT NULL,
  `zipcode` char(5) DEFAULT NULL,
  `phone_number` varchar(12) DEFAULT NULL,
  `refunds_per_month` tinyint unsigned DEFAULT NULL,
  `loyalty_points` int unsigned DEFAULT NULL,
  `total_amount_spent` int unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `last_updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `user_ref` (`user_ref`),
  CONSTRAINT `customer_ibfk_1` FOREIGN KEY (`user_ref`) REFERENCES `USER_ACCOUNT` (`user_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CUSTOMER`
--

LOCK TABLES `CUSTOMER` WRITE;
/*!40000 ALTER TABLE `CUSTOMER` DISABLE KEYS */;
/*!40000 ALTER TABLE `CUSTOMER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MEAL`
--

DROP TABLE IF EXISTS `MEAL`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MEAL` (
  `meal_id` int unsigned NOT NULL AUTO_INCREMENT,
  `meal_name` varchar(50) NOT NULL,
  `meal_description` varchar(255) NOT NULL,
  `meal_status` tinyint(1) NOT NULL,
  `nutrition_facts` json NOT NULL,
  `times_refunded` int unsigned DEFAULT '0',
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `created_by` int unsigned NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_by` int unsigned DEFAULT NULL,
  `last_updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `price` int unsigned NOT NULL,
  `cost_to_make` int unsigned NOT NULL,
  PRIMARY KEY (`meal_id`),
  KEY `created_by` (`created_by`),
  KEY `updated_by` (`updated_by`),
  CONSTRAINT `meal_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `STAFF` (`staff_id`) ON DELETE RESTRICT,
  CONSTRAINT `meal_ibfk_2` FOREIGN KEY (`updated_by`) REFERENCES `STAFF` (`staff_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MEAL`
--

LOCK TABLES `MEAL` WRITE;
/*!40000 ALTER TABLE `MEAL` DISABLE KEYS */;
/*!40000 ALTER TABLE `MEAL` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MEAL_SALE`
--

DROP TABLE IF EXISTS `MEAL_SALE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MEAL_SALE` (
  `meal_ref` int unsigned NOT NULL,
  `sale_event_ref` int unsigned NOT NULL,
  `discount_rate` decimal(4,2) NOT NULL,
  PRIMARY KEY (`meal_ref`,`sale_event_ref`),
  KEY `sale_event_ref` (`sale_event_ref`),
  CONSTRAINT `meal_sale_ibfk_1` FOREIGN KEY (`meal_ref`) REFERENCES `MEAL` (`meal_id`) ON DELETE CASCADE,
  CONSTRAINT `meal_sale_ibfk_2` FOREIGN KEY (`sale_event_ref`) REFERENCES `SALE_EVENT` (`sale_event_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MEAL_SALE`
--

LOCK TABLES `MEAL_SALE` WRITE;
/*!40000 ALTER TABLE `MEAL_SALE` DISABLE KEYS */;
/*!40000 ALTER TABLE `MEAL_SALE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MEAL_TYPE`
--

DROP TABLE IF EXISTS `MEAL_TYPE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MEAL_TYPE` (
  `meal_type_id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `meal_type` varchar(50) NOT NULL,
  PRIMARY KEY (`meal_type_id`),
  UNIQUE KEY `meal_type` (`meal_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MEAL_TYPE`
--

LOCK TABLES `MEAL_TYPE` WRITE;
/*!40000 ALTER TABLE `MEAL_TYPE` DISABLE KEYS */;
/*!40000 ALTER TABLE `MEAL_TYPE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MEAL_TYPE_LINK`
--

DROP TABLE IF EXISTS `MEAL_TYPE_LINK`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MEAL_TYPE_LINK` (
  `meal_ref` int unsigned NOT NULL,
  `meal_type_ref` tinyint unsigned NOT NULL,
  PRIMARY KEY (`meal_ref`,`meal_type_ref`),
  KEY `meal_type_ref` (`meal_type_ref`),
  CONSTRAINT `meal_type_link_ibfk_1` FOREIGN KEY (`meal_ref`) REFERENCES `MEAL` (`meal_id`) ON DELETE CASCADE,
  CONSTRAINT `meal_type_link_ibfk_2` FOREIGN KEY (`meal_type_ref`) REFERENCES `MEAL_TYPE` (`meal_type_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MEAL_TYPE_LINK`
--

LOCK TABLES `MEAL_TYPE_LINK` WRITE;
/*!40000 ALTER TABLE `MEAL_TYPE_LINK` DISABLE KEYS */;
/*!40000 ALTER TABLE `MEAL_TYPE_LINK` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ORDER_LINE`
--

DROP TABLE IF EXISTS `ORDER_LINE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ORDER_LINE` (
  `order_ref` int unsigned NOT NULL,
  `meal_ref` int unsigned NOT NULL,
  `num_units_ordered` int unsigned NOT NULL,
  `price_at_sale` int unsigned NOT NULL,
  `cost_per_unit` int unsigned NOT NULL,
  PRIMARY KEY (`order_ref`,`meal_ref`),
  KEY `meal_ref` (`meal_ref`),
  CONSTRAINT `order_line_ibfk_1` FOREIGN KEY (`order_ref`) REFERENCES `ORDERS` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `order_line_ibfk_2` FOREIGN KEY (`meal_ref`) REFERENCES `MEAL` (`meal_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ORDER_LINE`
--

LOCK TABLES `ORDER_LINE` WRITE;
/*!40000 ALTER TABLE `ORDER_LINE` DISABLE KEYS */;
/*!40000 ALTER TABLE `ORDER_LINE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ORDER_PROMOTION`
--

DROP TABLE IF EXISTS `ORDER_PROMOTION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ORDER_PROMOTION` (
  `order_ref` int unsigned NOT NULL,
  `promotion_ref` int unsigned NOT NULL,
  `discount_amount` int unsigned NOT NULL,
  PRIMARY KEY (`order_ref`,`promotion_ref`),
  KEY `promotion_ref` (`promotion_ref`),
  CONSTRAINT `order_promotion_ibfk_1` FOREIGN KEY (`order_ref`) REFERENCES `ORDERS` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `order_promotion_ibfk_2` FOREIGN KEY (`promotion_ref`) REFERENCES `PROMOTION` (`promotion_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ORDER_PROMOTION`
--

LOCK TABLES `ORDER_PROMOTION` WRITE;
/*!40000 ALTER TABLE `ORDER_PROMOTION` DISABLE KEYS */;
/*!40000 ALTER TABLE `ORDER_PROMOTION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ORDERS`
--

DROP TABLE IF EXISTS `ORDERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ORDERS` (
  `order_id` int unsigned NOT NULL AUTO_INCREMENT,
  `customer_ref` int unsigned NOT NULL,
  `order_date` date NOT NULL,
  `order_status` tinyint DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `unit_price` int NOT NULL,
  `tax` int NOT NULL,
  `discount` int DEFAULT '0',
  `notes` varchar(255) DEFAULT NULL,
  `refund_message` varchar(255) DEFAULT NULL,
  `shipping_street` varchar(50) DEFAULT NULL,
  `shipping_city` varchar(50) DEFAULT NULL,
  `shipping_state_code` char(2) DEFAULT NULL,
  `shipping_zipcode` char(5) DEFAULT NULL,
  `created_by` int unsigned NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_by_staff` int unsigned DEFAULT NULL,
  `updated_by_customer` int unsigned DEFAULT NULL,
  `last_updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `tracking_number` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `customer_ref` (`customer_ref`),
  KEY `created_by` (`created_by`),
  KEY `updated_by_staff` (`updated_by_staff`),
  KEY `updated_by_customer` (`updated_by_customer`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customer_ref`) REFERENCES `CUSTOMER` (`customer_id`) ON DELETE RESTRICT,
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `STAFF` (`staff_id`) ON DELETE RESTRICT,
  CONSTRAINT `orders_ibfk_3` FOREIGN KEY (`updated_by_staff`) REFERENCES `STAFF` (`staff_id`) ON DELETE SET NULL,
  CONSTRAINT `orders_ibfk_4` FOREIGN KEY (`updated_by_customer`) REFERENCES `CUSTOMER` (`customer_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ORDERS`
--

LOCK TABLES `ORDERS` WRITE;
/*!40000 ALTER TABLE `ORDERS` DISABLE KEYS */;
/*!40000 ALTER TABLE `ORDERS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PAYMENT`
--

DROP TABLE IF EXISTS `PAYMENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PAYMENT` (
  `payment_id` int unsigned NOT NULL AUTO_INCREMENT,
  `order_ref` int unsigned NOT NULL,
  `payment_method_ref` int unsigned NOT NULL,
  `payment_amount` int unsigned NOT NULL,
  `payment_datetime` datetime DEFAULT CURRENT_TIMESTAMP,
  `transaction_status` tinyint unsigned NOT NULL,
  `created_by` int unsigned NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_by` int unsigned DEFAULT NULL,
  `last_updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  UNIQUE KEY `order_ref` (`order_ref`),
  KEY `payment_method_ref` (`payment_method_ref`),
  KEY `created_by` (`created_by`),
  KEY `updated_by` (`updated_by`),
  CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`order_ref`) REFERENCES `ORDERS` (`order_id`) ON DELETE RESTRICT,
  CONSTRAINT `payment_ibfk_2` FOREIGN KEY (`payment_method_ref`) REFERENCES `PAYMENT_METHOD` (`payment_method_id`) ON DELETE RESTRICT,
  CONSTRAINT `payment_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `STAFF` (`staff_id`) ON DELETE RESTRICT,
  CONSTRAINT `payment_ibfk_4` FOREIGN KEY (`updated_by`) REFERENCES `STAFF` (`staff_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PAYMENT`
--

LOCK TABLES `PAYMENT` WRITE;
/*!40000 ALTER TABLE `PAYMENT` DISABLE KEYS */;
/*!40000 ALTER TABLE `PAYMENT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PAYMENT_METHOD`
--

DROP TABLE IF EXISTS `PAYMENT_METHOD`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PAYMENT_METHOD` (
  `payment_method_id` int unsigned NOT NULL AUTO_INCREMENT,
  `customer_ref` int unsigned NOT NULL,
  `payment_type` tinyint unsigned NOT NULL,
  `last_four` char(4) DEFAULT NULL,
  `exp_date` char(5) DEFAULT NULL,
  `billing_street` varchar(50) NOT NULL,
  `billing_city` varchar(50) NOT NULL,
  `billing_state_code` char(2) NOT NULL,
  `billing_zipcode` char(5) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `middle_init` char(1) DEFAULT NULL,
  `last_name` varchar(50) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `last_updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_method_id`),
  KEY `customer_ref` (`customer_ref`),
  CONSTRAINT `payment_method_ibfk_1` FOREIGN KEY (`customer_ref`) REFERENCES `CUSTOMER` (`customer_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PAYMENT_METHOD`
--

LOCK TABLES `PAYMENT_METHOD` WRITE;
/*!40000 ALTER TABLE `PAYMENT_METHOD` DISABLE KEYS */;
/*!40000 ALTER TABLE `PAYMENT_METHOD` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PROMOTION`
--

DROP TABLE IF EXISTS `PROMOTION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PROMOTION` (
  `promotion_id` int unsigned NOT NULL AUTO_INCREMENT,
  `promo_description` varchar(255) NOT NULL,
  `promo_type` tinyint unsigned NOT NULL,
  `promo_code` varchar(50) NOT NULL,
  `promo_exp_date` date NOT NULL,
  `created_by` int unsigned NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_by` int unsigned DEFAULT NULL,
  `last_updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`promotion_id`),
  UNIQUE KEY `promo_code` (`promo_code`),
  KEY `created_by` (`created_by`),
  KEY `updated_by` (`updated_by`),
  CONSTRAINT `promotion_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `STAFF` (`staff_id`) ON DELETE RESTRICT,
  CONSTRAINT `promotion_ibfk_2` FOREIGN KEY (`updated_by`) REFERENCES `STAFF` (`staff_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PROMOTION`
--

LOCK TABLES `PROMOTION` WRITE;
/*!40000 ALTER TABLE `PROMOTION` DISABLE KEYS */;
/*!40000 ALTER TABLE `PROMOTION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REVIEWS`
--

DROP TABLE IF EXISTS `REVIEWS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REVIEWS` (
  `customer_ref` int unsigned NOT NULL,
  `meal_ref` int unsigned NOT NULL,
  `stars` tinyint unsigned NOT NULL,
  `user_comment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`customer_ref`,`meal_ref`),
  KEY `meal_ref` (`meal_ref`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`customer_ref`) REFERENCES `CUSTOMER` (`customer_id`) ON DELETE RESTRICT,
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`meal_ref`) REFERENCES `MEAL` (`meal_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REVIEWS`
--

LOCK TABLES `REVIEWS` WRITE;
/*!40000 ALTER TABLE `REVIEWS` DISABLE KEYS */;
/*!40000 ALTER TABLE `REVIEWS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SALE_EVENT`
--

DROP TABLE IF EXISTS `SALE_EVENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SALE_EVENT` (
  `sale_event_id` int unsigned NOT NULL AUTO_INCREMENT,
  `event_name` varchar(50) NOT NULL,
  `event_description` varchar(255) NOT NULL,
  `event_start` date NOT NULL,
  `event_end` date NOT NULL,
  `sitewide_promo_type` tinyint unsigned DEFAULT NULL,
  `sitewide_discount_value` decimal(4,2) DEFAULT NULL,
  `created_by` int unsigned NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_by` int unsigned DEFAULT NULL,
  `last_updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`sale_event_id`),
  KEY `created_by` (`created_by`),
  KEY `updated_by` (`updated_by`),
  CONSTRAINT `sale_event_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `STAFF` (`staff_id`) ON DELETE RESTRICT,
  CONSTRAINT `sale_event_ibfk_2` FOREIGN KEY (`updated_by`) REFERENCES `STAFF` (`staff_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SALE_EVENT`
--

LOCK TABLES `SALE_EVENT` WRITE;
/*!40000 ALTER TABLE `SALE_EVENT` DISABLE KEYS */;
/*!40000 ALTER TABLE `SALE_EVENT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `STAFF`
--

DROP TABLE IF EXISTS `STAFF`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `STAFF` (
  `staff_id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_ref` int unsigned NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `phone_number` varchar(12) NOT NULL,
  `hire_date` date NOT NULL,
  `salary` int unsigned NOT NULL,
  `created_by` int unsigned NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_by` int unsigned DEFAULT NULL,
  `last_updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`staff_id`),
  UNIQUE KEY `user_ref` (`user_ref`),
  KEY `created_by` (`created_by`),
  KEY `updated_by` (`updated_by`),
  CONSTRAINT `staff_ibfk_1` FOREIGN KEY (`user_ref`) REFERENCES `USER_ACCOUNT` (`user_id`) ON DELETE RESTRICT,
  CONSTRAINT `staff_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `STAFF` (`staff_id`) ON DELETE RESTRICT,
  CONSTRAINT `staff_ibfk_3` FOREIGN KEY (`updated_by`) REFERENCES `STAFF` (`staff_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `STAFF`
--

LOCK TABLES `STAFF` WRITE;
/*!40000 ALTER TABLE `STAFF` DISABLE KEYS */;
/*!40000 ALTER TABLE `STAFF` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `STOCK`
--

DROP TABLE IF EXISTS `STOCK`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `STOCK` (
  `stock_id` int unsigned NOT NULL AUTO_INCREMENT,
  `meal_ref` int unsigned NOT NULL,
  `quantity_in_stock` int unsigned NOT NULL,
  `reorder_threshold` int unsigned NOT NULL,
  `needs_reorder` tinyint(1) NOT NULL,
  `last_restock` date DEFAULT NULL,
  `stock_fulfillment_time` tinyint unsigned NOT NULL,
  `created_by` int unsigned NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_by` int unsigned DEFAULT NULL,
  `last_updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`stock_id`),
  KEY `meal_ref` (`meal_ref`),
  KEY `created_by` (`created_by`),
  KEY `updated_by` (`updated_by`),
  CONSTRAINT `stock_ibfk_1` FOREIGN KEY (`meal_ref`) REFERENCES `MEAL` (`meal_id`) ON DELETE CASCADE,
  CONSTRAINT `stock_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `STAFF` (`staff_id`) ON DELETE RESTRICT,
  CONSTRAINT `stock_ibfk_3` FOREIGN KEY (`updated_by`) REFERENCES `STAFF` (`staff_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `STOCK`
--

LOCK TABLES `STOCK` WRITE;
/*!40000 ALTER TABLE `STOCK` DISABLE KEYS */;
/*!40000 ALTER TABLE `STOCK` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_ACCOUNT`
--

DROP TABLE IF EXISTS `USER_ACCOUNT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_ACCOUNT` (
  `user_id` int unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `user_password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `user_role` smallint NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `last_updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_ACCOUNT`
--

LOCK TABLES `USER_ACCOUNT` WRITE;
/*!40000 ALTER TABLE `USER_ACCOUNT` DISABLE KEYS */;
/*!40000 ALTER TABLE `USER_ACCOUNT` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-06 23:26:35
