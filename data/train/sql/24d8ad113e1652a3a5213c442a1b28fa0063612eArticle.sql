# phpMyAdmin MySQL-Dump
# version 2.2.2
# http://phpwizard.net/phpMyAdmin/
# http://phpmyadmin.sourceforge.net/ (download page)
#
# Host: localhost
# Erstellungszeit: 06. März 2002 um 10:03
# Server Version: 3.23.39
# PHP Version: 4.1.1
# Datenbank : `dmerce_shop2`
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `Article`
#

CREATE TABLE Article (
  ID int(11) NOT NULL default '0',
  CreatedDateTime double(16,6) NOT NULL default '0.000000',
  ChangedDateTime double(16,6) NOT NULL default '0.000000',
  CreatedBy int(11) NOT NULL default '0',
  ChangedBy int(11) NOT NULL default '0',
  active int(11) NOT NULL default '1',
  HeadNavID int(11) NOT NULL default '0',
  SubNavID int(11) NOT NULL default '0',
  ArtNo varchar(200) NOT NULL default '',
  Name text NOT NULL,
  ShortDescription text NOT NULL,
  DetailDescription text NOT NULL,
  PriceNet float(10,2) NOT NULL default '0.00',
  TaxRate float(10,2) NOT NULL default '0.00',
  PriceGross float(10,2) NOT NULL default '0.00',
  ClassOfGoodsID int(11) NOT NULL default '0',
  Highlight int(1) NOT NULL default '0',
  New int(1) NOT NULL default '0',
  SpecialOffer int(1) NOT NULL default '0',
  SpecialOfferFrom double(16,6) NOT NULL default '0.000000',
  SpecialOfferTill double(16,6) NOT NULL default '0.000000',
  SpecialOfferPercent float(10,2) NOT NULL default '0.00',
  Picture varchar(255) NOT NULL default '',
  Width float(10,2) NOT NULL default '0.00',
  Height float(10,2) NOT NULL default '0.00',
  Depth float(10,2) NOT NULL default '0.00',
  Weight varchar(6) NOT NULL default '0.000',
  Producer varchar(255) NOT NULL default '',
  GruppenID int(11) NOT NULL default '0',
  PRIMARY KEY  (ID)
) TYPE=ISAM PACK_KEYS=1;

