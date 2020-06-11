CREATE TABLE `module_flash_news` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `news` varchar(255) collate utf8_unicode_ci NOT NULL,
  `cat_id` int(10) unsigned NOT NULL,
  `sticky` enum('yes','no') collate utf8_unicode_ci NOT NULL default 'no',
  `active` enum('yes','no') collate utf8_unicode_ci NOT NULL default 'yes',
  `date_added` datetime default NULL,
  `last_modified` timestamp NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
   PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `module_flash_news_categories` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(30) collate utf8_unicode_ci NOT NULL,
  `active` enum('yes','no') collate utf8_unicode_ci NOT NULL default 'yes',
   PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `fuel_permissions` (`id`,`name`,`description`,`active`) VALUES
	('','flash_news/news','Manage flash news','yes'),
	('','flash_news/view_news','Read flash news','yes');