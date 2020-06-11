-- phpMyAdmin SQL Dump
-- version 3.3.7deb5build0.10.10.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 11, 2011 at 09:53 PM
-- Server version: 5.1.49
-- PHP Version: 5.3.3-1ubuntu9.5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `tukang`
--

-- --------------------------------------------------------

--
-- Table structure for table `wp_images`
--

CREATE TABLE IF NOT EXISTS `wp_images` (
  `images_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `source` text,
  `slug` text,
  PRIMARY KEY (`images_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `wp_images`
--


-- --------------------------------------------------------

--
-- Table structure for table `wp_poster`
--

CREATE TABLE IF NOT EXISTS `wp_poster` (
  `post_id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`post_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=173 ;

--
-- Dumping data for table `wp_poster`
--

INSERT INTO `wp_poster` (`post_id`, `title`, `category`, `status`) VALUES
(152, '2010 Land Rover Range Rover Sport Autobiography', 'Lamborghini', 'new'),
(151, '2010 Land Rover Range Rover Sport', 'Lamborghini', 'new'),
(149, '2010 Land Rover Range Rover', 'Lamborghini', 'new'),
(150, '2010 Land Rover Range Rover Autobiography Black', 'Lamborghini', 'new'),
(148, '2010 Land Rover Discovery 4', 'Lamborghini', 'new'),
(147, '2010 Holland & Holland Range Rover by Overfinch', 'Lamborghini', 'new'),
(136, '2010 Lamborghini Murcielago LP 670-4 China', 'Lamborghini', 'posted'),
(137, '2010 Lamborghini Reventon Roadster', 'Lamborghini', 'new'),
(138, '2010 Lamborghini Sesto Elemento Concept', 'Lamborghini', 'new'),
(139, '2010 Wheelsandmore Lamborghini Gallardo LP 620', 'Lamborghini', 'new'),
(140, '2011 Edo Competition Lamborghini Murcielago LP750', 'Lamborghini', 'new'),
(141, '2011 Hamann Lamborghini Gallardo LP560-4 Victory', 'Lamborghini', 'new'),
(146, '2009 Startech Land Rover Range Rover', 'Lamborghini', 'new'),
(145, '2009 Project Kahn Range Rover Vogue', 'Lamborghini', 'new'),
(144, '2011 Lamborghini Gallardo 570-4 Spyder Performante', 'Lamborghini', 'new'),
(143, '2011 Lamborghini Gallardo LP570-4 Blancpain', 'Lamborghini', 'new'),
(142, '2011 Lamborghini Gallardo LP 560-4 Bicolore', 'Lamborghini', 'new'),
(128, '2009 Reiter Lamborghini Gallardo GT3 Strada', 'Lamborghini', 'new'),
(129, '2009 Reiter Lamborghini Murcielago Streetversion', 'Lamborghini', 'new'),
(130, '2010 BF-performance Lamborghini Gallardo GT600', 'Lamborghini', 'new'),
(131, '2010 Edo Competition Lamborghini Gallardo LP600/4', 'Lamborghini', 'new'),
(132, '2010 ENCO Exclusive Lamborghini Gallardo LP 560-4', 'Lamborghini', 'new'),
(133, '2010 IMSA Lamborghini Gallardo LP-560 GTV', 'Lamborghini', 'new'),
(134, '2010 Lamborghini Furia Concept of Amadou Ndiaye', 'Lamborghini', 'new'),
(135, '2010 Lamborghini Gallardo LP 570-4 Superleggera', 'Lamborghini', 'new'),
(127, '2009 Premier4509 Lamborghini Murcielago', 'Lamborghini', 'new'),
(126, '2009 Premier4509 Lamborghini Gallardo', 'Lamborghini', 'new'),
(125, '2009 Lamborghini Toro Concept of Amadou Ndiaye', 'Lamborghini', 'new'),
(124, '2009 Lamborghini Reventon Number 20', 'Lamborghini', 'new'),
(123, '2009 Lamborghini Murcielago LP 670-4 SuperVeloce', 'Lamborghini', 'new'),
(113, '2009 Edo Competition Lamborghini LP710 Audigier', 'Lamborghini', 'new'),
(114, '2009 IMSA Lamborghini Murcielago Spyder', 'Lamborghini', 'new'),
(115, '2009 Lamborghini Blancpain Super Trofeo', 'Lamborghini', 'new'),
(116, '2009 Lamborghini Gallardo LP 550 Valentino Balboni', 'Lamborghini', 'new'),
(117, '2009 Lamborghini Gallardo LP560-4 Polizia', 'Lamborghini', 'new'),
(118, '2009 Lamborghini Gallardo LP 560 4 Spyder', 'Lamborghini', 'new'),
(119, '2009 Lamborghini Gallardo LP-640 Ad Personam', 'Lamborghini', 'new'),
(120, '2009 Lamborghini Insecta Concept Design', 'Lamborghini', 'new'),
(121, '2009 Lamborghini Murcielago LP-640 Ad Personam', 'Lamborghini', 'new'),
(122, '2009 Lamborghini Murcielago LP 650-4 Roadster', 'Lamborghini', 'new'),
(153, '2010 Project Kahn Land Rover Freelander RS200', 'Lamborghini', 'new'),
(154, '2010 Project Kahn Range Rover Sport RS600', 'Lamborghini', 'new'),
(155, '2010 Project Kahn Range Rover Sport Vesuvius', 'Lamborghini', 'new'),
(156, '2010 Startech Land Rover Freelander 2', 'Lamborghini', 'new'),
(157, '2010 Startech Land Rover Range Rover', 'Lamborghini', 'new'),
(158, '2011 Land Rover Defender Limited Edition', 'Lamborghini', 'new'),
(159, '2011 Land Rover LR2', 'Lamborghini', 'new'),
(160, '2011 Land Rover LR4', 'Lamborghini', 'new'),
(161, '2011 Land Rover Range Rover', 'Lamborghini', 'new'),
(162, '2011 Land Rover Range Rover Evoque', 'Lamborghini', 'new'),
(163, '2011 Land Rover Range Rover Evoque 5-Door', 'Lamborghini', 'new'),
(164, '2011 Mansory Land Rover Range Rover', 'Lamborghini', 'new'),
(165, '2011 Project Kahn Cosworth Range Rover RS300', 'Lamborghini', 'new'),
(166, '2011 Startech Land Rover Defender Yachting Edition', 'Lamborghini', 'new'),
(167, 'STRUT Land Rover Range Rover Carbon Fiber', 'Lamborghini', 'new'),
(168, 'STRUT Land Rover Range Rover Windsor Collection', 'Lamborghini', 'new'),
(169, 'STRUT Land Rover Sport Ascot Emerald', 'Lamborghini', 'new'),
(170, 'STRUT Land Rover Sport Ascot Marquise', 'Lamborghini', 'new'),
(171, 'STRUT Land Rover Windsor Emerald', 'Lamborghini', 'new'),
(172, 'STRUT Windsor Emerald Collection Range Rover', 'Lamborghini', 'new');
