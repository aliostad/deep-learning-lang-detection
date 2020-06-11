CREATE TABLE IF NOT EXISTS `back_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `verbeterpunt` text NOT NULL,
  `actie` text NOT NULL,
  `prioriteit` varchar(128) NOT NULL,
  `ureninschatting` varchar(128) NOT NULL,
  `status` varchar(128) NOT NULL,
  `testresultaten` text NOT NULL,
  `afgerond` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

INSERT INTO `rollen` (`id`, `naam`, `type`, `klant_id`, `gemaakt_op`, `gemaakt_door_gebruiker_id`, `is_beheer_default`, `is_toezichthouder_default`) VALUES
(NULL, 'BRIS beheerder', 'systeem', NULL, '2013-05-15 11:00:45', 1, 0, 0);

SET @rol_id = LAST_INSERT_ID();

INSERT INTO `rol_rechten` (`id`, `rol_id`, `recht`, `modus`) VALUES
(NULL, @rol_id, 2, 2),
(NULL, @rol_id, 3, 2),
(NULL, @rol_id, 4, 2),
(NULL, @rol_id, 18, 2),
(NULL, @rol_id, 5, 2),
(NULL, @rol_id, 6, 4),
(NULL, @rol_id, 7, 2),
(NULL, @rol_id, 8, 4),
(NULL, @rol_id, 9, 2),
(NULL, @rol_id, 10, 4),
(NULL, @rol_id, 12, 2),
(NULL, @rol_id, 13, 4),
(NULL, @rol_id, 14, 2),
(NULL, @rol_id, 23, 2),
(NULL, @rol_id, 1, 2),
(NULL, @rol_id, 11, 2),
(NULL, @rol_id, 15, 2),
(NULL, @rol_id, 21, 2),
(NULL, @rol_id, 22, 2),
(NULL, @rol_id, 19, 1),
(NULL, @rol_id, 16, 1),
(NULL, @rol_id, 24, 2),
(NULL, @rol_id, 20, 2),
(NULL, @rol_id, 17, 2);

REPLACE INTO `teksten` (`string`, `tekst`, `timestamp`) VALUES
('nav.backlog_edit', 'Bewerken', '2013-05-15 11:37:47'),
('backlog.ureninschatting', 'Ureninschatting', '2013-05-15 11:20:41'),
('backlog.afgerond', 'Afgerond', '2013-05-15 11:20:21'),
('backlog.status', 'Status', '2013-05-15 11:20:15'),
('backlog.prioriteit', 'Prioriteit', '2013-05-15 11:20:09'),
('backlog.actie', 'Actie', '2013-05-15 11:20:05'),
('backlog.verbeterpunt', 'Verbeterpunt', '2013-05-15 11:20:02'),
('admin.backlog::toon_alle_backlog', 'Alle', '2013-05-15 11:19:54'),
('admin.backlog::toon_actieve_backlog', 'Actief', '2013-05-15 11:19:50'),
('admin.backlog::backlog', 'Backlog', '2013-05-15 11:19:44'),
('nav.backlog', 'Backlog', '2013-05-15 10:55:20'),
('dossiers.bekijken::aandachtspunten', 'Aandachtspunten', '2013-05-14 16:31:29'),
('nav.bag_koppeling_beheer', 'BAG koppeling beheer', '2013-05-13 09:03:01');
