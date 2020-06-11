
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
DROP TABLE IF EXISTS `wp_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wp_posts` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `post_author` bigint(20) unsigned NOT NULL DEFAULT '0',
  `post_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_date_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `post_title` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `post_excerpt` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `post_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'publish',
  `comment_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'open',
  `ping_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'open',
  `post_password` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `post_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `to_ping` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `pinged` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `post_modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_modified_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_content_filtered` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `post_parent` bigint(20) unsigned NOT NULL DEFAULT '0',
  `guid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `menu_order` int(11) NOT NULL DEFAULT '0',
  `post_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'post',
  `post_mime_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `comment_count` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `post_name` (`post_name`(191)),
  KEY `type_status_date` (`post_type`,`post_status`,`post_date`,`ID`),
  KEY `post_parent` (`post_parent`),
  KEY `post_author` (`post_author`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `wp_posts` WRITE;
/*!40000 ALTER TABLE `wp_posts` DISABLE KEYS */;
INSERT INTO `wp_posts` VALUES (1,1,'2015-11-19 08:03:21','2015-11-19 08:03:21','Welcome to WordPress. This is your first post. Edit or delete it, then start writing!','Hello world!','','publish','open','open','','hello-world','','','2015-11-19 08:03:21','2015-11-19 08:03:21','',0,'http://localhost:8888/appxlabs/?p=1',0,'post','',1),(2,1,'2015-11-19 08:03:21','2015-11-19 08:03:21','This is an example page. It\'s different from a blog post because it will stay in one place and will show up in your site navigation (in most themes). Most people start with an About page that introduces them to potential site visitors. It might say something like this:\n\n<blockquote>Hi there! I\'m a bike messenger by day, aspiring actor by night, and this is my website. I live in Los Angeles, have a great dog named Jack, and I like pi&#241;a coladas. (And gettin\' caught in the rain.)</blockquote>\n\n...or something like this:\n\n<blockquote>The XYZ Doohickey Company was founded in 1971, and has been providing quality doohickeys to the public ever since. Located in Gotham City, XYZ employs over 2,000 people and does all kinds of awesome things for the Gotham community.</blockquote>\n\nAs a new WordPress user, you should go to <a href=\"http://localhost:8888/appxlabs/wp-admin/\">your dashboard</a> to delete this page and create new pages for your content. Have fun!','Sample Page','','publish','closed','open','','sample-page','','','2015-11-19 08:03:21','2015-11-19 08:03:21','',0,'http://localhost:8888/appxlabs/?page_id=2',0,'page','',0),(3,1,'2015-11-19 08:03:33','0000-00-00 00:00:00','','Auto Draft','','auto-draft','open','open','','','','','2015-11-19 08:03:33','0000-00-00 00:00:00','',0,'http://localhost:8888/appxlabs/?p=3',0,'post','',0),(4,1,'2015-11-19 08:29:18','2015-11-19 08:29:18','','GTNexusLogo_1d365b_404px','','inherit','open','closed','','gtnexuslogo_1d365b_404px','','','2015-11-19 08:29:18','2015-11-19 08:29:18','',0,'http://localhost:8888/appxlabs/wp-content/uploads/2015/11/GTNexusLogo_1d365b_404px.png',0,'attachment','image/png',0),(5,1,'2015-11-19 09:12:04','2015-11-19 09:12:04','You can find all the apps in this page.\r\n\r\n&nbsp;','Apps','','publish','closed','closed','','apps','','','2015-11-19 09:12:04','2015-11-19 09:12:04','',0,'http://localhost:8888/appxlabs/?page_id=5',0,'page','',0),(6,1,'2015-11-19 09:12:04','2015-11-19 09:12:04','You can find all the apps in this page.\r\n\r\n&nbsp;','Apps','','inherit','closed','closed','','5-revision-v1','','','2015-11-19 09:12:04','2015-11-19 09:12:04','',5,'http://localhost:8888/appxlabs/2015/11/19/5-revision-v1/',0,'revision','',0),(7,1,'2015-11-19 09:12:14','2015-11-19 09:12:14','Scout content goes here.','Scout','','publish','closed','closed','','scout','','','2015-11-19 09:18:18','2015-11-19 09:18:18','',5,'http://localhost:8888/appxlabs/?page_id=7',0,'page','',0),(8,1,'2015-11-19 09:12:14','2015-11-19 09:12:14','Scout content goes here.','Scout','','inherit','closed','closed','','7-revision-v1','','','2015-11-19 09:12:14','2015-11-19 09:12:14','',7,'http://localhost:8888/appxlabs/2015/11/19/7-revision-v1/',0,'revision','',0),(9,1,'2015-11-19 09:13:45','0000-00-00 00:00:00','','Home','','draft','closed','closed','','','','','2015-11-19 09:13:45','0000-00-00 00:00:00','',0,'http://localhost:8888/appxlabs/?p=9',1,'nav_menu_item','',0),(10,1,'2015-11-19 09:13:45','0000-00-00 00:00:00',' ','','','draft','closed','closed','','','','','2015-11-19 09:13:45','0000-00-00 00:00:00','',0,'http://localhost:8888/appxlabs/?p=10',1,'nav_menu_item','',0),(11,1,'2015-11-19 09:13:45','0000-00-00 00:00:00',' ','','','draft','closed','closed','','','','','2015-11-19 09:13:45','0000-00-00 00:00:00','',5,'http://localhost:8888/appxlabs/?p=11',1,'nav_menu_item','',0),(12,1,'2015-11-19 09:13:45','0000-00-00 00:00:00',' ','','','draft','closed','closed','','','','','2015-11-19 09:13:45','0000-00-00 00:00:00','',0,'http://localhost:8888/appxlabs/?p=12',1,'nav_menu_item','',0),(13,1,'2015-11-19 09:14:13','0000-00-00 00:00:00','','Home','','draft','closed','closed','','','','','2015-11-19 09:14:13','0000-00-00 00:00:00','',0,'http://localhost:8888/appxlabs/?p=13',1,'nav_menu_item','',0),(14,1,'2015-11-19 09:14:13','0000-00-00 00:00:00',' ','','','draft','closed','closed','','','','','2015-11-19 09:14:13','0000-00-00 00:00:00','',0,'http://localhost:8888/appxlabs/?p=14',1,'nav_menu_item','',0),(15,1,'2015-11-19 09:14:13','0000-00-00 00:00:00',' ','','','draft','closed','closed','','','','','2015-11-19 09:14:13','0000-00-00 00:00:00','',5,'http://localhost:8888/appxlabs/?p=15',1,'nav_menu_item','',0),(16,1,'2015-11-19 09:14:13','0000-00-00 00:00:00',' ','','','draft','closed','closed','','','','','2015-11-19 09:14:13','0000-00-00 00:00:00','',0,'http://localhost:8888/appxlabs/?p=16',1,'nav_menu_item','',0),(18,1,'2015-11-19 09:16:27','0000-00-00 00:00:00','','Home','','draft','closed','closed','','','','','2015-11-19 09:16:27','0000-00-00 00:00:00','',0,'http://localhost:8888/appxlabs/?p=18',1,'nav_menu_item','',0),(19,1,'2015-11-19 09:16:28','0000-00-00 00:00:00',' ','','','draft','closed','closed','','','','','2015-11-19 09:16:28','0000-00-00 00:00:00','',0,'http://localhost:8888/appxlabs/?p=19',1,'nav_menu_item','',0),(20,1,'2015-11-19 09:16:28','0000-00-00 00:00:00',' ','','','draft','closed','closed','','','','','2015-11-19 09:16:28','0000-00-00 00:00:00','',0,'http://localhost:8888/appxlabs/?p=20',1,'nav_menu_item','',0),(21,1,'2015-11-19 09:16:28','0000-00-00 00:00:00',' ','','','draft','closed','closed','','','','','2015-11-19 09:16:28','0000-00-00 00:00:00','',0,'http://localhost:8888/appxlabs/?p=21',1,'nav_menu_item','',0),(22,1,'2015-11-19 10:00:39','0000-00-00 00:00:00','','Home','','draft','closed','closed','','','','','2015-11-19 10:00:39','0000-00-00 00:00:00','',0,'http://localhost:8888/appxlabs/?p=22',1,'nav_menu_item','',0),(23,1,'2015-11-19 10:00:39','0000-00-00 00:00:00',' ','','','draft','closed','closed','','','','','2015-11-19 10:00:39','0000-00-00 00:00:00','',0,'http://localhost:8888/appxlabs/?p=23',1,'nav_menu_item','',0),(24,1,'2015-11-19 10:00:39','0000-00-00 00:00:00',' ','','','draft','closed','closed','','','','','2015-11-19 10:00:39','0000-00-00 00:00:00','',5,'http://localhost:8888/appxlabs/?p=24',1,'nav_menu_item','',0),(25,1,'2015-11-19 10:00:39','0000-00-00 00:00:00',' ','','','draft','closed','closed','','','','','2015-11-19 10:00:39','0000-00-00 00:00:00','',0,'http://localhost:8888/appxlabs/?p=25',1,'nav_menu_item','',0),(26,1,'2015-11-19 10:04:14','0000-00-00 00:00:00','','Auto Draft','','auto-draft','open','open','','','','','2015-11-19 10:04:14','0000-00-00 00:00:00','',0,'http://localhost:8888/appxlabs/?p=26',0,'post','',0);
/*!40000 ALTER TABLE `wp_posts` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

