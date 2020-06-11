# ************************************************************
# Sequel Pro SQL dump
# Version 3408
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: 127.0.0.1 (MySQL 5.5.9)
# Database: magicstuff
# Generation Time: 2012-07-13 16:04:43 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table nav
# ------------------------------------------------------------

DROP TABLE IF EXISTS `nav`;

CREATE TABLE `nav` (
  `nav_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `nav_url_link` varchar(120) DEFAULT NULL,
  `nav_url_name` varchar(25) DEFAULT NULL,
  `date_uploaded` datetime DEFAULT NULL,
  `nav_enable` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`nav_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `nav` WRITE;
/*!40000 ALTER TABLE `nav` DISABLE KEYS */;

INSERT INTO `nav` (`nav_id`, `nav_url_link`, `nav_url_name`, `date_uploaded`, `nav_enable`)
VALUES
	(1,'bio','STUFF\'S Bio','2012-07-12 00:00:00',1),
	(2,'photo','Photos','2012-07-12 00:00:00',1),
	(3,'viedo','Videos','2012-07-12 00:00:00',1),
	(4,'book','Book STUFF!','2012-07-12 00:00:00',1),
	(5,'13b413','13 Before 13','2012-07-12 00:00:00',1),
	(6,'school','STUFF\'S School Show','2012-07-12 00:00:00',1),
	(7,'fb','Face Book','2012-07-12 00:00:00',1),
	(8,'twitter','Twiter','2012-07-12 00:00:00',1);

/*!40000 ALTER TABLE `nav` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
