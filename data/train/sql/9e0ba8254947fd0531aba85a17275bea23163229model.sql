DROP TABLE IF EXISTS `{{thread}}`;
DROP TABLE IF EXISTS `{{thread_attention}}`;
DROP TABLE IF EXISTS `{{thread_relation}}`;
DROP TABLE IF EXISTS `{{thread_reader}}`;

DELETE FROM `{{nav}}` WHERE `module` = 'thread';
DELETE FROM `{{node}}` WHERE `module` = 'thread';
DELETE FROM `{{node_related}}` WHERE `module` = 'thread';
DELETE FROM `{{auth_item}}` WHERE `name` LIKE 'thread%';
DELETE FROM `{{auth_item_child}}` WHERE `child` LIKE 'thread%';
DELETE FROM `{{menu_common}}` WHERE `module` = 'thread';
DELETE FROM `{{menu}}` WHERE `m` = 'thread';