-- phpMyAdmin SQL Dump
-- version 3.5.2.2
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1:3306
-- Generation Time: Oct 22, 2012 at 03:11 PM
-- Server version: 5.1.65-community-log
-- PHP Version: 5.3.17

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `dial_cms`
--

-- --------------------------------------------------------

--
-- Table structure for table `AuthAssignment`
--

CREATE TABLE IF NOT EXISTS `AuthAssignment` (
  `itemname` varchar(64) NOT NULL,
  `userid` varchar(64) NOT NULL,
  `bizrule` text,
  `data` text,
  PRIMARY KEY (`itemname`,`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `AuthAssignment`
--

INSERT INTO `AuthAssignment` (`itemname`, `userid`, `bizrule`, `data`) VALUES
('admin', 'adminD', NULL, 'N;'),
('author', 'authorB', NULL, 'N;'),
('editor', 'editorC', NULL, 'N;'),
('reader', 'readerA', NULL, 'N;');

-- --------------------------------------------------------

--
-- Table structure for table `AuthItem`
--

CREATE TABLE IF NOT EXISTS `AuthItem` (
  `name` varchar(64) NOT NULL,
  `type` int(11) NOT NULL,
  `description` text,
  `bizrule` text,
  `data` text,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `AuthItem`
--

INSERT INTO `AuthItem` (`name`, `type`, `description`, `bizrule`, `data`) VALUES
('admin', 2, '', NULL, 'N;'),
('author', 2, '', NULL, 'N;'),
('createPost', 0, 'создание записи', NULL, 'N;'),
('deletePost', 0, 'удаление записи', NULL, 'N;'),
('editor', 2, '', NULL, 'N;'),
('reader', 2, '', NULL, 'N;'),
('readPost', 0, 'просмотр записи', NULL, 'N;'),
('updateOwnPost', 1, 'редактирование своей записи', 'return Yii::app()->user->id==$params["post"]->authID;', 'N;'),
('updatePost', 0, 'редактирование записи', NULL, 'N;');

-- --------------------------------------------------------

--
-- Table structure for table `AuthItemChild`
--

CREATE TABLE IF NOT EXISTS `AuthItemChild` (
  `parent` varchar(64) NOT NULL,
  `child` varchar(64) NOT NULL,
  PRIMARY KEY (`parent`,`child`),
  KEY `child` (`child`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `AuthItemChild`
--

INSERT INTO `AuthItemChild` (`parent`, `child`) VALUES
('admin', 'author'),
('author', 'createPost'),
('admin', 'deletePost'),
('admin', 'editor'),
('author', 'reader'),
('editor', 'reader'),
('reader', 'readPost'),
('author', 'updateOwnPost'),
('editor', 'updatePost'),
('updateOwnPost', 'updatePost');

-- --------------------------------------------------------

--
-- Table structure for table `dial_label`
--

CREATE TABLE IF NOT EXISTS `dial_label` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `key` (`key`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=22 ;

--
-- Dumping data for table `dial_label`
--

INSERT INTO `dial_label` (`id`, `key`) VALUES
(8, 'LANG_ENGLISH'),
(7, 'LANG_RUSSIAN'),
(14, 'NAV_ADMIN'),
(13, 'NAV_ITEM_ARTICLES'),
(15, 'NAV_ITEM_CONFIG'),
(9, 'NAV_ITEM_HOME'),
(11, 'NAV_ITEM_LANGUAGES'),
(21, 'NAV_ITEM_PARENT'),
(12, 'NAV_ITEM_ROLES'),
(17, 'NAV_ITEM_SUB_1'),
(18, 'NAV_ITEM_SUB_2'),
(19, 'NAV_ITEM_SUB_3'),
(20, 'NAV_ITEM_TOOLS'),
(16, 'NAV_ITEM_TRANSLATE'),
(10, 'NAV_ITEM_USERS');

-- --------------------------------------------------------

--
-- Table structure for table `dial_language`
--

CREATE TABLE IF NOT EXISTS `dial_language` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(5) NOT NULL,
  `label` varchar(255) DEFAULT NULL,
  `default` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`,`label`),
  UNIQUE KEY `label` (`label`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `dial_language`
--

INSERT INTO `dial_language` (`id`, `code`, `label`, `default`) VALUES
(5, 'en-GB', 'LANG_ENGLISH', 1),
(6, 'ru-RU', 'LANG_RUSSIAN', 0);

-- --------------------------------------------------------

--
-- Table structure for table `dial_nav`
--

CREATE TABLE IF NOT EXISTS `dial_nav` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `admin` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `name_2` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `dial_nav`
--

INSERT INTO `dial_nav` (`id`, `name`, `admin`) VALUES
(1, 'NAV_ADMIN', 1);

-- --------------------------------------------------------

--
-- Table structure for table `dial_nav_item`
--

CREATE TABLE IF NOT EXISTS `dial_nav_item` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nav_id` int(10) unsigned NOT NULL,
  `pid` int(10) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `href` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `nav_id` (`nav_id`),
  KEY `pid` (`pid`),
  KEY `title` (`title`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=12 ;

--
-- Dumping data for table `dial_nav_item`
--

INSERT INTO `dial_nav_item` (`id`, `nav_id`, `pid`, `name`, `href`, `title`) VALUES
(1, 1, NULL, 'NAV_ITEM_HOME', '/', 'NAV_ITEM_HOME'),
(2, 1, NULL, 'NAV_ITEM_TOOLS', NULL, 'NAV_ITEM_TOOLS'),
(3, 1, 2, 'NAV_ITEM_ARTICLES', '/articles/', NULL),
(4, 1, NULL, 'NAV_ITEM_CONFIG', '/config/', NULL),
(5, 1, 2, 'NAV_ITEM_ROLES', '/users/roles/', NULL),
(6, 1, 2, 'NAV_ITEM_TRANSLATE', '/label/translate/', NULL),
(7, 1, 2, 'NAV_ITEM_USERS', '/users/', NULL),
(8, 1, NULL, 'NAV_ITEM_PARENT', NULL, NULL),
(9, 1, 8, 'NAV_ITEM_SUB_1', '/nav/sub/1/', NULL),
(10, 1, 8, 'NAV_ITEM_SUB_2', '/nav/sub/2/', NULL),
(11, 1, 8, 'NAV_ITEM_SUB_3', '/nav/sub/3/', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `dial_role`
--

CREATE TABLE IF NOT EXISTS `dial_role` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `dial_role`
--

INSERT INTO `dial_role` (`id`, `name`) VALUES
(3, 'administrator'),
(1, 'guest'),
(2, 'user');

-- --------------------------------------------------------

--
-- Table structure for table `dial_translate`
--

CREATE TABLE IF NOT EXISTS `dial_translate` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lang` int(11) unsigned NOT NULL,
  `label_id` int(11) unsigned DEFAULT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `label_id` (`label_id`),
  KEY `lang` (`lang`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `dial_translate`
--

INSERT INTO `dial_translate` (`id`, `lang`, `label_id`, `value`) VALUES
(3, 5, 8, 'English'),
(4, 5, 7, 'Russian'),
(5, 6, 7, 'Русский'),
(6, 6, 8, 'Английский');

-- --------------------------------------------------------

--
-- Table structure for table `dial_user`
--

CREATE TABLE IF NOT EXISTS `dial_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8 NOT NULL,
  `password` varchar(50) CHARACTER SET utf8 NOT NULL,
  `email` varchar(50) CHARACTER SET utf8 NOT NULL,
  `role_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`,`email`),
  KEY `role_id` (`role_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=cp1251 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `dial_user`
--

INSERT INTO `dial_user` (`id`, `name`, `password`, `email`, `role_id`) VALUES
(1, 'admin', '966327d37d389f1b44bc1bbff10d9e9a', 'admin@admin.com', 3),
(2, 'user', 'ee11cbb19052e40b07aac0ca060c23ee', 'user@user.com', 2);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `AuthAssignment`
--
ALTER TABLE `AuthAssignment`
  ADD CONSTRAINT `authassignment_ibfk_1` FOREIGN KEY (`itemname`) REFERENCES `authitem` (`name`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `AuthItemChild`
--
ALTER TABLE `AuthItemChild`
  ADD CONSTRAINT `authitemchild_ibfk_1` FOREIGN KEY (`parent`) REFERENCES `authitem` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `authitemchild_ibfk_2` FOREIGN KEY (`child`) REFERENCES `authitem` (`name`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `dial_language`
--
ALTER TABLE `dial_language`
  ADD CONSTRAINT `dial_language_ibfk_1` FOREIGN KEY (`label`) REFERENCES `dial_label` (`key`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `dial_nav`
--
ALTER TABLE `dial_nav`
  ADD CONSTRAINT `dial_nav_ibfk_1` FOREIGN KEY (`name`) REFERENCES `dial_label` (`key`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `dial_nav_item`
--
ALTER TABLE `dial_nav_item`
  ADD CONSTRAINT `dial_nav_item_ibfk_1` FOREIGN KEY (`name`) REFERENCES `dial_label` (`key`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `dial_nav_item_ibfk_2` FOREIGN KEY (`nav_id`) REFERENCES `dial_nav` (`id`),
  ADD CONSTRAINT `dial_nav_item_ibfk_3` FOREIGN KEY (`pid`) REFERENCES `dial_nav_item` (`id`),
  ADD CONSTRAINT `dial_nav_item_ibfk_4` FOREIGN KEY (`title`) REFERENCES `dial_label` (`key`);

--
-- Constraints for table `dial_translate`
--
ALTER TABLE `dial_translate`
  ADD CONSTRAINT `dial_translate_ibfk_2` FOREIGN KEY (`lang`) REFERENCES `dial_language` (`id`),
  ADD CONSTRAINT `dial_translate_ibfk_1` FOREIGN KEY (`label_id`) REFERENCES `dial_label` (`id`);

--
-- Constraints for table `dial_user`
--
ALTER TABLE `dial_user`
  ADD CONSTRAINT `dial_user_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `dial_role` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
