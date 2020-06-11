# phpMyAdmin MySQL-Dump
# version 2.2.2
# http://phpwizard.net/phpMyAdmin/
# http://phpmyadmin.sourceforge.net/ (download page)
#
# Host: localhost
# Erstellungszeit: 05. März 2002 um 11:35
# Server Version: 3.23.39
# PHP Version: 4.1.1
# Datenbank : `dmerce_vers2`
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `Object`
#

CREATE TABLE Object (
  ID int(11) NOT NULL auto_increment,
  ChangedDateTime double(16,6) NOT NULL default '0.000000',
  CreatedDateTime double(16,6) NOT NULL default '0.000000',
  CreatedBy int(11) NOT NULL default '1',
  ChangedBy int(11) NOT NULL default '1',
  HeadNavID int(11) NOT NULL default '0',
  SubNavID int(11) NOT NULL default '0',
  TextarticleGroup int(11) NOT NULL default '0',
  Head varchar(255) NOT NULL default '',
  Subhead varchar(255) NOT NULL default '',
  Excerpt text,
  Text longtext,
  active int(1) NOT NULL default '1',
  Date float(16,4) NOT NULL default '0.0000',
  Picture varchar(255) NOT NULL default '',
  Highlight int(11) NOT NULL default '0',
  Highlighttext varchar(255) NOT NULL default '',
  GruppenID int(11) NOT NULL default '0',
  PRIMARY KEY  (ID),
  KEY active (active)
) TYPE=MyISAM;

