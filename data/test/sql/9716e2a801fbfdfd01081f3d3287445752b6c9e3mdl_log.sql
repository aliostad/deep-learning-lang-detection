-- MySQL dump 10.13  Distrib 5.5.29, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: moodle
-- ------------------------------------------------------
-- Server version	5.5.29-0ubuntu0.12.04.2

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
-- Table structure for table `mdl_log`
--

DROP TABLE IF EXISTS `mdl_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mdl_log` (
  `id` bigint(10) NOT NULL AUTO_INCREMENT,
  `time` bigint(10) NOT NULL DEFAULT '0',
  `userid` bigint(10) NOT NULL DEFAULT '0',
  `ip` varchar(45) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `course` bigint(10) NOT NULL DEFAULT '0',
  `module` varchar(20) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `cmid` bigint(10) NOT NULL DEFAULT '0',
  `action` varchar(40) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `url` varchar(100) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `info` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `mdl_log_coumodact_ix` (`course`,`module`,`action`),
  KEY `mdl_log_tim_ix` (`time`),
  KEY `mdl_log_act_ix` (`action`),
  KEY `mdl_log_usecou_ix` (`userid`,`course`),
  KEY `mdl_log_cmi_ix` (`cmid`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Every action is logged as far as possible';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mdl_log`
--

LOCK TABLES `mdl_log` WRITE;
/*!40000 ALTER TABLE `mdl_log` DISABLE KEYS */;
INSERT INTO `mdl_log` VALUES (1,1366473603,2,'127.0.0.1',1,'user',0,'login','view.php?id=0&course=1','2'),(2,1366473716,2,'127.0.0.1',1,'user',0,'update','view.php?id=2&course=1',''),(3,1366473756,2,'127.0.0.1',1,'user',0,'logout','view.php?id=2&course=1','2'),(4,1366474262,2,'127.0.0.1',1,'user',0,'login','view.php?id=0&course=1','2'),(5,1366474265,2,'127.0.0.1',1,'course',0,'view','view.php?id=1','1'),(6,1366474351,2,'127.0.0.1',1,'course',0,'view','view.php?id=1','1'),(7,1366474389,2,'127.0.0.1',1,'course',0,'new','view.php?id=2','First course (ID 2)'),(8,1366474462,2,'127.0.0.1',2,'course',0,'view','view.php?id=2','2'),(9,1366474471,2,'127.0.0.1',2,'course',0,'view','view.php?id=2','2'),(10,1366474471,2,'127.0.0.1',2,'course',0,'view','view.php?id=2','2'),(11,1366474530,2,'127.0.0.1',1,'user',0,'logout','view.php?id=2&course=1','2'),(12,1366475200,2,'127.0.0.1',1,'user',0,'login','view.php?id=0&course=1','2'),(13,1366475201,2,'127.0.0.1',1,'course',0,'view','view.php?id=1','1'),(14,1366475241,2,'127.0.0.1',1,'course',0,'view','view.php?id=1','1'),(15,1366475245,2,'127.0.0.1',2,'course',0,'view','view.php?id=2','2'),(16,1366475252,2,'127.0.0.1',2,'course',0,'view','view.php?id=2','2'),(17,1366475253,2,'127.0.0.1',2,'course',0,'view','view.php?id=2','2'),(18,1366475274,2,'127.0.0.1',1,'user',0,'logout','view.php?id=2&course=1','2'),(19,1366476591,2,'127.0.0.1',1,'user',0,'login','view.php?id=0&course=1','2'),(20,1366476592,2,'127.0.0.1',1,'course',0,'view','view.php?id=1','1'),(21,1366476677,2,'127.0.0.1',1,'course',0,'view','view.php?id=1','1'),(22,1366476682,2,'127.0.0.1',2,'course',0,'view','view.php?id=2','2'),(23,1366476692,2,'127.0.0.1',2,'course',0,'view','view.php?id=2','2'),(24,1366476692,2,'127.0.0.1',2,'course',0,'view','view.php?id=2','2'),(25,1366476742,2,'127.0.0.1',2,'course',0,'view','view.php?id=2','2'),(26,1366476743,2,'127.0.0.1',2,'course',0,'view','view.php?id=2','2'),(27,1366554631,2,'127.0.0.1',1,'user',0,'login','view.php?id=0&course=1','2'),(28,1366554634,2,'127.0.0.1',1,'course',0,'view','view.php?id=1','1'),(29,1366554648,2,'127.0.0.1',1,'course',0,'view','view.php?id=1','1'),(30,1366556496,2,'127.0.0.1',3,'course',0,'view','view.php?id=3','3'),(31,1366556729,2,'127.0.0.1',3,'quiz',14,'view','view.php?id=14','1'),(32,1366556751,2,'127.0.0.1',3,'quiz',14,'preview','view.php?id=14','1'),(33,1366556753,2,'127.0.0.1',3,'quiz',14,'continue attempt','review.php?attempt=1','1'),(34,1366556949,2,'127.0.0.1',3,'quiz',14,'view summary','summary.php?attempt=1','1'),(35,1366556972,2,'127.0.0.1',3,'quiz',14,'preview','view.php?id=14','1'),(36,1366556973,2,'127.0.0.1',3,'quiz',14,'continue attempt','review.php?attempt=2','1'),(37,1366556982,2,'127.0.0.1',3,'course',0,'view','view.php?id=3','3'),(38,1366559153,2,'127.0.0.1',1,'course',0,'view','view.php?id=1','1'),(39,1366566672,2,'127.0.0.1',1,'user',0,'login','view.php?id=0&course=1','2'),(40,1366566673,2,'127.0.0.1',1,'course',0,'view','view.php?id=1','1'),(41,1366566744,2,'127.0.0.1',1,'course',0,'view','view.php?id=1','1'),(42,1366566752,2,'127.0.0.1',2,'course',0,'view','view.php?id=2','2'),(43,1366566763,2,'127.0.0.1',2,'course',0,'view','view.php?id=2','2'),(44,1366566763,2,'127.0.0.1',2,'course',0,'view','view.php?id=2','2'),(45,1366566966,2,'127.0.0.1',1,'user',0,'logout','view.php?id=2&course=1','2'),(46,1366736779,2,'127.0.0.1',1,'user',0,'login','view.php?id=0&course=1','2'),(47,1366736782,2,'127.0.0.1',1,'course',0,'view','view.php?id=1','1'),(48,1366736794,2,'127.0.0.1',1,'course',0,'view','view.php?id=1','1'),(49,1366736811,2,'127.0.0.1',1,'course',0,'view','view.php?id=1','1'),(50,1366736867,2,'127.0.0.1',1,'course',0,'new','view.php?id=4','Second Course (ID 4)'),(51,1366736899,2,'127.0.0.1',1,'user',0,'logout','view.php?id=2&course=1','2');
/*!40000 ALTER TABLE `mdl_log` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-04-24  7:46:22
