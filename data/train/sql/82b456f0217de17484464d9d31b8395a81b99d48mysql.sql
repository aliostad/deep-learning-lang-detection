

CREATE TABLE `prefix_flash` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `course` int(10) unsigned NOT NULL default '0',
  `name` varchar(255) NOT NULL default '',
  `moviename` varchar(255) NOT NULL default '',
  `grade` int(11) NOT NULL default '0',
  `gradingmethod` varchar(255) default NULL,
  `showgrades` tinyint(1) NOT NULL default '1',
  `showheader` tinyint(1) NOT NULL default '1',
  `size` tinyint(1) NOT NULL default '1',
  `to_config` tinyint(3) default NULL,
  `config` text,
  `q_no` int(11) NOT NULL default '0',
  `answers` text,
  `guestfeedback` text,
  `feedback` text,
  `usepreloader` tinyint(1) default NULL,
  `fonts` text,
  `usesplash` tinyint(1) default NULL,
  `splash` text,
  `splashformat` tinyint(2) default '0',
  `timemodified` int(10) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) TYPE=MyISAM COMMENT='Main flash activity (flash) table';


CREATE TABLE `prefix_flash_accesses` (
  `id` int(10) NOT NULL auto_increment,
  `flashid` int(10) NOT NULL default '0',
  `userid` int(10) NOT NULL default '0',
  `timemodified` int(10) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) TYPE=MyISAM COMMENT='completed tests';


CREATE TABLE `prefix_flash_answers` (
  `id` int(11) NOT NULL auto_increment,
  `answer` text,
  `q_no` int(11) default NULL,
  `accessid` int(11) NOT NULL default '0',
  `grade` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;
        
CREATE TABLE `prefix_flash_movies` (
`id` INT( 11 ) NOT NULL AUTO_INCREMENT ,
 `version` INT( 11 ) NOT NULL ,
 `bgcolor` VARCHAR( 7 ) NOT NULL ,
 `width` INT( 11 ) NOT NULL ,
 `height` INT( 11 ) NOT NULL ,
 `framerate` INT( 11 ) NOT NULL ,
 `moviename` VARCHAR( 255 ) NOT NULL ,
 `timemodified` INT( 11 ) NOT NULL,
 PRIMARY KEY ( `id` ) )TYPE=MyISAM;