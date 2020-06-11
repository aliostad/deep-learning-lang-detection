-- phpMyAdmin SQL Dump
-- version 3.5.2.2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Erstellungszeit: 18. Nov 2012 um 23:23
-- Server Version: 5.5.27
-- PHP-Version: 5.4.7

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Datenbank: `sas`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `sas_main_menu`
--

DROP TABLE IF EXISTS `sas_main_menu`;
CREATE TABLE IF NOT EXISTS `sas_main_menu` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `page` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Daten für Tabelle `sas_main_menu`
--

INSERT INTO `sas_main_menu` (`id`, `name`, `page`) VALUES
(1, 'START', 'home'),
(2, 'APACHE', 'apache'),
(3, 'POSTFIX', 'postfix'),
(4, 'FTP', 'ftp'),
(5, 'MYSQL', 'mysql'),
(6, 'SAMBA', 'samba'),
(7, 'MANAGEMENT', 'management'),
(8, 'WEBUSER', 'webuser'),
(9, 'TOOLS', 'tools'),
(10, 'PLUGINS', 'plugins');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `sas_page_content`
--

DROP TABLE IF EXISTS `sas_page_content`;
CREATE TABLE IF NOT EXISTS `sas_page_content` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `page` varchar(255) NOT NULL,
  `spage` varchar(255) NOT NULL,
  `inc_path` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Daten für Tabelle `sas_page_content`
--

INSERT INTO `sas_page_content` (`id`, `page`, `spage`, `inc_path`) VALUES
(1, 'home', '', 'inc/home/home.inc.php'),
(2, 'tools', 'console', 'inc/tools/console.inc.php'),
(3, 'home', 'overview', 'inc/index/overview.inc.php'),
(4, 'home', 'panel', 'inc/index/panel.inc.php'),
(5, 'home', 'stats', 'inc/index/stats.inc.php'),
(6, 'home', 'doku', 'inc/index/doku.inc.php'),
(7, 'home', 'help', 'inc/index/help.inc.php'),
(8, 'home', 'about', 'inc/index/about.inc.php'),
(9, 'mysql', 'console', 'inc/mysql/sqlcmd.inc.php'),
(10, 'mysql', 'overview', 'inc/mysql/overview.inc.php');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `sas_side_nav`
--

DROP TABLE IF EXISTS `sas_side_nav`;
CREATE TABLE IF NOT EXISTS `sas_side_nav` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `page` varchar(255) NOT NULL,
  `spage` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Daten für Tabelle `sas_side_nav`
--

INSERT INTO `sas_side_nav` (`id`, `name`, `page`, `spage`) VALUES
(1, 'Home', 'home', ''),
(2, 'Konsole', 'tools', 'console'),
(3, 'System&uuml;bersicht', 'home', 'overview'),
(4, 'QuickPanel', 'home', 'panel'),
(5, 'Meldungen', 'home', 'notifications'),
(6, 'Serverstatistiken', 'home', 'stats'),
(7, 'Dokumentation', 'home', 'doku'),
(8, 'Hilfe', 'home', 'help'),
(9, '&Uuml;ber SAS', 'home', 'about'),
(10, '&Uuml;bersicht', 'mysql', 'overview');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `sas_web_users`
--

DROP TABLE IF EXISTS `sas_web_users`;
CREATE TABLE IF NOT EXISTS `sas_web_users` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `userunique` (`username`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Daten für Tabelle `sas_web_users`
--

INSERT INTO `sas_web_users` (`id`, `username`, `password`, `email`) VALUES
(1, 'admin', 'e8636ea013e682faf61f56ce1cb1ab5c', 'admin@admin.de'),
(2, 'pat', '22222', 'test@test.de');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
