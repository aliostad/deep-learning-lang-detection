DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='youaskservice_behavior' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='youaskservice_behavior' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_youaskservice_behavior`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='youaskservice_group' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='youaskservice_group' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_youaskservice_group`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='youaskservice_keyword' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='youaskservice_keyword' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_youaskservice_keyword`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='youaskservice_logs' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='youaskservice_logs' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_youaskservice_logs`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='youaskservice_user' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='youaskservice_user' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_youaskservice_user`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='youaskservice_wechat_enddate' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='youaskservice_wechat_enddate' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_youaskservice_wechat_enddate`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='youaskservice_wechat_grouplist' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='youaskservice_wechat_grouplist' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_youaskservice_wechat_grouplist`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='youaskservice_wxlogs' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='youaskservice_wxlogs' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_youaskservice_wxlogs`;


