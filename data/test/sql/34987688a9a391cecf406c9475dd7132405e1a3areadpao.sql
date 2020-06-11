CREATE TABLE `list_items` (
 `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'primary key',
 `list_name` varchar(50) COLLATE utf8_bin NOT NULL COMMENT 'name of the list',
 `url` text COLLATE utf8_bin NOT NULL COMMENT 'url of the page',
 `title` text COLLATE utf8_bin NOT NULL COMMENT 'title of the page',
 `date_added` datetime NOT NULL COMMENT 'when page was bookmarked',
 `date_read` datetime NOT NULL COMMENT 'when page was read',
 `time_to_read` int(11) NOT NULL COMMENT 'time in minutes to read the page',
 `content` mediumtext COLLATE utf8_bin NOT NULL COMMENT 'content of the page',
 PRIMARY KEY (`id`),
 KEY `list_name` (`list_name`),
 KEY `time_to_read` (`time_to_read`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
