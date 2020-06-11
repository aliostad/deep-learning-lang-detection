CREATE TABLE IF NOT EXISTS `show_order` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `show_id` int(10) unsigned NOT NULL,
  `staging_id` int(10) unsigned NOT NULL,
  `order` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `show_id` (`show_id`),
  KEY `staging_id` (`staging_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

ALTER TABLE `show_order`
  ADD CONSTRAINT `show_order_ibfk_1` FOREIGN KEY (`show_id`) REFERENCES `show` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `show_order_ibfk_2` FOREIGN KEY (`staging_id`) REFERENCES `staging` (`id`) ON DELETE CASCADE;
