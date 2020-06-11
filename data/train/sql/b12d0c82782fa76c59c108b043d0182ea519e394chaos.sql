/*
Navicat MySQL Data Transfer

Source Server         : local
Source Server Version : 50547
Source Host           : localhost:3306
Source Database       : rulemanage

Target Server Type    : MYSQL
Target Server Version : 50547
File Encoding         : 65001

Date: 2017-08-15 07:49:24
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `chaos_admin_nav`
-- ----------------------------
DROP TABLE IF EXISTS `chaos_admin_nav`;
CREATE TABLE `chaos_admin_nav` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '菜单表',
  `pid` int(11) unsigned DEFAULT '0' COMMENT '所属菜单',
  `name` varchar(15) DEFAULT '' COMMENT '菜单名称',
  `mca` varchar(255) DEFAULT '' COMMENT '模块、控制器、方法',
  `ico` varchar(20) DEFAULT '' COMMENT 'font-awesome图标',
  `order_number` int(11) unsigned DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=76 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of chaos_admin_nav
-- ----------------------------
INSERT INTO `chaos_admin_nav` VALUES ('44', '2', '菜单管理', 'admin/nav/index', '', null);
INSERT INTO `chaos_admin_nav` VALUES ('45', '2', '菜单添加', 'admin/nav/add', '', null);
INSERT INTO `chaos_admin_nav` VALUES ('2', '0', '系统设置', 'admin/nav/index', '', '1');
INSERT INTO `chaos_admin_nav` VALUES ('68', '2', '权限管理', 'admin/authRule/index', '', null);
INSERT INTO `chaos_admin_nav` VALUES ('69', '2', '权限添加', 'admin/authRule/add', '', null);
INSERT INTO `chaos_admin_nav` VALUES ('71', '2', '用户组管理', 'admin/authRule/group', '', null);
INSERT INTO `chaos_admin_nav` VALUES ('72', '2', '添加用户组', 'admin/authRule/addGroup', '', null);
INSERT INTO `chaos_admin_nav` VALUES ('73', '2', '用户列表', 'admin/AuthRule/adminUserList', '', null);
INSERT INTO `chaos_admin_nav` VALUES ('74', '2', '添加用户', 'admin/AuthRule/addUser', '', null);
INSERT INTO `chaos_admin_nav` VALUES ('75', '0', '首页', 'admin/index/index', '', null);

-- ----------------------------
-- Table structure for `chaos_auth_group`
-- ----------------------------
DROP TABLE IF EXISTS `chaos_auth_group`;
CREATE TABLE `chaos_auth_group` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `title` char(100) NOT NULL DEFAULT '',
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `rules` char(80) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of chaos_auth_group
-- ----------------------------
INSERT INTO `chaos_auth_group` VALUES ('1', '管理员', '1', '19,5,6,7,8,10,18,24,25,26,27,28,13,14,15,16,20,21,22,23,29');
INSERT INTO `chaos_auth_group` VALUES ('4', 'test', '1', '');
INSERT INTO `chaos_auth_group` VALUES ('5', 'test2', '1', '');
INSERT INTO `chaos_auth_group` VALUES ('7', '普通用户', '1', '');

-- ----------------------------
-- Table structure for `chaos_auth_group_access`
-- ----------------------------
DROP TABLE IF EXISTS `chaos_auth_group_access`;
CREATE TABLE `chaos_auth_group_access` (
  `uid` mediumint(8) unsigned NOT NULL,
  `group_id` mediumint(8) unsigned NOT NULL,
  UNIQUE KEY `uid_group_id` (`uid`,`group_id`),
  KEY `uid` (`uid`),
  KEY `group_id` (`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of chaos_auth_group_access
-- ----------------------------
INSERT INTO `chaos_auth_group_access` VALUES ('1', '1');
INSERT INTO `chaos_auth_group_access` VALUES ('2', '1');

-- ----------------------------
-- Table structure for `chaos_auth_rule`
-- ----------------------------
DROP TABLE IF EXISTS `chaos_auth_rule`;
CREATE TABLE `chaos_auth_rule` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `pid` mediumint(8) NOT NULL,
  `name` char(80) NOT NULL DEFAULT '',
  `title` char(20) NOT NULL DEFAULT '',
  `type` tinyint(1) NOT NULL DEFAULT '1',
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `condition` char(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of chaos_auth_rule
-- ----------------------------
INSERT INTO `chaos_auth_rule` VALUES ('27', '5', 'admin/AuthRule/editUser', '修改用户', '1', '1', '');
INSERT INTO `chaos_auth_rule` VALUES ('5', '19', 'admin/nav/index', '菜单管理', '1', '1', '');
INSERT INTO `chaos_auth_rule` VALUES ('6', '5', 'admin/nav/add', '菜单添加', '1', '1', '');
INSERT INTO `chaos_auth_rule` VALUES ('7', '5', 'admin/nav/delete', '菜单删除', '1', '1', '');
INSERT INTO `chaos_auth_rule` VALUES ('8', '5', 'admin/nav/edit', '菜单添加', '1', '1', '');
INSERT INTO `chaos_auth_rule` VALUES ('29', '0', 'admin/index/index', '首页', '1', '1', '');
INSERT INTO `chaos_auth_rule` VALUES ('10', '5', 'admin/nav/order', '菜单排序', '1', '1', '');
INSERT INTO `chaos_auth_rule` VALUES ('18', '5', 'admin/authRule/group', '用户组管理', '1', '1', '');
INSERT INTO `chaos_auth_rule` VALUES ('13', '19', 'admin/authRule/index', '权限管理', '1', '1', '');
INSERT INTO `chaos_auth_rule` VALUES ('14', '13', 'admin/authRule/add', '权限添加', '1', '1', '');
INSERT INTO `chaos_auth_rule` VALUES ('15', '13', 'admin/authRule/delete', '权限删除', '1', '1', '');
INSERT INTO `chaos_auth_rule` VALUES ('16', '13', 'admin/authRule/edit', '权限修改', '1', '1', '');
INSERT INTO `chaos_auth_rule` VALUES ('19', '0', 'admin/nav/', '系统管理', '1', '1', '');
INSERT INTO `chaos_auth_rule` VALUES ('20', '19', 'admin/authRule', '用户组权限管理', '1', '1', '');
INSERT INTO `chaos_auth_rule` VALUES ('21', '20', 'admin/authRule/ruleGroup', '用户组权限分配', '1', '1', '');
INSERT INTO `chaos_auth_rule` VALUES ('22', '20', 'admin/authRule/deleteGroup', '删除用户组', '1', '1', '');
INSERT INTO `chaos_auth_rule` VALUES ('23', '20', 'admin/authRule/editGroup', '用户组修改', '1', '1', '');
INSERT INTO `chaos_auth_rule` VALUES ('24', '5', 'admin/authRule/addGroup', '添加用户组', '1', '1', '');
INSERT INTO `chaos_auth_rule` VALUES ('25', '5', 'admin/AuthRule/adminUserList', '用户列表', '1', '1', '');
INSERT INTO `chaos_auth_rule` VALUES ('26', '5', 'admin/AuthRule/addUser', '添加用户', '1', '1', '');
INSERT INTO `chaos_auth_rule` VALUES ('28', '5', 'admin/AuthRule/editUserGroup', '修改用户所属组', '1', '1', '');

-- ----------------------------
-- Table structure for `chaos_user`
-- ----------------------------
DROP TABLE IF EXISTS `chaos_user`;
CREATE TABLE `chaos_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of chaos_user
-- ----------------------------
INSERT INTO `chaos_user` VALUES ('1', 'chaos', '202cb962ac59075b964b07152d234b70');
INSERT INTO `chaos_user` VALUES ('2', 'chaos2', '202cb962ac59075b964b07152d234b70');
