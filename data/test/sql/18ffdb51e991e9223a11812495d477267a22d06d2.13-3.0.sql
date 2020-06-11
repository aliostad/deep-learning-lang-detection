3.0;
INSERT IGNORE INTO  `%DB_PREFIX%role_nav` (`id` ,`name` ,`status` ,`sort`)VALUES ('1',  '首页',  '1',  '1');
INSERT IGNORE INTO  `%DB_PREFIX%role_node` (`id` ,`action` ,`action_name` ,`status` ,`module` ,`module_name` ,`nav_id` ,`sort` ,`auth_type` ,`is_show`)VALUES ('234',  'index',  '首页',  '1',  'Top',  '首页',  '1',  '1',  '0',  '1');
INSERT IGNORE INTO  `%DB_PREFIX%role_node` (`id` ,`action` ,`action_name` ,`status` ,`module` ,`module_name` ,`nav_id` ,`sort` ,`auth_type` ,`is_show`)VALUES ('235',  '',  '',  '1',  'Top',  '首页',  '1',  '1',  '1',  '1');
INSERT IGNORE INTO `%DB_PREFIX%role_access` (`role_id` ,`node_id`) VALUES (1,235);
INSERT IGNORE INTO `%DB_PREFIX%sys_conf` VALUES ('SITE_VIDEO', '', '1', '5', '4', '', '1', '1', '0');

INSERT IGNORE INTO `%DB_PREFIX%sharegoods_module` (`id`, `class`, `domain`, `status`, `name`, `url`, `icon`, `logo`, `content`, `api_data`, `sort`) VALUES
(3, 'taobao', 'http://item.taobao.com,http://item.tmall.com', 1, '淘宝', 'http://www.taobao.com', './public/upload/business/taobao.gif', '', '淘宝应用用于获取淘宝商品、店铺信息，可到 http://open.taobao.com/ 点击 申请成为合作伙伴 ', 'a:3:{s:7:"app_key";s:8:"12300965";s:10:"app_secret";s:32:"329b93d2fee4b48dcfcdf12438c5fbd8";s:6:"tk_pid";s:8:"21055604";}', 100),
(4, 'paipai', 'http://auction1.paipai.com', 1, '拍拍', 'http://www.paipai.com', './public/upload/business/paipai.gif', '', '拍拍应用用于获取拍拍商品、店铺信息，可到 http://pop.paipai.com/ 点击 申请成为合作伙伴 ', 'a:4:{s:3:"uin";s:0:"";s:4:"spid";s:0:"";s:5:"token";s:0:"";s:6:"seckey";s:0:"";}', 100);

INSERT IGNORE INTO `%DB_PREFIX%role_node` (`id`, `action`, `action_name`, `status`, `module`, `module_name`, `nav_id`, `sort`, `auth_type`, `is_show`) VALUES
(4, '', '', 1, 'SharegoodsModule', '商品接口管理', 7, 9, 1, 0),
(5, 'index', '接口列表', 1, 'SharegoodsModule', '商品接口管理', 7, 10, 0, 1);

UPDATE `%DB_PREFIX%role_node` SET status=1,is_show=1 WHERE id=4 or id=5;

ALTER TABLE  `%DB_PREFIX%share` ADD  `check_status` TINYINT( 1 ) NOT NULL DEFAULT  '0';

ALTER TABLE  `%DB_PREFIX%share` ADD  `is_video` TINYINT( 1 ) NOT NULL DEFAULT  '0';

ALTER TABLE  `%DB_PREFIX%share` ADD INDEX (  `is_video` ) ;

INSERT IGNORE INTO `%DB_PREFIX%role_node` (`id`, `action`, `action_name`, `status`, `module`, `module_name`, `nav_id`, `sort`, `auth_type`, `is_show`) VALUES 
(2120,'', '', 1, 'UpYun', '又拍云存储API', 7, 10, 1, 1),
(2121,'index', '设置', 1, 'UpYun', '又拍云存储API', 7, 10, 0, 1);

INSERT IGNORE INTO `%DB_PREFIX%role_access` (`role_id`, `node_id`) VALUES (1, 2120);

ALTER TABLE  `%DB_PREFIX%share` CHANGE  `share_data`  `share_data` ENUM(  'goods',  'photo',  'default',  'video' ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT  'default';

UPDATE  `%DB_PREFIX%sys_conf` set val='huaban'  where name='SITE_TMPL';

UPDATE  `%DB_PREFIX%sys_conf` set val=0 where name='URL_MODEL';

UPDATE `%DB_PREFIX%sys_conf` SET `val` = '3.0' WHERE `name` = 'SYS_VERSION';