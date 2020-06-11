/***************************江苏移动 added by frank******************************************/
ALTER TABLE `bss_panel_package`
ADD COLUMN `version`  bigint(19) NULL DEFAULT NULL AFTER `district_code`,
ADD COLUMN `max_page_number`  int(3) NULL DEFAULT NULL AFTER `version`,
ADD COLUMN `default_background`  varchar(255) NULL DEFAULT NULL AFTER `max_page_number`,
ADD COLUMN `common_top_nav`  varchar(128) NULL DEFAULT NULL AFTER `default_background`,
ADD COLUMN `zip_url`  varchar(128) NULL DEFAULT NULL AFTER `common_top_nav`,
ADD COLUMN `zipUrl1080p`  varchar(128) NULL DEFAULT NULL AFTER `zip_url`;

ALTER TABLE `bss_panel`
ADD COLUMN `version`  bigint(19) NULL DEFAULT NULL AFTER `district_code`,
ADD COLUMN `resolution`  varchar(10) NULL DEFAULT NULL AFTER `version`;

ALTER TABLE `bss_panel_item`
ADD COLUMN `version`  bigint(19) NULL DEFAULT NULL AFTER `category_id`,
ADD COLUMN `defaultfocus`  varchar(10) NULL DEFAULT NULL AFTER `version`,
ADD COLUMN `params`  varchar(1024) NULL DEFAULT NULL AFTER `defaultfocus`,
ADD COLUMN `resolution`  varchar(10) NULL DEFAULT NULL AFTER `params`;

ALTER TABLE `bss_panel_nav_define`
ADD COLUMN `version`  bigint(19) NULL DEFAULT NULL AFTER `update_time`,
ADD COLUMN `focus_img`  varchar(255) NULL DEFAULT NULL AFTER `version`,
ADD COLUMN `current_page_img`  varchar(255) NULL DEFAULT NULL AFTER `focus_img`,
ADD COLUMN `top_nav_type`  varchar(30) NULL DEFAULT NULL AFTER `current_page_img`,
ADD COLUMN `align`  varchar(10) NULL DEFAULT NULL AFTER `top_nav_type`,
ADD COLUMN `canfocus`  varchar(10) NULL DEFAULT NULL AFTER `align`,
ADD COLUMN `params`  varchar(1024) NULL DEFAULT NULL AFTER `canfocus`,
ADD COLUMN `resolution`  varchar(10) NULL DEFAULT NULL AFTER `params`;

ALTER TABLE `bss_panel_package_panel_map`
ADD COLUMN `opr_userid`  bigint(19) NULL DEFAULT NULL AFTER `is_lock`,
ADD COLUMN `create_time`  datetime NULL DEFAULT NULL AFTER `opr_userid`,
ADD COLUMN `update_time`  datetime NULL DEFAULT NULL AFTER `create_time`;




