# phpMyAdmin MySQL-Dump
# version 2.2.2
# http://phpwizard.net/phpMyAdmin/
# http://phpmyadmin.sourceforge.net/ (download page)
#
# Host: localhost
# Erstellungszeit: 10. März 2002 um 18:33
# Server Version: 3.23.39
# PHP Version: 4.1.1
# Datenbank : `dmerce_gt_immo2`
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
  GruppenID int(11) NOT NULL default '0',
  PRIMARY KEY  (ID)
) TYPE=MyISAM;

#
# Daten für Tabelle `SubNav`
#

INSERT INTO SubNav VALUES (2, 1, '1015502144.0000', 1, '1015502976.0000', 1, 2, '3 Zimmer', '', '', '0', '', 8, 0);
INSERT INTO SubNav VALUES (3, 1, '1015503744.0000', 1, '1015506624.0000', 1, 2, '2 Zimmer', '', '', '0', '', 10, 0);

