#
# Table structure for table 'tx_odsredirects_redirects'
#
CREATE TABLE tx_odsredirects_redirects (
	uid int(10) unsigned NOT NULL auto_increment,
	pid int(10) unsigned DEFAULT '0' NOT NULL,
	tstamp int(10) unsigned DEFAULT '0' NOT NULL,
	crdate int(10) unsigned DEFAULT '0' NOT NULL,
	cruser_id int(10) unsigned DEFAULT '0' NOT NULL,
	hidden tinyint(3) unsigned DEFAULT '0' NOT NULL,
	domain_id int(10) unsigned DEFAULT '0' NOT NULL,
	url varchar(255) DEFAULT '' NOT NULL,
	mode tinyint(3) unsigned DEFAULT '0' NOT NULL,
	destination varchar(255) DEFAULT '' NOT NULL,
	append tinyint(3) unsigned DEFAULT '0' NOT NULL,
	has_moved tinyint(3) unsigned DEFAULT '0' NOT NULL,
	last_referer varchar(255) DEFAULT '' NOT NULL,
	counter int(10) unsigned DEFAULT '0' NOT NULL,
	
	PRIMARY KEY (uid),
	KEY parent (pid),
	KEY mode (mode),
	UNIQUE url (url,mode,domain_id)
);