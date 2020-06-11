-- ********************************************************
-- *                                                      *
-- * IMPORTANT NOTE                                       *
-- *                                                      *
-- * Do not import this file manually but use the Contao  *
-- * install tool to create and maintain database tables! *
-- *                                                      *
-- ********************************************************


-- --------------------------------------------------------

-- 
-- Table `tl_flash`
-- 

CREATE TABLE `tl_flash` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `tstamp` int(10) unsigned NOT NULL default '0',
  `title` varchar(255) NOT NULL default '',
  `flashID` varchar(64) NOT NULL default '',
  `content` text NULL,
  PRIMARY KEY  (`id`),
  KEY `flashID` (`flashID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
