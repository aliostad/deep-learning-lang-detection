DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='weisite_category' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='weisite_category' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_weisite_category`;

DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='weisite_slideshow' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='weisite_slideshow' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_weisite_slideshow`;

DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='weisite_footer' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='weisite_footer' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_weisite_footer`;

DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='scratch' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='scratch' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_scratch`;

DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='product' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='product' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_product`;