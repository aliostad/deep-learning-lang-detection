ALTER TABLE `#__pf_settings` CHANGE `value` `content` TEXT NOT NULL;
ALTER TABLE `#__pf_settings` ADD INDEX `idx_parameter` ( `parameter` ( 12 ) );
ALTER TABLE `#__pf_settings` ADD INDEX `idx_scope` ( `scope` ( 12 ) );
ALTER TABLE `#__pf_settings` ADD INDEX `idx_paramscope` ( `parameter` ( 12 ) , `scope` ( 12 ) );
ANALYZE TABLE `#__pf_settings`;
OPTIMIZE TABLE `#__pf_settings`;

UPDATE `#__pf_settings` SET `parameter` = 'installed' WHERE `scope` = 'system' AND `parameter` = 'is_installed';

DELETE FROM `#__pf_settings` WHERE `scope` = 'cp_events';
DELETE FROM `#__pf_settings` WHERE `scope` = 'cp_project';
DELETE FROM `#__pf_settings` WHERE `scope` = 'cp_tasks';
DELETE FROM `#__pf_settings` WHERE `scope` = 'cp_weblinks';
DELETE FROM `#__pf_settings` WHERE `scope` = 'nav_calendar';
DELETE FROM `#__pf_settings` WHERE `scope` = 'system' AND `parameter` = 'tooltip_restricted';

INSERT INTO `#__pf_settings` VALUES(NULL, 'use_score', '1', 'system');

INSERT INTO `#__pf_settings` VALUES(NULL, 'limit', '10', 'cp_tasks');
INSERT INTO `#__pf_settings` VALUES(NULL, 'ob', 't.edate', 'cp_tasks');
INSERT INTO `#__pf_settings` VALUES(NULL, 'od', 'ASC', 'cp_tasks');
INSERT INTO `#__pf_settings` VALUES(NULL, 'assigned', '2', 'cp_tasks');
INSERT INTO `#__pf_settings` VALUES(NULL, 'status', '1', 'cp_tasks');
INSERT INTO `#__pf_settings` VALUES(NULL, 'priority', '0', 'cp_tasks');
INSERT INTO `#__pf_settings` VALUES(NULL, 'show_title', '1', 'cp_tasks');
INSERT INTO `#__pf_settings` VALUES(NULL, 'override_title', 'PFL_TASKS', 'cp_tasks');

INSERT INTO `#__pf_settings` VALUES(NULL, 'show_title', '1', 'cp_weblinks');
INSERT INTO `#__pf_settings` VALUES(NULL, 'pflinks', '1', 'cp_weblinks');

INSERT INTO `#__pf_settings` VALUES(NULL, 'show_title', '0', 'nav_section_subnav');

INSERT INTO `#__pf_settings` VALUES(NULL, 'show_title', '1', 'cp_installer');

INSERT INTO `#__pf_settings` VALUES(NULL, 'use_progpercent', '1', 'tasks');