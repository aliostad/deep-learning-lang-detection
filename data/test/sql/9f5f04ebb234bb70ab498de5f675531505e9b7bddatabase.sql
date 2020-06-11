CREATE TABLE `tl_content` (
  `useMooquee4ward` char(1) NOT NULL default '',
  `mooquee4wardDuration` int(7) NOT NULL default '0',
  `mooquee4wardPause` int(7) NOT NULL default '0',
  `mooquee4wardFirstitem` varchar(15) NOT NULL default '0',
  `mooquee4wardSize` varchar(255) NOT NULL default '',
  `mooquee4wardTransin` varchar(15) NOT NULL default '',
  `mooquee4wardTransout` varchar(15) NOT NULL default '',
  `mooquee4wardTransition1` varchar(15) NOT NULL default '',
  `mooquee4wardTransition2` varchar(15) NOT NULL default '',
  `mooquee4wardPauseOnHover` char(1) NOT NULL default '',
  `mooquee4wardShowNav` char(1) NOT NULL default '',
  `mooquee4wardRelatedCE` int(9) NOT NULL default '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `tl_module` (
  `mooquee4wardDuration` int(7) NOT NULL default '0',
  `mooquee4wardPause` int(7) NOT NULL default '0',  
  `mooquee4wardFirstitem` varchar(15) NOT NULL default '0',  
  `mooquee4wardSize` varchar(255) NOT NULL default '',
  `mooquee4wardTransin` varchar(15) NOT NULL default '',
  `mooquee4wardTransout` varchar(15) NOT NULL default '',
  `mooquee4wardTransition1` varchar(15) NOT NULL default '',
  `mooquee4wardTransition2` varchar(15) NOT NULL default '',  
  `mooquee4wardPauseOnHover` char(1) NOT NULL default '',
  `mooquee4wardShowNav` char(1) NOT NULL default ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
