DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='reserve' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='reserve' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_reserve`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='reserve_attribute' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='reserve_attribute' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_reserve_attribute`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='reserve_value' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='reserve_value' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_reserve_value`;


DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='reserve_option' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='reserve_option' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_reserve_option`;


