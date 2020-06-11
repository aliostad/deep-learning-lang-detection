/**
 * New module DB installation
 */

-- Default categories permssions
INSERT INTO `cot_auth` (`auth_groupid`, `auth_code`, `auth_option`,
  `auth_rights`, `auth_rights_lock`, `auth_setbyuserid`) VALUES
(1, 'new', 'novosti',	5,		250,	1),
(2, 'new', 'novosti',	1,		254,	1),
(3, 'new', 'novosti',	0,		255,	1),
(4, 'new', 'novosti',	7,		0,		1),
(5, 'new', 'novosti',	255,	255,	1),
(6, 'new', 'novosti',	135,	0,		1),
(1, 'new', 'events',	5,		250,	1),
(2, 'new', 'events',	1,		254,	1),
(3, 'new', 'events',	0,		255,	1),
(4, 'new', 'events',	7,		0,		1),
(5, 'new', 'events',	255,	255,	1),
(6, 'new', 'events',	135,	0,		1),
(1, 'new', 'links',	5,		250,	1),
(2, 'new', 'links',	1,		254,	1),
(3, 'new', 'links',	0,		255,	1),
(4, 'new', 'links',	7,		0,		1),
(5, 'new', 'links',	255,	255,	1),
(6, 'new', 'links',	135,	0,		1),
(1, 'new', 'pro',		5,		250,	1),
(2, 'new', 'pro',		1,		254,	1),
(3, 'new', 'pro',		0,		255,	1),
(4, 'new', 'pro',		7,		0,		1),
(5, 'new', 'pro',		255,	255,	1),
(6, 'new', 'pro',		135,	0,		1);

-- News table
CREATE TABLE IF NOT EXISTS `cot_news` (
  `new_id` int(11) unsigned NOT NULL auto_increment,
  `new_alias` varchar(255) collate utf8_unicode_ci NOT NULL default '',
  `new_state` tinyint(1) unsigned NOT NULL default '0',
  `new_cat` varchar(255) collate utf8_unicode_ci NOT NULL,
  `new_title` varchar(255) collate utf8_unicode_ci NOT NULL,
  `new_desc` varchar(255) collate utf8_unicode_ci default NULL,
  `new_keywords` varchar(255) collate utf8_unicode_ci default NULL,
  `new_metatitle` varchar(255) collate utf8_unicode_ci default NULL,
  `new_metadesc` varchar(255) collate utf8_unicode_ci default NULL,
  `new_text` MEDIUMTEXT collate utf8_unicode_ci NOT NULL,
  `new_parser` VARCHAR(64) NOT NULL DEFAULT '',
  `new_author` varchar(100) collate utf8_unicode_ci NOT NULL,
  `new_ownerid` int(11) NOT NULL default '0',
  `new_date` int(11) NOT NULL default '0',
  `new_begin` int(11) NOT NULL default '0',
  `new_expire` int(11) NOT NULL default '0',
  `new_updated` int(11) NOT NULL default '0',
  `new_file` tinyint(4) default NULL,
  `new_url` varchar(255) collate utf8_unicode_ci default NULL,
  `new_size` int(11) unsigned default NULL,
  `new_count` mediumint(8) unsigned default '0',
  `new_rating` decimal(5,2) NOT NULL default '0.00',
  `new_filecount` mediumint(8) unsigned default '0',
  PRIMARY KEY  (`new_id`),
  KEY `new_cat` (`new_cat`),
  KEY `new_alias` (`new_alias`),
  KEY `new_state` (`new_state`),
  KEY `new_date` (`new_date`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `cot_news` (`new_state`, `new_cat`, `new_title`, `new_desc`, `new_text`, `new_author`, `new_ownerid`, `new_date`, `new_begin`, `new_expire`, `new_file`, `new_url`, `new_size`, `new_count`, `new_rating`, `new_filecount`, `new_alias`) VALUES
(0, 'news', 'Welcome!', '', 'Congratulations, Cotonti was successfully installed! You can now login with the user account you created during installation. Next step is to go to the Administration panel and change the settings for your website, such as the title, server settings, language, user groups and extensions. You can safely remove this message by clicking its title, then clicking Edit and Delete this new.', '', 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 0, '', 0, 27, '0.00', 0, '');

-- Default new categories
INSERT INTO `cot_structure` (`structure_area`, `structure_code`, `structure_path`, `structure_tpl`, `structure_title`,
   `structure_desc`, `structure_icon`, `structure_locked`, `structure_count`) VALUES
('new', 'novosti', '1', '', 'Articles', '', '', 0, 0),
('new', 'links', '2', '', 'Links', '', '', 0, 0),
('new', 'events', '3', '', 'Events', '', '', 0, 0),
('new', 'pro', '4', '', 'News', '', '', 0, 1);
