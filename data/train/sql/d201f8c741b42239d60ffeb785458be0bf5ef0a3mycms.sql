-- phpMyAdmin SQL Dump
-- version 3.3.9
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Sep 11, 2012 at 03:59 AM
-- Server version: 5.5.8
-- PHP Version: 5.3.5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `mycms`
--

-- --------------------------------------------------------

--
-- Table structure for table `article`
--

CREATE TABLE IF NOT EXISTS `article` (
  `page` varchar(30) NOT NULL,
  `article_title` varchar(30) NOT NULL,
  `article_content` varchar(30) NOT NULL,
  `weight` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `article`
--

INSERT INTO `article` (`page`, `article_title`, `article_content`, `weight`) VALUES
('home', 'College Details', '<p>blah blah</p><p>testcontent', 0);

-- --------------------------------------------------------

--
-- Table structure for table `cells`
--

CREATE TABLE IF NOT EXISTS `cells` (
  `page` varchar(30) NOT NULL,
  `name` varchar(30) NOT NULL,
  `weight` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `cells`
--

INSERT INTO `cells` (`page`, `name`, `weight`) VALUES
('home', 'article', 0);

-- --------------------------------------------------------

--
-- Table structure for table `main_nav`
--

CREATE TABLE IF NOT EXISTS `main_nav` (
  `page` varchar(30) NOT NULL,
  `name` varchar(30) NOT NULL,
  `link` varchar(30) NOT NULL,
  `weight` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `main_nav`
--

INSERT INTO `main_nav` (`page`, `name`, `link`, `weight`) VALUES
('home', 'Home', 'home', 0),
('home', 'Academics', 'academics', 1),
('home', 'Library', 'library', 2),
('home', 'Students', 'students', 3),
('home', 'About us', 'about', 4),
('academics', 'Home', 'home', 0),
('academics', 'Academics', 'academics', 1),
('academics', 'Library', 'library', 2),
('academics', 'Students', 'students', 3),
('academics', 'About us', 'about', 4),
('library', 'Home', 'home', 4),
('library', 'Academics', 'library', 1),
('library', 'Library', 'library', 2),
('library', 'Students', 'students', 3),
('library', 'About us', 'about', 0);

-- --------------------------------------------------------

--
-- Table structure for table `page`
--

CREATE TABLE IF NOT EXISTS `page` (
  `pid` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `title` varchar(30) NOT NULL,
  `theme` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `page`
--

INSERT INTO `page` (`pid`, `name`, `title`, `theme`) VALUES
(1, 'home', 'HOME', 'default'),
(2, 'academics', 'ACADEMICS', 'default'),
(3, 'library', 'library', 'default'),
(4, 'students', 'students', 'default'),
(5, 'about', 'about us', 'default');
