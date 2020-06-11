
CREATE TABLE `tl_datajuggler` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `tstamp` int(10) unsigned NOT NULL default '0',
  `title` varchar(255) NOT NULL default '',  
  `alias` varchar(255) NOT NULL default '',
  `result_fields` text NULL,
  `query_string` text NULL,
  `source_tables` text NULL,
  `source_test` text NULL,
  `append_data` varchar(1) NOT NULL default '',
  
  `dca_trigger_callback` varchar(1) NOT NULL default '',
  `dca_trigger_callback_list` text NULL,
  
  `dca_trigger_cron` varchar(1) NOT NULL default '',
  `dca_trigger_cron_list` text NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
