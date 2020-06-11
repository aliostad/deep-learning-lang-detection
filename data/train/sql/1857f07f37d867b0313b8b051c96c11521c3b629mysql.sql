CREATE TABLE `nav_bar` (
  `id` TINYINT(5) NOT NULL AUTO_INCREMENT,
  `name` CHAR(50) NOT NULL,
  `tip` CHAR(50) NOT NULL DEFAULT '',
  `parent_id` TINYINT(5) NOT NULL,
  `sort_id` TINYINT(5) NOT NULL,
  `permission` TINYINT(2) NOT NULL DEFAULT 31,#11111   ·Ö±ð´ú±í É¾ ¸Ä Ôö ²é ä¯ÀÀ
  `group` CHAR(20) NOT NULL DEFAULT '',
  `use_flag` TINYINT(1) NOT NULL DEFAULT 1,
  `delete_flag` TINYINT(1) NOT NULL DEFAULT 0,
  `insert_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `patent_use_delete_sort`(`parent_id`,`use_flag`,`delete_flag`,`sort_id`)
)ENGINE = MYISAM  AUTO_INCREMENT=10  DEFAULT CHARSET=utf8;