DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='xydzp' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='xydzp' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_xydzp`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='xydzp_jplist' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='xydzp_jplist' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_xydzp_jplist`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='xydzp_log' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='xydzp_log' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_xydzp_log`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='xydzp_option' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='xydzp_option' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_xydzp_option`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='xydzp_userlog' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='xydzp_userlog' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_xydzp_userlog`;


