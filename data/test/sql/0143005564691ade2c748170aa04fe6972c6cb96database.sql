CREATE TABLE `tl_jedo-fs-slider` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `pid` int(10) unsigned NOT NULL default '0',
  `sorting` int(10) unsigned NOT NULL default '0',
  `tstamp` int(10) unsigned NOT NULL default '0',
  `published` char(1) NOT NULL default '',
  `title` varchar(255) NOT NULL default '',
  `alias` varchar(128) NOT NULL default '',
  `size` varchar(64) NOT NULL default '',
  `ribbon` varchar(64) NOT NULL default '',
  `caption` varchar(64) NOT NULL default '',
  `theme` varchar(64) NOT NULL default '',
  `animation` varchar(64) NOT NULL default '',
  `slideDirection` varchar(64) NOT NULL default '',
  `slideshow` varchar(64) NOT NULL default '',
  `slideshowSpeed` varchar(64) NOT NULL default '7000',
  `animationDuration` varchar(64) NOT NULL default '600',
  `directionNav` varchar(64) NOT NULL default '',
  `controlNav` varchar(64) NOT NULL default '',
  `keyboardNav` varchar(64) NOT NULL default '',
  `mousewheel` varchar(64) NOT NULL default '',
  `animationLoop` varchar(64) NOT NULL default '',
  `pauseOnAction` varchar(64) NOT NULL default '',
  `pauseOnHover` varchar(64) NOT NULL default '',
  `pausePlay` varchar(64) NOT NULL default '',
  `randomize` varchar(64) NOT NULL default '',
  `slideToStart` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `pid` (`pid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


CREATE TABLE `tl_jedo-fs-images` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `pid` int(10) unsigned NOT NULL default '0',
  `sorting` int(10) unsigned NOT NULL default '0',
  `tstamp` int(10) unsigned NOT NULL default '0',
  `published` char(1) NOT NULL default '',
  `name` varchar(255) NOT NULL default '',
  `description` text NULL,
  `singleSRC` varchar(255) NOT NULL default '',
  `alt` varchar(255) NOT NULL default '',
  `imageUrl` varchar(255) NOT NULL default '',
  `size` varchar(64) NOT NULL default '',
  PRIMARY KEY  (`id`),
  KEY `pid` (`pid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


CREATE TABLE `tl_module` (
  `select_jedoflexslider` int(10) unsigned NOT NULL default '0',
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


CREATE TABLE `tl_content` (
  `select_jedoflexslider` int(10) unsigned NOT NULL default '0',
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
