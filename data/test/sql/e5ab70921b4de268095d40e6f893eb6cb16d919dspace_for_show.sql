CREATE TABLE IF NOT EXISTS `space_for_show` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `space_id` int(10) unsigned NOT NULL,
  `show_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `space_id` (`space_id`),
  KEY `show_id` (`show_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE `space_for_show`
  ADD CONSTRAINT `space_for_show_ibfk_1` FOREIGN KEY (`space_id`) REFERENCES `performance_space` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `space_for_show_ibfk_2` FOREIGN KEY (`show_id`) REFERENCES `show` (`id`) ON DELETE CASCADE;
