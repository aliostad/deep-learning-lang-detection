-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.5.27 - MySQL Community Server (GPL)
-- Server OS:                    Win32
-- HeidiSQL version:             7.0.0.4053
-- Date/time:                    2013-06-02 17:41:23
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET FOREIGN_KEY_CHECKS=0 */;

-- Dumping structure for table mcm.articles
DROP TABLE IF EXISTS `articles`;
CREATE TABLE IF NOT EXISTS `articles` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL,
  `handler_page_id` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `text` text NOT NULL,
  `nav_title` varchar(255) NOT NULL,
  `nav_kz` char(1) NOT NULL DEFAULT 'N',
  `nav_sort` int(11) NOT NULL,
  `nav_level` int(11) NOT NULL,
  `categorie_id` int(11) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Dumping data for table mcm.articles: ~3 rows (approximately)
/*!40000 ALTER TABLE `articles` DISABLE KEYS */;
INSERT INTO `articles` (`id`, `parent_id`, `handler_page_id`, `title`, `text`, `nav_title`, `nav_kz`, `nav_sort`, `nav_level`, `categorie_id`, `updated_at`, `created_at`) VALUES
	(1, 0, '1', 'Test Title 1', 'Test Text 1 3123', 'Test Nav 12122', 'J', 1, 1, 0, '2013-06-01 20:05:06', '0000-00-00 00:00:00'),
	(2, 1, '1', 'Test Title 2', 'Test Text 2', 'Test Nav 2', 'J', 2, 1, 0, '2013-06-01 14:49:40', '0000-00-00 00:00:00'),
	(3, 1, '2', 'Test Titel Nummer 3', 'kdjhasjk dajksd as\r\nasjk dhas jkdhasd\r\nasdjk\r\n\r\nalsd ajsdhajkshdjk askdjasjkdjk', 'Nav Titel Nummer 3', 'J', 3, 1, 1, '2013-06-01 15:20:09', '2013-06-01 14:36:54');
/*!40000 ALTER TABLE `articles` ENABLE KEYS */;


-- Dumping structure for table mcm.categories
DROP TABLE IF EXISTS `categories`;
CREATE TABLE IF NOT EXISTS `categories` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- Dumping data for table mcm.categories: ~3 rows (approximately)
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` (`id`, `name`) VALUES
	(0, '- Keine -'),
	(1, 'Standard'),
	(2, 'Haste nich gesehn');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;


-- Dumping structure for table mcm.handler_pages
DROP TABLE IF EXISTS `handler_pages`;
CREATE TABLE IF NOT EXISTS `handler_pages` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `handler` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- Dumping data for table mcm.handler_pages: ~2 rows (approximately)
/*!40000 ALTER TABLE `handler_pages` DISABLE KEYS */;
INSERT INTO `handler_pages` (`id`, `name`, `handler`) VALUES
	(1, 'Artikel', 'article/show/'),
	(2, 'Report', 'report/overview/');
/*!40000 ALTER TABLE `handler_pages` ENABLE KEYS */;


-- Dumping structure for table mcm.meldungen
DROP TABLE IF EXISTS `meldungen`;
CREATE TABLE IF NOT EXISTS `meldungen` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `sort` int(10) DEFAULT '0',
  `title` varchar(255) DEFAULT NULL,
  `text` text,
  `categorie_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- Dumping data for table mcm.meldungen: ~3 rows (approximately)
/*!40000 ALTER TABLE `meldungen` DISABLE KEYS */;
INSERT INTO `meldungen` (`id`, `sort`, `title`, `text`, `categorie_id`, `created_at`, `updated_at`) VALUES
	(2, 1, 'Meldung 1', 'Hier steht der Text der ersten Meldung!!\r\n\r\nasdasd\r\nasd', 2, '2013-06-01 15:38:16', '2013-06-01 15:39:45'),
	(3, 2, 'Meldung 2', 'Hier steht der Text der zweiten Meldung!', 2, '2013-06-01 15:38:38', '2013-06-01 15:39:39'),
	(4, 3, 'aasdas', 'dasdasd', 1, '2013-06-01 15:38:51', '2013-06-01 15:39:33');
/*!40000 ALTER TABLE `meldungen` ENABLE KEYS */;


-- Dumping structure for table mcm.reports
DROP TABLE IF EXISTS `reports`;
CREATE TABLE IF NOT EXISTS `reports` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `text` text NOT NULL,
  `categorie_id` int(11) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- Dumping data for table mcm.reports: ~3 rows (approximately)
/*!40000 ALTER TABLE `reports` DISABLE KEYS */;
INSERT INTO `reports` (`id`, `title`, `text`, `categorie_id`, `updated_at`, `created_at`) VALUES
	(1, 'Test Report Nummer 1', 'Hier steht der Text zum Test Report Nummer 1!!\r\nWäre hätte das gedacht?\r\n\r\n:D:D!!asjkdask', 1, '2013-06-01 15:04:41', '2013-06-01 15:04:41'),
	(2, 'Report 2', 'as,d asdahsjdhlha dkha\r\nd asjkdhasjdhasd asdöhaskjdhas\r\n\r\naj sldjasldjklasj dlk\r\n\');', 1, '2013-06-01 15:15:41', '2013-06-01 15:05:01'),
	(3, 'Report 3', 'askd aklsdjaklsj dlkasjldkjasldjalsjd\r\nlasjdljka ldjs\r\n\r\nasd', 2, '2013-06-01 15:08:51', '2013-06-01 15:05:21');
/*!40000 ALTER TABLE `reports` ENABLE KEYS */;


-- Dumping structure for table mcm.users
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `username` char(255) NOT NULL,
  `password` char(255) NOT NULL,
  `email` char(255) DEFAULT NULL,
  `name` char(255) DEFAULT NULL,
  `vorname` char(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- Dumping data for table mcm.users: ~3 rows (approximately)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`id`, `username`, `password`, `email`, `name`, `vorname`, `created_at`, `updated_at`) VALUES
	(1, 'mike', '$2y$08$4WwAAL16.q6.B7usaEXdMe.H9Nc.WUqfm32Le36oWvj4sJTIU7to6', 'mike3010@gmail.com', 'Mike', 'Logan', '2013-05-31 18:06:49', '2013-06-01 08:52:42'),
	(2, 'admin', '$2y$08$hcj.Kt4NaSmZLbcVXuTplOBGVsNf7tNi1Y2iicA6HM7TBMyvsZRbC', 'admin@mcm.de', 'Admin', 'istrator', '2013-06-01 07:21:21', '2013-06-01 08:52:26'),
	(3, 'mike3010', '$2y$08$26Gb7N7vuHsStJ/qoL8WqexFs91u6Cs1gigLwIfz4Nzyev0OnxuWa', 'mike@logan.de', 'N.', 'Michi', '2013-06-01 08:29:02', '2013-06-01 08:52:51');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
/*!40014 SET FOREIGN_KEY_CHECKS=1 */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
