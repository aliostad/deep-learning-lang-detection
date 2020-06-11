# ************************************************************
# Sequel Pro SQL dump
# Version 3408
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: 127.0.0.1 (MySQL 5.5.9)
# Database: stuffthedragon
# Generation Time: 2012-06-28 16:11:36 -0400
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table albums
# ------------------------------------------------------------

DROP TABLE IF EXISTS `albums`;

CREATE TABLE `albums` (
  `album_id` int(11) NOT NULL AUTO_INCREMENT,
  `album_title` varchar(120) NOT NULL DEFAULT '',
  `album_desc` text NOT NULL,
  `date_uploaded` datetime NOT NULL,
  PRIMARY KEY (`album_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table bio
# ------------------------------------------------------------

DROP TABLE IF EXISTS `bio`;

CREATE TABLE `bio` (
  `bio_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `bio_text` text NOT NULL,
  PRIMARY KEY (`bio_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table bio_photos
# ------------------------------------------------------------

DROP TABLE IF EXISTS `bio_photos`;

CREATE TABLE `bio_photos` (
  `bio_photo_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `bio_photo_path` varchar(100) NOT NULL DEFAULT '',
  `bio_photo_desc` text NOT NULL,
  `bio_photo_title` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`bio_photo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table blog
# ------------------------------------------------------------

DROP TABLE IF EXISTS `blog`;

CREATE TABLE `blog` (
  `blog_id` int(11) NOT NULL,
  `blog_date` datetime DEFAULT NULL,
  `blog_content` text NOT NULL,
  `blog_title` varchar(80) NOT NULL DEFAULT '',
  `date_uploaded` datetime NOT NULL,
  PRIMARY KEY (`blog_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table blog_photos
# ------------------------------------------------------------

DROP TABLE IF EXISTS `blog_photos`;

CREATE TABLE `blog_photos` (
  `blog_photo_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `blog_photo_title` varchar(80) NOT NULL DEFAULT '',
  `blog_photo_desc` int(11) NOT NULL,
  `blog_id` int(11) NOT NULL,
  `blog_photo_path` varchar(120) NOT NULL DEFAULT '',
  `date_uploaded` datetime DEFAULT NULL,
  PRIMARY KEY (`blog_photo_id`),
  KEY `blog_id` (`blog_id`),
  CONSTRAINT `blog_photos_ibfk_1` FOREIGN KEY (`blog_id`) REFERENCES `blog` (`blog_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table booking_contacts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `booking_contacts`;

CREATE TABLE `booking_contacts` (
  `contact_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `contact_fname` varchar(80) NOT NULL DEFAULT '',
  `contact_lname` varchar(80) NOT NULL DEFAULT '',
  `contact_phone` varchar(14) NOT NULL DEFAULT '',
  `contact_email` int(11) NOT NULL,
  `date_uploaded` datetime DEFAULT NULL,
  PRIMARY KEY (`contact_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table cms_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cms_users`;

CREATE TABLE `cms_users` (
  `user_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_pass` varchar(50) NOT NULL DEFAULT '',
  `user_name` varchar(50) NOT NULL DEFAULT '',
  `internal_email` varchar(50) NOT NULL DEFAULT '',
  `date_uploaded` datetime DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table nav
# ------------------------------------------------------------

DROP TABLE IF EXISTS `nav`;

CREATE TABLE `nav` (
  `nav_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `nav_link` varchar(120) NOT NULL DEFAULT '',
  `nav_name` varchar(25) NOT NULL DEFAULT '',
  `date_uploaded` datetime DEFAULT NULL,
  PRIMARY KEY (`nav_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table photos
# ------------------------------------------------------------

DROP TABLE IF EXISTS `photos`;

CREATE TABLE `photos` (
  `photo_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `album_id` int(11) NOT NULL,
  `photo_title` varchar(100) NOT NULL DEFAULT '',
  `photo_desc` text NOT NULL,
  `photo_path` varchar(120) NOT NULL DEFAULT '',
  `date_uploaded` datetime NOT NULL,
  PRIMARY KEY (`photo_id`),
  KEY `album_id` (`album_id`),
  CONSTRAINT `photos_ibfk_1` FOREIGN KEY (`album_id`) REFERENCES `albums` (`album_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table videos
# ------------------------------------------------------------

DROP TABLE IF EXISTS `videos`;

CREATE TABLE `videos` (
  `video_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `video_path` varchar(100) NOT NULL DEFAULT '',
  `video_title` varchar(80) NOT NULL DEFAULT '',
  `video_desc` text NOT NULL,
  `video_length` varchar(5) NOT NULL DEFAULT '',
  `date_uploaded` datetime NOT NULL,
  PRIMARY KEY (`video_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
