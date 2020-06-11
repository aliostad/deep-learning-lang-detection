CREATE TABLE  `box_settings` (
  `holder_id` varchar(100) NOT NULL COMMENT 'this option is ignored when box is pinned to dashboard',
  `location_id` int(11) NOT NULL COMMENT 'this option is to set settings for proper location and only for them',
  `box_id` varchar(100) DEFAULT NULL,
  `is_pinned` tinyint(1) NOT NULL COMMENT 'determine if box is pinned to dashboard\n',
  `box_class` varchar(100) NOT NULL COMMENT 'when box is pinned we need to append it to existing boxes so box_class is to determine which box holder we need to create',
  `section_id` varchar(50) NOT NULL COMMENT 'when holder is generated dynamically we need to have position in dom model of holder so we have index',
  PRIMARY KEY (`holder_id`,`location_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1