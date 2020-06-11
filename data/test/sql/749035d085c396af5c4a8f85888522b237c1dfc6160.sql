ALTER TABLE Model ADD ModelData2 
#ifdef MSSQL
	ntext 
#endif MSSQL
#ifdef HSQLDB
	varchar(8192) 
#endif HSQLDB
NULL;

UPDATE Model SET ModelData2 = ModelData;

ALTER TABLE Model DROP COLUMN ModelData;
ALTER TABLE Model ADD ModelData 
#ifdef MSSQL
	ntext 
#endif MSSQL
#ifdef HSQLDB
	varchar(8192) 
#endif HSQLDB
NULL;
UPDATE Model SET ModelData = ModelData2;

ALTER TABLE Model DROP COLUMN ModelData2;


--
-- this should be the last statement in any update script
--
INSERT INTO DBVersion (CurrentVersion, PreviousVersion)
 VALUES ('FPS.01.60', 'FPS.01.59');
