CREATE TABLE IF NOT EXISTS `ticketing_for_show` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `show_id` int(10) unsigned NOT NULL,
  `ticketing_scheme_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ticketing_scheme_id` (`ticketing_scheme_id`),
  KEY `show_id` (`show_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE `ticketing_for_show`
  ADD CONSTRAINT `show_for_ticketing_fkey` FOREIGN KEY (`ticketing_scheme_id`) REFERENCES `ticket_scheme` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ticketing_for_show` FOREIGN KEY (`show_id`) REFERENCES `show` (`id`) ON DELETE CASCADE;
