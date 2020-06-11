# phpMyAdmin MySQL-Dump
# version 2.2.2
# http://phpwizard.net/phpMyAdmin/
# http://phpmyadmin.sourceforge.net/ (download page)
#
# Host: localhost
# Erstellungszeit: 10. März 2002 um 18:32
# Server Version: 3.23.39
# PHP Version: 4.1.1
# Datenbank : `dmerce_gt_immo2`
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `HeadNav`
#

CREATE TABLE HeadNav (
  ID int(11) NOT NULL default '0',
  CreatedBy int(11) NOT NULL default '0',
  CreatedDateTime float(16,4) NOT NULL default '0.0000',
  ChangedBy int(11) NOT NULL default '0',
  ChangedDateTime float(16,4) NOT NULL default '0.0000',
  active int(1) NOT NULL default '1',
  WordlistID int(11) NOT NULL default '0',
  TextID int(11) NOT NULL default '0',
  NameDE varchar(255) NOT NULL default '',
  Name_en varchar(255) NOT NULL default '',
  Name_es varchar(255) NOT NULL default '',
  Name_fr varchar(255) NOT NULL default '',
  Name_it varchar(255) NOT NULL default '',
  GruppenID int(11) NOT NULL default '0',
  PRIMARY KEY  (ID)
) TYPE=MyISAM;

#
# Daten für Tabelle `HeadNav`
#

INSERT INTO HeadNav VALUES (2, 1, '1015502144.0000', 1, '1015691712.0000', 1, 0, 22, 'Vermietung', '', '', '', '', 0);

