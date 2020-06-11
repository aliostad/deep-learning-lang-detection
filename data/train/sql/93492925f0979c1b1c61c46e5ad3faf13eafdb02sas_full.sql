--
-- Table structure for table `sas_main_menu`
--

DROP TABLE IF EXISTS `sas_main_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sas_main_menu` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `page` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sas_main_menu`
--

LOCK TABLES `sas_main_menu` WRITE;
/*!40000 ALTER TABLE `sas_main_menu` DISABLE KEYS */;
INSERT INTO `sas_main_menu` VALUES (1,'START','home'),(2,'MYSQL','mysql'),(3,'APACHE','apache'),(4,'POSTFIX','postfix'),(5,'FTP','ftp'),(6,'SAMBA','samba'),(7,'MANAGEMENT','management'),(8,'WEBUSER','webuser'),(9,'TOOLS','tools');
/*!40000 ALTER TABLE `sas_main_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sas_page_content`
--

DROP TABLE IF EXISTS `sas_page_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sas_page_content` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `page` varchar(255) NOT NULL,
  `spage` varchar(255) NOT NULL,
  `inc_path` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sas_page_content`
--

LOCK TABLES `sas_page_content` WRITE;
/*!40000 ALTER TABLE `sas_page_content` DISABLE KEYS */;
INSERT INTO `sas_page_content` VALUES (1,'home','','inc/home/home.inc.php'),(2,'tools','console','inc/tools/console.inc.php'),(3,'home','overview','inc/index/overview.inc.php'),(4,'home','panel','inc/index/panel.inc.php'),(5,'home','stats','inc/index/stats.inc.php'),(6,'home','doku','inc/index/doku.inc.php'),(7,'home','help','inc/index/help.inc.php'),(8,'home','about','inc/index/about.inc.php'),(9,'mysql','console','inc/mysql/sqlcmd.inc.php'),(10,'mysql','','inc/mysql/overview.inc.php'),(11,'apache','','inc/apache/overview.inc.php'),(12,'postfix','','inc/postfix/overview.inc.php'),(13,'ftp','','inc/ftp/overview.inc.php'),(14,'samba','','inc/samba/overview.inc.php'),(15,'management','','inc/management/overview.inc.php');
/*!40000 ALTER TABLE `sas_page_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sas_side_nav`
--

DROP TABLE IF EXISTS `sas_side_nav`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sas_side_nav` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `page` varchar(255) NOT NULL,
  `spage` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sas_side_nav`
--

LOCK TABLES `sas_side_nav` WRITE;
/*!40000 ALTER TABLE `sas_side_nav` DISABLE KEYS */;
INSERT INTO `sas_side_nav` VALUES (1,'Home','home',''),(2,'Konsole','tools','console'),(3,'System&uuml;bersicht','home','overview'),(4,'QuickPanel','home','panel'),(5,'Serverstatistiken','home','stats'),(6,'Dokumentation','home','doku'),(7,'Hilfe','home','help'),(8,'&Uuml;ber SAS','home','about'),(9,'Konsole','mysql','console');
/*!40000 ALTER TABLE `sas_side_nav` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sas_web_users`
--

DROP TABLE IF EXISTS `sas_web_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sas_web_users` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `userunique` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sas_web_users`
--

LOCK TABLES `sas_web_users` WRITE;
/*!40000 ALTER TABLE `sas_web_users` DISABLE KEYS */;
INSERT INTO `sas_web_users` VALUES (1,'admin','e8636ea013e682faf61f56ce1cb1ab5c','admin@admin.de'),(2,'pat','22222','test@test.de');
/*!40000 ALTER TABLE `sas_web_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL DEFAULT '',
  `password` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='latin1_swedish_ci';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
