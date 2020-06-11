DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL,
  `password` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=innodb DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;
DROP TABLE IF EXISTS `modules`;
CREATE TABLE IF NOT EXISTS `modules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mod_name` varchar(20) NOT NULL,
  `mod_nav_order` tinyint(2) NOT NULL DEFAULT '0',
  `enabled` tinyint(1) NOT NULL DEFAULT '0',
  `hide_in_nav` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=innodb  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;
INSERT INTO `modules` (`id`, `mod_name`, `mod_nav_order`, `enabled`, `hide_in_nav`) VALUES
            (1, 'core', 100, 1, 0),
            (2, 'clients', 1, 1, 0);
