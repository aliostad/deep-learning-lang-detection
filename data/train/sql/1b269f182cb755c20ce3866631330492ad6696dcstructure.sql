-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Mar 08, 2013 at 11:17 AM
-- Server version: 5.5.29
-- PHP Version: 5.3.10-1ubuntu3.5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `taunts`
--

-- --------------------------------------------------------

--
-- Table structure for table `append`
--

CREATE TABLE IF NOT EXISTS `append` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` mediumtext NOT NULL,
  `status` int(1) NOT NULL DEFAULT '1',
  `rank` int(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

-- --------------------------------------------------------

--
-- Table structure for table `game`
--

CREATE TABLE IF NOT EXISTS `game` (
  `id` int(6) NOT NULL AUTO_INCREMENT,
  `title` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

-- --------------------------------------------------------

--
-- Table structure for table `noun`
--

CREATE TABLE IF NOT EXISTS `noun` (
  `id` int(6) NOT NULL AUTO_INCREMENT,
  `noun` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `polarity`
--

CREATE TABLE IF NOT EXISTS `polarity` (
  `id` int(6) NOT NULL AUTO_INCREMENT,
  `polarity` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Table structure for table `taunt`
--

CREATE TABLE IF NOT EXISTS `taunt` (
  `id` int(6) NOT NULL AUTO_INCREMENT,
  `taunt` longtext NOT NULL,
  `polarity` int(6) NOT NULL,
  `type` int(6) NOT NULL,
  `length` int(6) NOT NULL,
  `game` varchar(2048) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `polarity` (`polarity`),
  KEY `game` (`game`(767)),
  KEY `type` (`type`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=45 ;

-- --------------------------------------------------------

--
-- Table structure for table `tense`
--

CREATE TABLE IF NOT EXISTS `tense` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tense` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Table structure for table `type`
--

CREATE TABLE IF NOT EXISTS `type` (
  `id` int(6) NOT NULL AUTO_INCREMENT,
  `type` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `verb`
--

CREATE TABLE IF NOT EXISTS `verb` (
  `id` int(6) NOT NULL AUTO_INCREMENT,
  `verb` varchar(100) NOT NULL,
  `status` int(1) NOT NULL DEFAULT '1',
  `rank` int(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
