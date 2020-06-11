CREATE TABLE IF NOT EXISTS `#__message_queue` (
  `mgqid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mgid` int(10) unsigned NOT NULL DEFAULT '0',
  `uid` int(10) unsigned NOT NULL DEFAULT '0',
  `created` int(10) unsigned NOT NULL DEFAULT '0',
  `priority` tinyint(3) unsigned NOT NULL DEFAULT '254',
  `expirationdate` int(10) unsigned NOT NULL DEFAULT '0',
  `repetition` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `params` text NOT NULL,
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `content` text NOT NULL,
  `read` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `title` varchar(255) NOT NULL,
  `subtitle` varchar(255) NOT NULL,
  PRIMARY KEY (`mgqid`),
  KEY `IX_message_queue_uid_read_create` (`uid`,`read`,`created`)
) ENGINE=InnoDB   /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci*/;