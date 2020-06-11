-- MySQL dump 10.13  Distrib 5.5.16, for Win32 (x86)
--
-- Host: localhost    Database: wskoicen_csm
-- ------------------------------------------------------
-- Server version	5.5.16

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
-- Table structure for table `gallery`
--

DROP TABLE IF EXISTS `gallery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gallery` (
  `idgallery` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `filename` text NOT NULL,
  `idgallery_cat` int(10) unsigned NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`idgallery`),
  KEY `FK_gallery_1` (`idgallery_cat`),
  CONSTRAINT `FK_gallery_1` FOREIGN KEY (`idgallery_cat`) REFERENCES `gallery_cat` (`idgallery_cat`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gallery`
--

LOCK TABLES `gallery` WRITE;
/*!40000 ALTER TABLE `gallery` DISABLE KEYS */;
INSERT INTO `gallery` VALUES (10,'Cereal','cereal-guy2.jpg',1,'Cereal'),(11,'Obama Not Bad','notbad.jpg',1,'Obama');
/*!40000 ALTER TABLE `gallery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gallery_cat`
--

DROP TABLE IF EXISTS `gallery_cat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gallery_cat` (
  `idgallery_cat` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category` varchar(45) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`idgallery_cat`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gallery_cat`
--

LOCK TABLES `gallery_cat` WRITE;
/*!40000 ALTER TABLE `gallery_cat` DISABLE KEYS */;
INSERT INTO `gallery_cat` VALUES (1,'Ikan Koi','Koleksi Ikan Koi');
/*!40000 ALTER TABLE `gallery_cat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `layout`
--

DROP TABLE IF EXISTS `layout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `layout` (
  `idlayout` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `theme` varchar(30) NOT NULL,
  `header` varchar(200) NOT NULL,
  `title` varchar(200) NOT NULL,
  `firstpage` varchar(45) NOT NULL,
  PRIMARY KEY (`idlayout`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `layout`
--

LOCK TABLES `layout` WRITE;
/*!40000 ALTER TABLE `layout` DISABLE KEYS */;
INSERT INTO `layout` VALUES (1,'bluegreen','header.png','WS Koi Center','layanan');
/*!40000 ALTER TABLE `layout` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `links`
--

DROP TABLE IF EXISTS `links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `links` (
  `idlinks` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(300) NOT NULL,
  PRIMARY KEY (`idlinks`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `links`
--

LOCK TABLES `links` WRITE;
/*!40000 ALTER TABLE `links` DISABLE KEYS */;
INSERT INTO `links` VALUES (1,'http://jakartakoicentre.com'),(2,'http://samuraikoi.com'),(3,'http://misterkoi.com');
/*!40000 ALTER TABLE `links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `page`
--

DROP TABLE IF EXISTS `page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `page` (
  `title` varchar(40) NOT NULL,
  `content` text NOT NULL,
  PRIMARY KEY (`title`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `page`
--

LOCK TABLES `page` WRITE;
/*!40000 ALTER TABLE `page` DISABLE KEYS */;
INSERT INTO `page` VALUES ('About','Apa yang kami lakukan'),('Gallery','Disini Anda dapat mengikuti stock ikankami'),('Home','<p align=\"justify\">WS Koi Center merupakan penangkaran ikan koi yang tidak hanya menyediakan pelayanan penangkaran ikan koi, namun juga menyediakan jasa pembuatan taman yang akan memperindah kolam ikan Koi Anda.\r\nBerlokasi di daerah Imogiri yang terkenal dengan keasrian alam dan airnya, menyebabkan ikan koi yang kami budidayakan dapat berkembang dengan baik.<br/>\r\n<br/>\r\nAnda dapat menggunakan website ini untuk mendapatkan informasi tentang jenis-jenis layanan ikan koi dan pembuatan taman yang kami sediakan.<br/>\r\nTerimakasih</p>'),('Kontak','Lokasi penangkaran ikan kami berada di alamat Jl. Imogiri Timur KM 10, Ketonggo, Wonokromo.<br/>\r\nGunakan panduan denah di bawah ini untuk menemukan alamat tersebut:<br/>\r\n<br/>\r\n<img src=\"http://localhost/genicms/images/alamat.png\">'),('Layanan','Layanan WS Koi terdiri dari :<br/>\r\n<ul>\r\n<li>Membuat kolam ikan </li>\r\n<li>Membuat taman</li>\r\n</ul>');
/*!40000 ALTER TABLE `page` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `theme`
--

DROP TABLE IF EXISTS `theme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `theme` (
  `name` varchar(45) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `theme`
--

LOCK TABLES `theme` WRITE;
/*!40000 ALTER TABLE `theme` DISABLE KEYS */;
INSERT INTO `theme` VALUES ('bluegreen','Blue Green themes'),('plain','Empty themes, to start the design with');
/*!40000 ALTER TABLE `theme` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `top_nav`
--

DROP TABLE IF EXISTS `top_nav`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `top_nav` (
  `idtop_nav` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(45) NOT NULL,
  `linkto` varchar(100) NOT NULL,
  `ordernum` int(10) unsigned NOT NULL,
  `type` enum('Page','Url','Custom') NOT NULL,
  PRIMARY KEY (`idtop_nav`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `top_nav`
--

LOCK TABLES `top_nav` WRITE;
/*!40000 ALTER TABLE `top_nav` DISABLE KEYS */;
INSERT INTO `top_nav` VALUES (2,'Gallery','gallery',2,'Custom'),(5,'Layanan','Layanan',1,'Page');
/*!40000 ALTER TABLE `top_nav` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-02-19 18:56:40
