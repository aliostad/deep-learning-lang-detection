# ************************************************************
# Sequel Pro SQL dump
# Version 4096
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: 127.0.0.1 (MySQL 5.6.21)
# Database: nested
# Generation Time: 2015-06-25 01:28:33 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table fbf_nav_items
# ------------------------------------------------------------

DROP TABLE IF EXISTS `fbf_nav_items`;

CREATE TABLE `fbf_nav_items` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `lft` int(11) DEFAULT NULL,
  `rgt` int(11) DEFAULT NULL,
  `depth` int(11) DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `uri` varchar(255) COLLATE utf8_unicode_ci DEFAULT '/',
  `descendants_routes` varchar(255) COLLATE utf8_unicode_ci DEFAULT '/',
  `class` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'default',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `fbf_nav_items_parent_id_index` (`parent_id`),
  KEY `fbf_nav_items_lft_index` (`lft`),
  KEY `fbf_nav_items_rgt_index` (`rgt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `fbf_nav_items` WRITE;
/*!40000 ALTER TABLE `fbf_nav_items` DISABLE KEYS */;

INSERT INTO `fbf_nav_items` (`id`, `parent_id`, `lft`, `rgt`, `depth`, `title`, `uri`, `descendants_routes`, `class`, `created_at`, `updated_at`)
VALUES
	(1,NULL,1,2,0,'Main','/','/','default','2015-01-13 05:14:54','2015-01-13 05:14:54'),
	(2,NULL,3,4,0,'Header','/','/','default','2015-01-13 05:14:54','2015-01-13 05:14:54'),
	(3,NULL,5,6,0,'Footer','/','/','default','2015-01-13 05:14:54','2015-01-13 05:14:54');

/*!40000 ALTER TABLE `fbf_nav_items` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
