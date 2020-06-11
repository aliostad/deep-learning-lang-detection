-- phpMyAdmin SQL Dump
-- version 3.2.2
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Jan 10, 2012 at 03:46 PM
-- Server version: 5.1.56
-- PHP Version: 5.3.8

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `digpen`
--

-- --------------------------------------------------------

--
-- Table structure for table `applications`
--

DROP TABLE IF EXISTS `applications`;
CREATE TABLE IF NOT EXISTS `applications` (
  `appID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `appName` char(32) NOT NULL,
  `appCode` char(16) NOT NULL,
  PRIMARY KEY (`appID`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `applications`
--

INSERT INTO `applications` (`appID`, `appName`, `appCode`) VALUES
(1, 'Skillsmap', 'skillsmap');

-- --------------------------------------------------------

--
-- Table structure for table `companies`
--

DROP TABLE IF EXISTS `companies`;
CREATE TABLE IF NOT EXISTS `companies` (
  `companyID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `companyName` varchar(32) NOT NULL,
  `companyDescription` text NOT NULL,
  PRIMARY KEY (`companyID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `companies`
--


-- --------------------------------------------------------

--
-- Table structure for table `gallery`
--

DROP TABLE IF EXISTS `gallery`;
CREATE TABLE IF NOT EXISTS `gallery` (
  `galleryID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `galleryPage` int(10) unsigned NOT NULL,
  `galleryName` varchar(64) NOT NULL,
  `galleryDescription` text NOT NULL,
  `galleryImage` varchar(32) NOT NULL,
  `galleryLocation` varchar(32) NOT NULL,
  `galleryDate` date NOT NULL,
  `galleryMedium` varchar(32) NOT NULL,
  `gallerySize` varchar(16) NOT NULL,
  `gallerySold` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`galleryID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `gallery`
--


-- --------------------------------------------------------

--
-- Table structure for table `images`
--

DROP TABLE IF EXISTS `images`;
CREATE TABLE IF NOT EXISTS `images` (
  `imageID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `imageName` varchar(32) NOT NULL,
  `imageFile` varchar(32) NOT NULL,
  PRIMARY KEY (`imageID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `images`
--


-- --------------------------------------------------------

--
-- Table structure for table `nav`
--

DROP TABLE IF EXISTS `nav`;
CREATE TABLE IF NOT EXISTS `nav` (
  `navID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `navName` varchar(32) NOT NULL,
  `navParent` int(10) unsigned NOT NULL DEFAULT '0',
  `navRollover` varchar(64) NOT NULL,
  `navHref` varchar(255) NOT NULL,
  `navTitle` varchar(120) NOT NULL,
  `navText` text NOT NULL,
  `navApplication` int(10) unsigned NOT NULL,
  `navShow` tinyint(1) unsigned NOT NULL,
  `navActive` tinyint(1) unsigned NOT NULL,
  `navOrder` int(10) unsigned NOT NULL,
  PRIMARY KEY (`navID`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `nav`
--

INSERT INTO `nav` (`navID`, `navName`, `navParent`, `navRollover`, `navHref`, `navTitle`, `navText`, `navApplication`, `navShow`, `navActive`, `navOrder`) VALUES
(1, 'Home', 0, 'Go to the homepage', '', 'Homepage', 'Homepage', 0, 1, 1, 0),
(2, 'Skilllsmap', 0, 'Skillsmap', 'skillsmap/', 'Skillsmap', 'Skillsmap', 1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `profiles`
--

DROP TABLE IF EXISTS `profiles`;
CREATE TABLE IF NOT EXISTS `profiles` (
  `profileID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `profileName` varchar(32) NOT NULL,
  `profileSeoName` varchar(32) NOT NULL,
  `profileCompany` int(10) unsigned NOT NULL DEFAULT '0',
  `profileEmail` varchar(320) NOT NULL,
  `profileAddress` tinytext NOT NULL,
  `profileTown` varchar(32) NOT NULL,
  `profilePostcode` varchar(9) NOT NULL,
  `profileLat` float(10,6) DEFAULT NULL,
  `profileLng` float(10,6) DEFAULT NULL,
  `profileTelephone` varchar(11) NOT NULL DEFAULT '',
  `profileDescription` text NOT NULL,
  `profileImage` varchar(32) NOT NULL DEFAULT '',
  `profileWebsite` varchar(255) NOT NULL DEFAULT '',
  `profileTwitter` varchar(64) NOT NULL DEFAULT '',
  `profileSkype` varchar(64) NOT NULL DEFAULT '',
  `profilePublish` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `profileApproved` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`profileID`),
  FULLTEXT KEY `title` (`profileName`,`profileSeoName`,`profileTown`),
  FULLTEXT KEY `profileDescription` (`profileDescription`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `profiles`
--

INSERT INTO `profiles` (`profileID`, `profileName`, `profileSeoName`, `profileCompany`, `profileEmail`, `profileAddress`, `profileTown`, `profilePostcode`, `profileLat`, `profileLng`, `profileTelephone`, `profileDescription`, `profileImage`, `profileWebsite`, `profileTwitter`, `profileSkype`, `profilePublish`, `profileApproved`) VALUES
(1, 'Will Earp', 'hexydec', 0, 'will@hexydec.com', '', 'Plymouth', 'PL3 4BB', 50.382095, -4.160899, '07816322175', 'We specialise in developing dynamic, feature rich Internet solutions and products for our clients that add value to business by offering an intuitive user-experience, website scalability and performance, and enabling Website administrators to manage their content using our in-house developed content management systems.\r\n\r\nUsing the latest open-source technology and standards compliance, we push the boundaries of innovation and technology to develop products and solutions that give our customers the tools they require to effectively harness the power of the internet and reach their customers.', '', 'http://hexydec.com/', 'hexydec', '', 1, 1),
(2, 'Mat Connolley', 'mat-connolley', 0, '', '', 'Lostwithiel', 'PL22 0AW', 50.409027, -4.671869, '01208873242', 'Iteracy offer excellent value web design services tailored to small businesses as well as long-term development partnerships to suit expanding web agencies.\r\n\r\nIf you''ve been putting off making your website, or you''ve had enough of your current designers and want something new, have a look at our portfolio and then give us a call. ', '', 'http://www.iteracy.com/', '', '', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `profileskills`
--

DROP TABLE IF EXISTS `profileskills`;
CREATE TABLE IF NOT EXISTS `profileskills` (
  `psID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `psProfile` int(10) unsigned NOT NULL,
  `psSkill` int(10) unsigned NOT NULL,
  `psInterest` enum('Can do if I must','I quite like doing this','This is where the heart is') NOT NULL,
  `psLevel` enum('Beginner','Intermediate','Expert') NOT NULL,
  PRIMARY KEY (`psID`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `profileskills`
--

INSERT INTO `profileskills` (`psID`, `psProfile`, `psSkill`, `psInterest`, `psLevel`) VALUES
(1, 1, 1, 'This is where the heart is', 'Expert'),
(2, 1, 2, 'This is where the heart is', 'Expert'),
(3, 1, 4, 'This is where the heart is', 'Expert'),
(4, 1, 5, 'This is where the heart is', 'Expert'),
(5, 1, 6, 'This is where the heart is', 'Expert'),
(6, 2, 1, 'This is where the heart is', 'Expert'),
(7, 2, 2, 'This is where the heart is', 'Intermediate'),
(8, 2, 7, 'Can do if I must', 'Beginner');

-- --------------------------------------------------------

--
-- Table structure for table `skillgroups`
--

DROP TABLE IF EXISTS `skillgroups`;
CREATE TABLE IF NOT EXISTS `skillgroups` (
  `sgID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sgName` varchar(32) NOT NULL,
  `sgDescription` tinytext NOT NULL,
  PRIMARY KEY (`sgID`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `skillgroups`
--

INSERT INTO `skillgroups` (`sgID`, `sgName`, `sgDescription`) VALUES
(1, 'Web Design', 'Web design skills'),
(2, 'Web Development', 'Web Development Skill');

-- --------------------------------------------------------

--
-- Table structure for table `skills`
--

DROP TABLE IF EXISTS `skills`;
CREATE TABLE IF NOT EXISTS `skills` (
  `skillID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `skillGroup` int(10) unsigned NOT NULL,
  `skillName` varchar(32) NOT NULL,
  `skillDescription` tinytext NOT NULL,
  PRIMARY KEY (`skillID`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `skills`
--

INSERT INTO `skills` (`skillID`, `skillGroup`, `skillName`, `skillDescription`) VALUES
(1, 1, 'XHTML', 'eXtensible Markup Language including HTML5'),
(2, 1, 'CSS', 'Cascading Style Sheets'),
(3, 1, 'Javascript', 'General javascript including DOM and JSON'),
(4, 1, 'jQuery', 'Skills using the jQuery framework'),
(5, 2, 'PHP', 'Hypertext Pre-Processor, serverside scripting language'),
(6, 2, 'MySQL', 'Open source database'),
(7, 2, 'Ruby on Rails', 'Server side programming language');
