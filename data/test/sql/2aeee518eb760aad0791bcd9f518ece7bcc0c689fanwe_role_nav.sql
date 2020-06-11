/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50151
Source Host           : localhost:3306
Source Database       : zuilv

Target Server Type    : MYSQL
Target Server Version : 50151
File Encoding         : 65001

Date: 2012-02-29 14:13:58
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `fanwe_role_nav`
-- ----------------------------
DROP TABLE IF EXISTS `fanwe_role_nav`;
CREATE TABLE `fanwe_role_nav` (
  `id` mediumint(8) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL DEFAULT '',
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `sort` smallint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of fanwe_role_nav
-- ----------------------------
INSERT INTO `fanwe_role_nav` VALUES ('2', '分享', '1', '2');
INSERT INTO `fanwe_role_nav` VALUES ('4', '会员', '1', '4');
INSERT INTO `fanwe_role_nav` VALUES ('5', '权限', '1', '5');
INSERT INTO `fanwe_role_nav` VALUES ('6', '数据库', '1', '6');
INSERT INTO `fanwe_role_nav` VALUES ('7', '系统', '1', '7');
INSERT INTO `fanwe_role_nav` VALUES ('10', '杂志社', '1', '3');
INSERT INTO `fanwe_role_nav` VALUES ('11', '手机', '1', '8');
