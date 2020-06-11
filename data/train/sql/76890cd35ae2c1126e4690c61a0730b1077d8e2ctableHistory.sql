-- PLEASE NOTE: THIS FILE IS STRICTLY APPEND-ONLY.  ADD ALL CHANGES TO THE
-- END OF THE FILE.  FOR EXCEPTIONS, CONTACT fabian.pichler@synventis.com
-- TablesHistory helds all commands needed to migrate a database from one SchemaVersion to the next.

-- inital table
CREATE TABLE IF NOT EXISTS SchemaVersion (
 `schema` varchar(30) NOT NULL,
 `version`  INT NOT NULL
);
INSERT INTO SchemaVersion
 (`schema`, `version`)
 VALUES
 ('celements.calendar','1');

CREATE TABLE IF NOT EXISTS cel_calendareventclass (
  `CEC_ID` int(10) NOT NULL,
  `CEC_LANG` varchar(3) default NULL,
  `CEC_TITEL` varchar(255) default NULL,
  `CEC_DESCRIPTION` text default NULL,
  `CEC_LOCATION_RTE` text default NULL,
  `CEC_LOCATION` varchar(255) default NULL,
  `CEC_DATE` datetime default NULL,
  `CEC_IS_SUBSCRIBABLE` smallint(1) default 0,
  PRIMARY KEY  (CEC_ID)
) TYPE=MyISAM;

UPDATE SchemaVersion SET `version` = '2' WHERE `schema` = 'celements.calendar';

ALTER TABLE cel_calendareventclass
  modify `CEC_DESCRIPTION` text default NULL,
  modify `CEC_LOCATION_RTE` text default NULL;

UPDATE SchemaVersion SET `version` = '3' WHERE `schema` = 'celements.calendar';
