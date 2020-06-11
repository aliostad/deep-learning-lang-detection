/*
MySQL Backup
Source Server Version: 5.5.40
Source Database: fuzhuang
Date: 2014/12/25 18:12:30
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
--  Table structure for `design`
-- ----------------------------
DROP TABLE IF EXISTS `design`;
CREATE TABLE `design` (
  `id` int(11) NOT NULL,
  `nav_pid` int(11) DEFAULT NULL,
  `nav_id` int(11) DEFAULT NULL,
  `design_title` varchar(255) DEFAULT NULL,
  `design_desc` varchar(1000) DEFAULT NULL,
  `design_content` text,
  `design_photo` varchar(255) DEFAULT NULL,
  `design_order` int(11) DEFAULT NULL,
  `design_status` int(11) DEFAULT NULL,
  `add_time` int(22) DEFAULT NULL,
  `release_time` int(22) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `nav_page`
-- ----------------------------
DROP TABLE IF EXISTS `nav_page`;
CREATE TABLE `nav_page` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) DEFAULT NULL,
  `nav_title` varchar(255) DEFAULT NULL,
  `nav_desc` varchar(1000) DEFAULT NULL,
  `nav_photo` varchar(255) NOT NULL,
  `nav_order` int(11) DEFAULT NULL,
  `add_time` int(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `news`
-- ----------------------------
DROP TABLE IF EXISTS `news`;
CREATE TABLE `news` (
  `id` int(11) NOT NULL,
  `nav_pid` int(11) DEFAULT NULL,
  `nav_id` int(11) DEFAULT NULL,
  `news_title` varchar(255) DEFAULT NULL,
  `news_desc` varchar(1000) DEFAULT NULL,
  `news_content` text,
  `news_photo` varchar(255) DEFAULT NULL,
  `add_time` int(20) DEFAULT NULL,
  `release_time` int(20) DEFAULT NULL,
  `news_status` int(11) DEFAULT NULL,
  `news_order` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `page_content`
-- ----------------------------
DROP TABLE IF EXISTS `page_content`;
CREATE TABLE `page_content` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nav_id` int(11) DEFAULT NULL,
  `content` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `product`
-- ----------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nav_pid` int(11) DEFAULT NULL,
  `nav_id` int(11) DEFAULT NULL,
  `product_title` varchar(255) DEFAULT NULL,
  `product_desc` varchar(1000) DEFAULT NULL,
  `product_order` int(11) DEFAULT NULL,
  `product_brand_id` int(11) DEFAULT NULL,
  `product_url` varchar(100) DEFAULT NULL,
  `mtitle` varchar(255) DEFAULT NULL,
  `mkey` varchar(255) DEFAULT NULL,
  `mdesc` varchar(255) DEFAULT NULL,
  `add_time` int(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `product_content`
-- ----------------------------
DROP TABLE IF EXISTS `product_content`;
CREATE TABLE `product_content` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `content1` text,
  `content2` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `product_images`
-- ----------------------------
DROP TABLE IF EXISTS `product_images`;
CREATE TABLE `product_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `big_photo` varchar(255) DEFAULT NULL,
  `small_photo` varchar(255) DEFAULT NULL,
  `photo_desc` varchar(1000) DEFAULT NULL,
  `photo_order` int(11) DEFAULT NULL,
  `add_time` int(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `user_admin`
-- ----------------------------
DROP TABLE IF EXISTS `user_admin`;
CREATE TABLE `user_admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(25) DEFAULT NULL,
  `password` varchar(25) DEFAULT NULL,
  `real_name` varchar(25) NOT NULL,
  `tel` int(11) NOT NULL,
  `mobile_phone` int(11) NOT NULL,
  `email` varchar(25) NOT NULL,
  `qq` varchar(24) NOT NULL,
  `company` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `zipcode` varchar(20) NOT NULL,
  `user_status` int(1) NOT NULL DEFAULT '0',
  `add_time` int(25) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records 
-- ----------------------------
