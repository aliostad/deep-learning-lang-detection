
-- phpMyAdmin SQL Dump
-- version 3.5.2.2
-- http://www.phpmyadmin.net
--
-- Machine: localhost
-- Genereertijd: 18 jun 2015 om 16:27
-- Serverversie: 5.1.67
-- PHP-versie: 5.2.17

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Databank: `u886684279_pf`
--

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `content`
--

CREATE TABLE IF NOT EXISTS `content` (
  `part` varchar(20) CHARACTER SET latin1 NOT NULL,
  `code` longtext COLLATE utf8_spanish_ci,
  PRIMARY KEY (`part`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Gegevens worden uitgevoerd voor tabel `content`
--

INSERT INTO `content` (`part`, `code`) VALUES
('footer', '        <div class="bottom-nav footer"><p> 2015 | <a href="http://sergiorodriguezruiz.com/">Sergio Rodriguez Ruiz</a> &copy; Final project | 2 DAW | IES Francisco Ayala</p></div>\n'),
('forbidden', '<div class="widget-404" style="margin-top: 50px;">\r\n<div class="row">\r\n      <div class="col-md-5">\r\n          <h1 class="text-align-center">404</h1>\r\n      </div>\r\n      <div class="col-md-7">\r\n          <div class="description">\r\n              <h3>Oops! You''re lost.</h3>\r\n              <p>You don''t have permit to see this page, Please <br>\r\n<strong><a href="index.html">Return home</a></strong> and don''t try again</p>\r\n          </div>\r\n      </div>\r\n    </div>\r\n'),
('menu', '<div class="left-nav">\r\n                <div id="side-nav">\r\n                    <ul id="nav">\r\n<li> <a href="users.php"> <i class="icon-edit"></i> Users</a></li>\r\n                    </ul>\r\n                </div>\r\n            </div>'),
('menuE', '<div class="left-nav">\r\n                <div id="side-nav">\r\n                    <ul id="nav">\r\n                        <li class=""> <a href="employee.php"> <i class="icon-dashboard"></i> Dashboard </a> </li>\r\n<li> <a href="employee.php#event"> <i class="icon-edit"></i> Events List</a></li>\r\n<li> <a href="employee.php#petition"> <i class="icon-edit"></i> Petitions list</a></li>\r\n<li> <a href="usersE.php"> <i class="icon-edit"></i> Users</a></li>\r\n                    </ul>\r\n                </div>\r\n            </div>'),
('top', '<div class="container">\r\n            <div class="top-navbar header b-b"> <a data-original-title="Toggle navigation" class="toggle-side-nav pull-left" href="#"><i class="icon-reorder"></i> </a>\r\n                <div class="brand pull-left"> <a href="admin.php"><img src="images/logo.png" height="33" /></a></div>\r\n<ul class="nav navbar-nav navbar-right  hidden-xs">\r\n                <a class="dropdown-toggle" href="functions/logout.php"> <i class="icon-male"></i> <span class="username">LogOut</span></a>\r\n            </ul>\r\n            </div>\r\n        </div>'),
('topE', '<div class="container">\r\n            <div class="top-navbar header b-b"> <a data-original-title="Toggle navigation" class="toggle-side-nav pull-left" href="#"><i class="icon-reorder"></i> </a>\r\n                <div class="brand pull-left"> <a href="employee.php"><img src="images/logo.png" height="33" /></a>\r\n\r\n</div>\r\n<ul class="nav navbar-nav navbar-right  hidden-xs">\r\n                <a class="dropdown-toggle" href="functions/logout.php"> <i class="icon-male"></i> <span class="username">LogOut</span></a>\r\n            </ul>\r\n            </div>\r\n        </div>');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `employee`
--

CREATE TABLE IF NOT EXISTS `employee` (
  `e_id` int(11) NOT NULL AUTO_INCREMENT,
  `u_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`e_id`),
  KEY `u_id` (`u_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=12 ;

--
-- Gegevens worden uitgevoerd voor tabel `employee`
--

INSERT INTO `employee` (`e_id`, `u_id`) VALUES
(9, 16),
(11, 18);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `login`
--

CREATE TABLE IF NOT EXISTS `login` (
  `l_email` varchar(255) NOT NULL,
  `l_psw` varchar(255) NOT NULL,
  PRIMARY KEY (`l_email`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Gegevens worden uitgevoerd voor tabel `login`
--

INSERT INTO `login` (`l_email`, `l_psw`) VALUES
('serrodrui@gmail.com', '4d186321c1a7f0f354b297e8914ab240'),
('prueba@gmail.com', '827ccb0eea8a706c4c34a16891f84e7b'),
('ola@gmail.com', '2fe04e524ba40505a82e03a2819429cc');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `u_id` int(11) NOT NULL AUTO_INCREMENT,
  `u_name` varchar(255) CHARACTER SET latin1 COLLATE latin1_spanish_ci DEFAULT NULL,
  `u_email` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `u_role` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `u_date` date DEFAULT NULL,
  `u_phone` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `u_description` longtext CHARACTER SET latin1,
  PRIMARY KEY (`u_id`),
  KEY `u_email` (`u_email`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci AUTO_INCREMENT=19 ;

--
-- Gegevens worden uitgevoerd voor tabel `users`
--

INSERT INTO `users` (`u_id`, `u_name`, `u_email`, `u_role`, `u_date`, `u_phone`, `u_description`) VALUES
(1, 'Sergio', 'serrodrui@gmail.com', 'admin', '2015-02-19', '672197888', 'Admin of the CRM'),
(16, 'Pepe', 'prueba@gmail.com', 'employee', '2015-02-26', '698585858', NULL),
(18, 'Maria', 'ola@gmail.com', 'employee', '2015-06-14', '', NULL);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
