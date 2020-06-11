-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Mar 02, 2015 at 06:56 PM
-- Server version: 5.6.17
-- PHP Version: 5.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `megoadmincms`
--

-- --------------------------------------------------------

--
-- Table structure for table `megoadmincms_nav`
--

CREATE TABLE IF NOT EXISTS `megoadmincms_nav` (
  `nav_id` int(11) NOT NULL AUTO_INCREMENT,
  `sk_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `sk_name_seo` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `model_id` int(11) NOT NULL,
  `sk_content` longtext COLLATE utf8_unicode_ci NOT NULL,
  `private` int(11) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`nav_id`),
  UNIQUE KEY `sk_name` (`sk_name`,`sk_name_seo`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=2 ;

--
-- Dumping data for table `megoadmincms_nav`
--

INSERT INTO `megoadmincms_nav` (`nav_id`, `sk_name`, `sk_name_seo`, `model_id`, `sk_content`, `private`, `date`) VALUES
(1, 'Domov', 'domov', 2, 'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don''t look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn''t anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.', 0, '2015-03-02 18:47:19');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
