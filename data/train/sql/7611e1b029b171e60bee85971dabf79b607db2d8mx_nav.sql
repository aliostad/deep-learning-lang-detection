/*
Navicat MySQL Data Transfer

Source Server         : 127.0.0.1
Source Server Version : 50520
Source Host           : localhost:3306
Source Database       : dishes

Target Server Type    : MYSQL
Target Server Version : 50520
File Encoding         : 65001

Date: 2014-03-14 12:06:06
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `mx_nav`
-- ----------------------------
DROP TABLE IF EXISTS `mx_nav`;
CREATE TABLE `mx_nav` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '导航id',
  `val` varchar(50) COLLATE utf8_unicode_ci NOT NULL COMMENT '导航Action',
  `name` varchar(50) COLLATE utf8_unicode_ci NOT NULL COMMENT '导航名字',
  `show` tinyint(3) unsigned NOT NULL COMMENT '是否显示,0:需要权限过滤，1:无需过滤,直接显示',
  `tplshow` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '模版中是否显示，0:不现实，1:默认显示',
  `parentid` int(10) unsigned NOT NULL COMMENT '父id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='导航以及权限控制类';

-- ----------------------------
-- Records of mx_nav
-- ----------------------------
INSERT INTO `mx_nav` VALUES ('1', 'Index', '系统首页', '1', '1', '0');
INSERT INTO `mx_nav` VALUES ('2', 'Menu', '菜谱管理', '0', '1', '0');
INSERT INTO `mx_nav` VALUES ('3', 'Stream', '流水统计', '0', '1', '0');
INSERT INTO `mx_nav` VALUES ('4', 'Personal', '个人信息', '1', '1', '0');
INSERT INTO `mx_nav` VALUES ('5', 'System', '系统设置', '0', '1', '0');
INSERT INTO `mx_nav` VALUES ('6', 'Table', '餐桌设置', '0', '1', '0');
INSERT INTO `mx_nav` VALUES ('7', 'tabList', '桌号列表', '1', '1', '1');
INSERT INTO `mx_nav` VALUES ('8', 'free', '空闲中桌位', '1', '1', '1');
INSERT INTO `mx_nav` VALUES ('9', 'employ', '使用中桌位', '1', '1', '1');
INSERT INTO `mx_nav` VALUES ('11', 'invoicing', '已结账订单', '1', '1', '1');
INSERT INTO `mx_nav` VALUES ('12', 'typeList', '分类列表', '0', '1', '2');
INSERT INTO `mx_nav` VALUES ('13', 'addType', '添加分类', '0', '1', '2');
INSERT INTO `mx_nav` VALUES ('14', 'menuList', '菜谱列表', '0', '1', '2');
INSERT INTO `mx_nav` VALUES ('15', 'editMenu', '添加菜谱', '0', '1', '2');
INSERT INTO `mx_nav` VALUES ('16', 'hotMenu', '热卖菜', '0', '1', '2');
INSERT INTO `mx_nav` VALUES ('17', 'material', '素材列表', '0', '1', '2');
INSERT INTO `mx_nav` VALUES ('18', 'day', '今日流水', '0', '1', '3');
INSERT INTO `mx_nav` VALUES ('19', 'week', '周流水', '0', '1', '3');
INSERT INTO `mx_nav` VALUES ('20', 'month', '月流水', '0', '1', '3');
INSERT INTO `mx_nav` VALUES ('21', 'all', '总流水', '0', '1', '3');
INSERT INTO `mx_nav` VALUES ('22', 'password', '修改密码', '1', '1', '4');
INSERT INTO `mx_nav` VALUES ('23', 'info', '修改个人信息', '1', '1', '4');
INSERT INTO `mx_nav` VALUES ('24', 'adminList', '操作员', '0', '1', '5');
INSERT INTO `mx_nav` VALUES ('25', 'editAdmin', '添加操作员', '0', '1', '5');
INSERT INTO `mx_nav` VALUES ('26', 'logs', '日志', '0', '1', '5');
INSERT INTO `mx_nav` VALUES ('27', 'tableList', '餐桌列表', '0', '1', '6');
INSERT INTO `mx_nav` VALUES ('28', 'areaList', '区域列表', '0', '1', '6');
INSERT INTO `mx_nav` VALUES ('29', 'editArea', '添加区域', '0', '1', '6');
INSERT INTO `mx_nav` VALUES ('30', 'editTable', '添加餐桌', '0', '1', '6');
INSERT INTO `mx_nav` VALUES ('31', 'reserve', '已预定桌位', '1', '1', '1');
INSERT INTO `mx_nav` VALUES ('32', 'nowStore', '本店设置', '0', '1', '5');
INSERT INTO `mx_nav` VALUES ('33', 'addMaterial', '添加素材', '0', '1', '2');
INSERT INTO `mx_nav` VALUES ('34', 'modifStatus', '更改餐桌状态', '0', '0', '6');
