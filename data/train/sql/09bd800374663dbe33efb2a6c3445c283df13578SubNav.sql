# phpMyAdmin MySQL-Dump
# version 2.2.2
# http://phpwizard.net/phpMyAdmin/
# http://phpmyadmin.sourceforge.net/ (download page)
#
# Host: localhost
# Erstellungszeit: 18. März 2002 um 10:07
# Server Version: 3.23.39
# PHP Version: 4.1.1
# Datenbank : `dmerce_gt_vers`
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `SubNav`
#

CREATE TABLE SubNav (
  ID int(11) NOT NULL default '0',
  CreatedBy int(11) NOT NULL default '0',
  CreatedDateTime float(16,4) NOT NULL default '0.0000',
  ChangedBy int(11) NOT NULL default '0',
  ChangedDateTime float(16,4) NOT NULL default '0.0000',
  active int(1) NOT NULL default '0',
  HeadNavID int(11) NOT NULL default '0',
  NameDE varchar(255) NOT NULL default '',
  Name_en varchar(255) NOT NULL default '',
  Name_fr varchar(255) NOT NULL default '',
  Name_es varchar(255) NOT NULL default '0',
  Name_it varchar(255) NOT NULL default '',
  TextID int(11) NOT NULL default '0',
  PRIMARY KEY  (ID)
) TYPE=MyISAM;

#
# Daten für Tabelle `SubNav`
#

INSERT INTO SubNav VALUES (2, 1, '1016288320.0000', 1, '1016289600.0000', 1, 2, 'Hausrat', '', '', '0', '', 9);
INSERT INTO SubNav VALUES (3, 1, '1016289920.0000', 1, '1016290176.0000', 1, 2, 'Haftpflicht', '', '', '0', '', 10);
INSERT INTO SubNav VALUES (4, 1, '1016291008.0000', 1, '1016291136.0000', 1, 2, 'KFZ', '', '', '0', '', 11);

