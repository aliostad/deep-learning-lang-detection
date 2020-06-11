/*
Core Monitoring - Create Procedure to read data from SchemaChangeLog

Update the read procedure to deal with timing issues.
*/
USE DBAAdmin
GO
ALTER PROCEDURE getSchemaChangeLog
-- jsj Changed result set to count.
AS
DECLARE @d DATETIME = GETDATE();

 -- read all items that have not been viewed with this process.
  SELECT 
   COUNT(*)
   FROM dbo.SchemaChangeLog
   WHERE isRead = 0
   AND EventTime <= @d
   ;
   -- update all the current items to read.
   UPDATE dbo.SchemaChangeLog
    SET isRead = 1
	WHERE isRead = 0
   AND EventTime <= @d
	;
RETURN
go


