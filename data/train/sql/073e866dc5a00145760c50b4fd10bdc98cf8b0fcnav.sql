CREATE TABLE klik_navigation (
  nav_id smallint(6) NOT NULL auto_increment,
  kap tinyint(3) unsigned NOT NULL default '0',
  ukap tinyint(3) unsigned NOT NULL default '0',
  bezeichnung varchar(40) NOT NULL default '',
  kuerzel varchar(20) NOT NULL default '',
  aktiv enum('j','n') NOT NULL default 'j',
  PRIMARY KEY  (nav_id)
) TYPE=MyISAM;

#
# Daten fŸr Tabelle `klik_navigation`
#

INSERT INTO klik_navigation VALUES (1, 1, 0, 'Home', 'home', 'j');
INSERT INTO klik_navigation VALUES (2, 2, 0, 'Angebot', 'angebot', 'j');
INSERT INTO klik_navigation VALUES (3, 3, 0, 'Referenzen', 'referenzen', 'j');
INSERT INTO klik_navigation VALUES (4, 5, 0, 'Download', 'download', 'j');
INSERT INTO klik_navigation VALUES (5, 6, 0, 'Links', 'links', 'j');
INSERT INTO klik_navigation VALUES (6, 7, 0, 'Kontakt', 'kontakt', 'j');
INSERT INTO klik_navigation VALUES (7, 2, 10, 'Produkte', 'produkte', 'j');
INSERT INTO klik_navigation VALUES (8, 2, 20, 'Dienstleistungen', 'dienstleistungen', 'j');
INSERT INTO klik_navigation VALUES (11, 4, 0, 'Partner', 'partner', 'j');
INSERT INTO klik_navigation VALUES (20, 8, 0, 'Impressum', 'impressum', 'j');

#
# Tabellenstruktur fŸr Tabelle `klik_seiten`
#

CREATE TABLE klik_seiten (
  seiten_id smallint(6) NOT NULL auto_increment,
  nav_id smallint(6) NOT NULL default '0',
  nummer tinyint(4) NOT NULL default '0',
  kurztitel varchar(60) NOT NULL default '',
  bild1 smallint(6) NOT NULL default '2',
  alt1 varchar(80) default NULL,
  bild2 smallint(6) default NULL,
  alt2 varchar(80) default NULL,
  zusatztext varchar(255) default NULL,
  template tinyint(3) NOT NULL default '1',
  modul tinyint(3) unsigned NOT NULL default '0',
  inhalt1 text NOT NULL,
  inhalt2 text NOT NULL,
  aktiv enum('j','n') NOT NULL default 'j',
  PRIMARY KEY  (seiten_id)
) TYPE=MyISAM;

#
# Daten fŸr Tabelle `klik_seiten`
#

INSERT INTO klik_seiten VALUES (1, 1, 1, 'Home-Seite', 1, '', NULL, NULL, '', 1, 0, '<p>Bitte <a href="/angebot" target="_self">Text</a> eingeben</p> <p>Blah blah</p>', '', 'j');
