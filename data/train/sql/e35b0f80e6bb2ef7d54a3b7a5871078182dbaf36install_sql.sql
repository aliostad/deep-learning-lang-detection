# ************************************************************
# Sequel Pro SQL dump
# Version 4096
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: 127.0.0.1 (MySQL 5.6.23-1~dotdeb.3)
# Database: light
# Generation Time: 2015-03-28 14:38:48 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table _301
# ------------------------------------------------------------

CREATE TABLE `_301` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `redirect_from` varchar(250) NOT NULL DEFAULT '',
  `redirect_to` varchar(250) NOT NULL DEFAULT '',
  `type` int(11) NOT NULL DEFAULT '301',
  `active` int(11) DEFAULT '1',
  `date_added` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `date_enable` timestamp NULL DEFAULT NULL,
  `date_expire` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table _301_stats
# ------------------------------------------------------------

CREATE TABLE `_301_stats` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `301_id` int(11) DEFAULT NULL,
  `url_requested` varchar(500) DEFAULT NULL,
  `date_added` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `referral_source` varchar(250) DEFAULT NULL,
  `query_string` varchar(500) DEFAULT NULL,
  `http_user_agent` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table _404_stats
# ------------------------------------------------------------

CREATE TABLE `_404_stats` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `url_requested` varchar(500) DEFAULT NULL,
  `referral_source` varchar(250) DEFAULT NULL,
  `remote_addr` varchar(50) DEFAULT NULL,
  `query_string` varchar(500) DEFAULT NULL,
  `post_data` text,
  `http_user_agent` varchar(500) DEFAULT NULL,
  `date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table _error_sql
# ------------------------------------------------------------

CREATE TABLE `_error_sql` (
  `errorID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `sql` text,
  `type` varchar(50) DEFAULT NULL,
  `uri` text,
  `userIP` varchar(50) DEFAULT NULL,
  `errorMsg` text,
  `getVars` text,
  `postVars` text,
  `date` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`errorID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table meta
# ------------------------------------------------------------

CREATE TABLE `meta` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(250) DEFAULT NULL,
  `title` varchar(500) DEFAULT NULL,
  `description` text,
  `keywords` varchar(250) DEFAULT NULL,
  `robots` varchar(50) DEFAULT 'index/follow',
  `zone_opening_header` text,
  `zone_closing_header` text,
  `zone_opening_body` text,
  `zone_closing_body` text,
  `zone_opening_header_append` text,
  `zone_closing_header_append` text,
  `zone_opening_body_append` text,
  `zone_closing_body_append` text,
  `active` int(11) DEFAULT '1' COMMENT 'For use in the sitemap so unpublished urls don''t go live',
  `active_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'For use in the sitemap so unpublished urls don''t go live',
  `date_content_last_modified` datetime DEFAULT NULL COMMENT 'sitemap usage',
  `changefreq` varchar(15) DEFAULT NULL COMMENT 'sitemap',
  `priority` decimal(1,1) DEFAULT NULL COMMENT 'sitemap',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `meta` WRITE;
/*!40000 ALTER TABLE `meta` DISABLE KEYS */;

INSERT INTO `meta` (`id`, `url`, `title`, `description`, `keywords`, `robots`, `zone_opening_header`, `zone_closing_header`, `zone_opening_body`, `zone_closing_body`, `zone_opening_header_append`, `zone_closing_header_append`, `zone_opening_body_append`, `zone_closing_body_append`, `active`, `active_date`, `date_content_last_modified`, `changefreq`, `priority`)
VALUES
	(1,'/','Web App Light','A lightweight Web Application framework. ','no one uses keywords anymore, just clients.','index/follow',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2015-03-28 14:06:07','2015-03-28 14:07:40','daily',0.9);

/*!40000 ALTER TABLE `meta` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
