-- MySQL dump 10.13  Distrib 5.1.31, for apple-darwin9.5.0 (i386)
--
-- Host: localhost    Database: parselets_com_development
-- ------------------------------------------------------
-- Server version	5.1.31

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `domain_usages`
--

DROP TABLE IF EXISTS `domain_usages`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `domain_usages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain_id` int(11) DEFAULT NULL,
  `usage_type` varchar(255) DEFAULT NULL,
  `usage_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `domain_usages`
--

LOCK TABLES `domain_usages` WRITE;
/*!40000 ALTER TABLE `domain_usages` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_usages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domains`
--

DROP TABLE IF EXISTS `domains`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `domains` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `variations` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `domains`
--

LOCK TABLES `domains` WRITE;
/*!40000 ALTER TABLE `domains` DISABLE KEYS */;
INSERT INTO `domains` VALUES (1,'www.kylemaxwell.com',' www www www.www kylemaxwell www.kylemaxwell www.kylemaxwell www.www.kylemaxwell com www.com www.com www.www.com kylemaxwell.com www.kylemaxwell.com www.kylemaxwell.com www.www.kylemaxwell.com','2009-02-16 00:59:10','2009-02-16 00:59:10'),(2,'www.yelp.com',' www www www.www yelp www.yelp www.yelp www.www.yelp com www.com www.com www.www.com yelp.com www.yelp.com www.yelp.com www.www.yelp.com','2009-02-19 04:22:11','2009-02-19 04:22:11');
/*!40000 ALTER TABLE `domains` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parselet_versions`
--

DROP TABLE IF EXISTS `parselet_versions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `parselet_versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parselet_id` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `code` text,
  `pattern` varchar(255) DEFAULT NULL,
  `example_url` varchar(255) DEFAULT NULL,
  `domain_id` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `pattern_regex` tinyint(1) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `parselet_versions`
--

LOCK TABLES `parselet_versions` WRITE;
/*!40000 ALTER TABLE `parselet_versions` DISABLE KEYS */;
INSERT INTO `parselet_versions` VALUES (2,16,1,'test','hi','{ \"title\": \"title\" }','http://www.kylemaxwell.com/','http://www.kylemaxwell.com/',NULL,1,0,NULL,'2009-02-16 00:33:05'),(3,17,1,'yelp-home','world','{\r\n	\"categories(#cat_list a)\": [{\r\n		\"text\": \".\",\r\n		\"href\": \"@href\"\r\n	}]\r\n}','http://www.yelp.com/{city?}','http://www.yelp.com/','2',1,NULL,NULL,'2009-02-19 04:22:11');
/*!40000 ALTER TABLE `parselet_versions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parselets`
--

DROP TABLE IF EXISTS `parselets`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `parselets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `code` text,
  `pattern` varchar(255) DEFAULT NULL,
  `example_url` varchar(255) DEFAULT NULL,
  `domain_id` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `parselets`
--

LOCK TABLES `parselets` WRITE;
/*!40000 ALTER TABLE `parselets` DISABLE KEYS */;
INSERT INTO `parselets` VALUES (1,'','',NULL,'','',NULL,NULL,NULL,'2009-02-16 00:28:03','2009-02-13 06:10:49','2009-02-13 06:10:49'),(2,'','',NULL,'','',NULL,NULL,NULL,'2009-02-16 00:28:07','2009-02-13 06:10:50','2009-02-13 06:10:50'),(3,'','',NULL,'','',NULL,NULL,NULL,'2009-02-16 00:28:11','2009-02-13 06:10:51','2009-02-13 06:10:51'),(4,'','',NULL,'','',NULL,NULL,NULL,'2009-02-16 00:28:10','2009-02-13 06:10:51','2009-02-13 06:10:51'),(5,'','',NULL,'','',NULL,NULL,NULL,'2009-02-16 00:28:13','2009-02-13 06:10:52','2009-02-13 06:10:52'),(6,'','',NULL,'','',NULL,NULL,NULL,'2009-02-16 00:28:15','2009-02-13 06:10:52','2009-02-13 06:10:52'),(7,'','',NULL,'','',NULL,NULL,NULL,'2009-02-16 00:28:20','2009-02-13 06:10:53','2009-02-13 06:10:53'),(8,'','',NULL,'','',NULL,NULL,NULL,'2009-02-16 00:28:22','2009-02-13 06:10:53','2009-02-13 06:10:53'),(9,'','',NULL,'','',NULL,NULL,NULL,'2009-02-16 00:28:31','2009-02-13 06:11:38','2009-02-13 06:11:38'),(10,'','',NULL,'','',NULL,NULL,NULL,'2009-02-16 00:28:28','2009-02-13 06:11:38','2009-02-13 06:11:38'),(11,'','',NULL,'','',NULL,NULL,NULL,'2009-02-16 00:28:33','2009-02-13 06:11:39','2009-02-13 06:11:39'),(12,'','',NULL,'','',NULL,NULL,NULL,'2009-02-16 00:28:30','2009-02-13 06:11:40','2009-02-13 06:11:40'),(13,'fadsfs','',NULL,'','',NULL,NULL,NULL,'2009-02-16 00:28:35','2009-02-15 22:57:20','2009-02-15 22:57:20'),(14,'','',NULL,'','',NULL,NULL,NULL,'2009-02-16 00:28:36','2009-02-15 23:13:27','2009-02-15 23:13:27'),(15,'test','hi','{ \"title\": \"title\", \"\": null }','http://www.kylemaxwell.com/','http://www.kylemaxwell.com/',NULL,1,1,'2009-02-16 00:34:34','2009-02-16 00:31:21','2009-02-16 00:31:21'),(16,'test','hi','{ \"title\": \"title\" }','http://www.kylemaxwell.com/','http://www.kylemaxwell.com/','1',1,1,NULL,'2009-02-16 00:33:05','2009-02-17 23:19:55'),(17,'yelp-home','Categories','{\r\n	\"categories(#cat_list a)\": [{\r\n		\"text\": \".\",\r\n		\"href\": \"@href\"\r\n	}]\r\n}','http://www.yelp.com/{city?}','http://www.yelp.com/','2',1,1,NULL,'2009-02-19 04:22:11','2009-02-19 04:22:11');
/*!40000 ALTER TABLE `parselets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20090209033631'),('20090209035448'),('20090209052803'),('20090209053100'),('20090209053526'),('20090216001315'),('20090216002219'),('20090216044342'),('20090219034601');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sprig_usages`
--

DROP TABLE IF EXISTS `sprig_usages`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `sprig_usages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sprig_id` int(11) DEFAULT NULL,
  `sprig_version_id` int(11) DEFAULT NULL,
  `parselet_id` int(11) DEFAULT NULL,
  `parselet_version_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `sprig_usages`
--

LOCK TABLES `sprig_usages` WRITE;
/*!40000 ALTER TABLE `sprig_usages` DISABLE KEYS */;
/*!40000 ALTER TABLE `sprig_usages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sprig_versions`
--

DROP TABLE IF EXISTS `sprig_versions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `sprig_versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sprig_id` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `code` text,
  `user_id` int(11) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `sprig_versions`
--

LOCK TABLES `sprig_versions` WRITE;
/*!40000 ALTER TABLE `sprig_versions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sprig_versions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sprigs`
--

DROP TABLE IF EXISTS `sprigs`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `sprigs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `code` text,
  `user_id` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `sprigs`
--

LOCK TABLES `sprigs` WRITE;
/*!40000 ALTER TABLE `sprigs` DISABLE KEYS */;
/*!40000 ALTER TABLE `sprigs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(40) DEFAULT NULL,
  `name` varchar(100) DEFAULT '',
  `email` varchar(100) DEFAULT NULL,
  `crypted_password` varchar(40) DEFAULT NULL,
  `salt` varchar(40) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `remember_token` varchar(40) DEFAULT NULL,
  `remember_token_expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_login` (`login`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'kyle','','kyle@kylemaxwell.com','637f1cbc5b8452514abce35fed364a6edd87e471','241a38ae16e64d267b106f5279c33447cd0a2612','2009-02-12 06:04:43','2009-02-12 06:04:43',NULL,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2009-02-19  4:23:22
