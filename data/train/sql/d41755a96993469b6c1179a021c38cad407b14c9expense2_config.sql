--
-- Table structure for table `expense2_config`
--

DROP TABLE IF EXISTS `expense2_config`;
CREATE TABLE `expense2_config` (
  `user_id` bigint(20) NOT NULL default '0',
  `title` char(100) NOT NULL default 'Kulutusseuranta',
  `lang` char(2) NOT NULL default 'fi',
  `product_table` char(100) NOT NULL default '',
  `force_query` varchar(255) NOT NULL,
  `read_only` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`user_id`),
  KEY `read_only` (`read_only`)
) ENGINE=MyISAM;

--
-- Data for table `expense2_config`
--

INSERT INTO `expense2_config` VALUES (9,'Expense demo','en','expense2_demo','',0);
