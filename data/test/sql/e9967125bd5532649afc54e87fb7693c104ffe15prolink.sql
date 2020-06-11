CREATE TABLE IF NOT EXISTS `prolink_content` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(32) COLLATE utf8_bin NOT NULL,
  `model_id` int(11) NOT NULL,
  `field` varchar(32) COLLATE utf8_bin NOT NULL,
  `timestamp` int(11) NOT NULL,
  `prolinked` text COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`),
  KEY `model` (`model`),
  KEY `model_id` (`model_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;



CREATE TABLE IF NOT EXISTS `prolink_keys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(128) COLLATE utf8_bin NOT NULL,
  `model` varchar(32) COLLATE utf8_bin NOT NULL,
  `model_id` int(11) NOT NULL,
  `url` varchar(256) COLLATE utf8_bin NOT NULL,
  `timestamp` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `key` (`key`),
  KEY `model` (`model`),
  KEY `model_id` (`model_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
