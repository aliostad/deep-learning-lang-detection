CREATE TABLE `bss_panel_img_box` (
  `id` bigint(19) NOT NULL,
  `img_box_id` bigint(19) NOT NULL,
  `item_id` bigint(19) DEFAULT NULL,
  `title` varchar(256) DEFAULT NULL,
  `img_url` varchar(1000) NOT NULL,
  `action_url` varchar(1000) DEFAULT NULL,
  `progrom_id` bigint(19) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8


CREATE TABLE `bss_panel_nav_box` (
  `id` bigint(19) NOT NULL,
  `nav_box_id` bigint(19) NOT NULL,
  `title` varchar(256) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8


CREATE TABLE `bss_panel_text_box` (
  `id` bigint(19) NOT NULL AUTO_INCREMENT,
  `text_box_id` bigint(19) NOT NULL,
  `title` varchar(256) NOT NULL,
  `is_new` tinyint(2) NOT NULL,
  `progrom_id` bigint(19) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8

ALTER TABLE `bss_city`
ADD COLUMN `leader_id`  bigint(19) NULL AFTER `create_date`;