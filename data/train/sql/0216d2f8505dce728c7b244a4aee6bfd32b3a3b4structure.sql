SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `eventslab`
--

CREATE TABLE IF NOT EXISTS `contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `friend_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;


CREATE TABLE IF NOT EXISTS `event` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `venue` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `address` text COLLATE utf8_unicode_ci NOT NULL,
  `event_hour` int(11) NOT NULL,
  `event_min` int(11) NOT NULL,
  `period` varchar(3) COLLATE utf8_unicode_ci NOT NULL,
  `description` text COLLATE utf8_unicode_ci NOT NULL,
  `ticketCount` int(11) NOT NULL,
  `ticketCategory` int(11) NOT NULL,
  `publish` int(11) NOT NULL,
  `ticketExpiryDate` date NOT NULL,
  `date` date NOT NULL,
  `organizerId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=37 ;


CREATE TABLE IF NOT EXISTS `feedback` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `participant_id` int(11) NOT NULL,
  `feedback` text COLLATE utf8_unicode_ci NOT NULL,
  `date` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;


CREATE TABLE IF NOT EXISTS `invites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contact_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;


CREATE TABLE IF NOT EXISTS `participants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=236 ;


CREATE TABLE IF NOT EXISTS `rating` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `participant_id` int(11) NOT NULL,
  `rating` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;


CREATE TABLE IF NOT EXISTS `tickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `participant_id` int(11) NOT NULL,
  `number` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;


CREATE TABLE IF NOT EXISTS `user_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `pass` text COLLATE utf8_unicode_ci NOT NULL,
  `address` text COLLATE utf8_unicode_ci,
  `portrait` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=9 ;

--
-- Dumping 
--

INSERT INTO `event` (`id`, `title`, `venue`, `address`, `event_hour`, `event_min`, `period`, `description`, `ticketCount`, `ticketCategory`, `publish`, `ticketExpiryDate`, `date`, `organizerId`) VALUES
(25, 'This is a new event', 'This is a new event', 'This is a new eventThis is a new eventThis is a new eventThis is a new eventThis is a new event\r\n\r\nThis is a new eventThis is a new event\r\n\r\nThis is a new event', 1, 1, 'AM', '<font face="Arial, Verdana" size="2">This is a new eventThis is a new eventThis is a new eventThis is a new eventThis is a new eventThis is a new eventThis is a new eventThis is a new eventThis is a new eventThis is a new eventThis is a new eventThis is a new eventThis is a new eventThis is a new eventThis is a new eventThis is a new eventThis is a new event</font><div><font face="Arial, Verdana" size="2"><br/></font></div><div><font face="Arial, Verdana" size="2"><br/></font></div><div><font face="Arial, Verdana" size="2">This is a new eventThis is a new eventThis is a new eventThis is a new eventThis is a new eventThis is a new eventThis is a new eventThis is a new eventThis is a new eventThis is a new eventThis is a new eventThis is a new event</font></div>', 100, 2, 1, '2013-02-28', '2013-02-26', 7),
(24, 'Hello Event', 'Hello Event', 'Hello EventHello EventHello Event\r\nHello EventHello Event\r\nHello Event', 1, 1, 'AM', '<font face="Arial, Verdana" size="2"><strong>Hello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello EventHello Event</strong></font>', 51, 1, 1, '2013-04-24', '2013-02-25', 7),
(23, 'This is a new event', 'whats up', 'yap', 1, 1, 'AM', 'asdfasdf', 0, 1, 0, '2013-02-27', '2013-02-25', 7),
(21, 'asdfasdf', 'asdfasdf', 'asdfasdf', 1, 1, 'AM', 'asdfasdf', 0, 1, 0, '2013-02-27', '2013-02-25', 6),
(29, 'New EVent-RFonseca', 'New EVent-RFonseca', 'New EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonseca', 1, 1, 'AM', '<font face="Arial, Verdana" size="2">New EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonsecaNew EVent-RFonseca</font>', 101, 1, 0, '2013-03-31', '2013-03-20', 8);


INSERT INTO `participants` (`id`, `user_id`, `event_id`) VALUES
(235, 7, 22),
(234, 7, 22);


INSERT INTO `user_info` (`id`, `name`, `email`, `pass`, `address`, `portrait`, `description`) VALUES
(7, '', 'a@a.com', '123', '', '', ''),
(6, '', 'notun@user.com', '123456', '', '', ''),
(8, NULL, 'rafael.oliveira.fonseca@gmail.com', '123456789', NULL, NULL, NULL);
