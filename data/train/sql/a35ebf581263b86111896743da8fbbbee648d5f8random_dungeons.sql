-- ----------------------------
-- Table structure for `random_dungeons`
-- ----------------------------
DROP TABLE IF EXISTS `random_dungeons`;
CREATE TABLE `random_dungeons` (
  `src_x` int(10) unsigned NOT NULL,
  `src_y` int(10) unsigned NOT NULL,
  `src_map_id` int(10) unsigned NOT NULL,
  `new_x1` int(10) unsigned NOT NULL DEFAULT '0',
  `new_y1` int(10) unsigned NOT NULL DEFAULT '0',
  `new_map_id1` int(10) unsigned NOT NULL DEFAULT '0',
  `new_x2` int(10) unsigned NOT NULL DEFAULT '0',
  `new_y2` int(10) unsigned NOT NULL DEFAULT '0',
  `new_map_id2` int(10) unsigned NOT NULL DEFAULT '0',
  `new_x3` int(10) unsigned NOT NULL DEFAULT '0',
  `new_y3` int(10) unsigned NOT NULL DEFAULT '0',
  `new_map_id3` int(10) unsigned NOT NULL DEFAULT '0',
  `new_x4` int(10) unsigned NOT NULL DEFAULT '0',
  `new_y4` int(10) unsigned NOT NULL DEFAULT '0',
  `new_map_id4` int(10) unsigned NOT NULL DEFAULT '0',
  `new_x5` int(10) unsigned NOT NULL DEFAULT '0',
  `new_y5` int(10) unsigned NOT NULL DEFAULT '0',
  `new_map_id5` int(10) unsigned NOT NULL DEFAULT '0',
  `new_heading` tinyint(3) unsigned DEFAULT '1',
  `note` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`src_x`,`src_y`,`src_map_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
