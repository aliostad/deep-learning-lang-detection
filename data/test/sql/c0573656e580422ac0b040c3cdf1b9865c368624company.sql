/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50615
Source Host           : localhost:3306
Source Database       : company

Target Server Type    : MYSQL
Target Server Version : 50615
File Encoding         : 65001

Date: 2014-06-23 13:33:38
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(255) DEFAULT '',
  `user_word` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES ('2', 'myadmin', '691c360156c27261b40c974ec0bf8f4a');

-- ----------------------------
-- Table structure for admin_menu
-- ----------------------------
DROP TABLE IF EXISTS `admin_menu`;
CREATE TABLE `admin_menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT '0',
  `menu_name` varchar(255) DEFAULT '',
  `menu_url` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of admin_menu
-- ----------------------------
INSERT INTO `admin_menu` VALUES ('1', '0', '站点设置', '');
INSERT INTO `admin_menu` VALUES ('2', '0', '文章中心', '');
INSERT INTO `admin_menu` VALUES ('3', '0', '产品中心', '');
INSERT INTO `admin_menu` VALUES ('4', '0', '留言中心', '');
INSERT INTO `admin_menu` VALUES ('5', '1', '站点信息', 'index.php?act=site_info');
INSERT INTO `admin_menu` VALUES ('6', '1', '导航管理', 'index.php?act=nav');
INSERT INTO `admin_menu` VALUES ('7', '1', '焦点图设置', 'index.php?act=focus_picture');
INSERT INTO `admin_menu` VALUES ('8', '2', '文章列表', 'index.php?act=article_list');
INSERT INTO `admin_menu` VALUES ('9', '2', '添加文章', 'index.php?act=article_add');
INSERT INTO `admin_menu` VALUES ('10', '2', '文章分类', 'index.php?act=article_type_list');
INSERT INTO `admin_menu` VALUES ('11', '2', '添加分类', 'index.php?act=article_type_add');
INSERT INTO `admin_menu` VALUES ('12', '3', '产品列表', 'index.php?act=product_list');
INSERT INTO `admin_menu` VALUES ('13', '3', '添加产品', 'index.php?act=product_add');
INSERT INTO `admin_menu` VALUES ('14', '3', '产品分类', 'index.php?act=product_type_list');
INSERT INTO `admin_menu` VALUES ('15', '3', '添加分类', 'index.php?act=product_type_add');
INSERT INTO `admin_menu` VALUES ('16', '4', '留言列表', 'index.php?act=message');
INSERT INTO `admin_menu` VALUES ('17', '5', '你好', '1');
INSERT INTO `admin_menu` VALUES ('18', '17', '好吗', '');
INSERT INTO `admin_menu` VALUES ('19', '18', '很好', '');
INSERT INTO `admin_menu` VALUES ('20', '17', '2B', '');
INSERT INTO `admin_menu` VALUES ('21', '17', '3B', '');
INSERT INTO `admin_menu` VALUES ('22', '17', '4b', '');
INSERT INTO `admin_menu` VALUES ('23', '21', 'gggg', '');

-- ----------------------------
-- Table structure for articles
-- ----------------------------
DROP TABLE IF EXISTS `articles`;
CREATE TABLE `articles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_id` int(11) DEFAULT '0',
  `title` varchar(255) DEFAULT '',
  `content` text,
  `add_time` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of articles
-- ----------------------------
INSERT INTO `articles` VALUES ('3', '3', 'sdczdd', '<p>asdasd</p>\r\n', '1401180014');

-- ----------------------------
-- Table structure for article_type
-- ----------------------------
DROP TABLE IF EXISTS `article_type`;
CREATE TABLE `article_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_name` varchar(255) DEFAULT '',
  `parent_id` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of article_type
-- ----------------------------
INSERT INTO `article_type` VALUES ('1', '牛牛你2', '0');
INSERT INTO `article_type` VALUES ('3', '啊飒沓啊', '0');

-- ----------------------------
-- Table structure for configs
-- ----------------------------
DROP TABLE IF EXISTS `configs`;
CREATE TABLE `configs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cf_name` varchar(255) DEFAULT '',
  `cf_value` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of configs
-- ----------------------------
INSERT INTO `configs` VALUES ('1', 'default_template', 'default');
INSERT INTO `configs` VALUES ('2', 'site_name', 'MadCms');
INSERT INTO `configs` VALUES ('3', 'site_dis', 'MadCms是一款对SEO非常友好的企业建站系统。系统内置SEO优化机制,界面简洁、方便操作。十年专注,已然成为企业建站服务的领导品牌。');
INSERT INTO `configs` VALUES ('4', 'keyword', 'MadCms|企业CMS|企业CMS系统|企业建站');
INSERT INTO `configs` VALUES ('5', 'email', 'admin@dearmadman.com');
INSERT INTO `configs` VALUES ('6', 'logo', '../images/20140522/140073719309121398.gif');

-- ----------------------------
-- Table structure for focus_picture
-- ----------------------------
DROP TABLE IF EXISTS `focus_picture`;
CREATE TABLE `focus_picture` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pic_url` varchar(255) DEFAULT '',
  `click_url` varchar(255) DEFAULT '',
  `pic_dis` varchar(255) DEFAULT '',
  `pic_index` int(11) DEFAULT '0',
  `title` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of focus_picture
-- ----------------------------

-- ----------------------------
-- Table structure for msg
-- ----------------------------
DROP TABLE IF EXISTS `msg`;
CREATE TABLE `msg` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT '',
  `email` varchar(255) DEFAULT '',
  `title` varchar(255) DEFAULT '',
  `msg` varchar(2048) DEFAULT '',
  `add_time` varchar(255) DEFAULT '',
  `is_recove` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of msg
-- ----------------------------
INSERT INTO `msg` VALUES ('2', '<script>alert<script>alert(\'123\');</script>', '<script>alert(\'123\');</script>', '<script>alert(\'123\');</script>', '<script>alert(\'123\');</script>', '<script>alert(\'123\');</script>', '0');

-- ----------------------------
-- Table structure for nav
-- ----------------------------
DROP TABLE IF EXISTS `nav`;
CREATE TABLE `nav` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nav_name` varchar(255) DEFAULT '',
  `nav_url` varchar(255) DEFAULT '',
  `is_blank` int(11) DEFAULT '0',
  `parent_id` int(11) DEFAULT '0',
  `z_index` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of nav
-- ----------------------------
INSERT INTO `nav` VALUES ('2', '撒旦发射', 'http://gggg/c', '0', '0', '22');
INSERT INTO `nav` VALUES ('10', '先行词', '啊', '1', '0', '0');
INSERT INTO `nav` VALUES ('6', '首页', 'http://www.97dfsc.com', '1', '0', '99');
INSERT INTO `nav` VALUES ('9', '阿萨萨达斯的', 'as大苏打', '1', '0', '0');
INSERT INTO `nav` VALUES ('8', '爱心', '123123123', '1', '0', '1');

-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_id` int(11) DEFAULT '0',
  `product_name` varchar(255) DEFAULT '',
  `product_dis` varchar(255) DEFAULT '',
  `product_imgurl` varchar(255) DEFAULT '',
  `add_time` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of product
-- ----------------------------
INSERT INTO `product` VALUES ('1', '3', 'asdassd', 'asdasdasdasdad', '../images/20140526/140108827108297119.jpg', '1401089633');
INSERT INTO `product` VALUES ('2', '2', 'guangm<scritp>alert(\"123\");</script>', 'asasdasdasd', '../images/20140526/140108932503855590.jpg', '1401089331');

-- ----------------------------
-- Table structure for product_type
-- ----------------------------
DROP TABLE IF EXISTS `product_type`;
CREATE TABLE `product_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_name` varchar(255) DEFAULT '',
  `parent_id` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of product_type
-- ----------------------------
INSERT INTO `product_type` VALUES ('2', '鸟', '0');
INSERT INTO `product_type` VALUES ('3', '鸟222', '0');
