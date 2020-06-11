DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='shop_cart' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='shop_cart' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_shop_cart`;

DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='shop_address' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='shop_address' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_shop_address`;

DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='shop' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='shop' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_shop`;

DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='shop_slideshow' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='shop_slideshow' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_shop_slideshow`;

DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='shop_order_log' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='shop_order_log' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_shop_order_log`;

DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='shop_order' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='shop_order' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_shop_order`;

DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='shop_goods_score' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='shop_goods_score' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_shop_goods_score`;

DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='shop_goods_category' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='shop_goods_category' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_shop_goods_category`;

DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='shop_goods' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='shop_goods' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_shop_goods`;

DELETE FROM `wp_attribute` WHERE model_id = (SELECT id FROM wp_model WHERE `name`='shop_collect' ORDER BY id DESC LIMIT 1);
DELETE FROM `wp_model` WHERE `name`='shop_collect' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `wp_shop_collect`;