IF OBJECT_ID('dbo.wsp_FixProfileShow_ad') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_FixProfileShow_ad
    IF OBJECT_ID('dbo.wsp_FixProfileShow_ad') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_FixProfileShow_ad >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_FixProfileShow_ad >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Jason C.
**   Date:    May 12 2005
**   Description: 
**   1. UPDATE a_profile_dating SET show = "N" WHERE show_prefs = LOWER(show_prefs) AND show = "Y"
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_FixProfileShow_ad
AS
BEGIN

DECLARE @user_id            numeric(12,0)
DECLARE @errorReturn        int
DECLARE @rowCountEffected   int
DECLARE @msgReturn          varchar(255)

SELECT  @rowCountEffected = 0 

--SELECT user_id
--INTO tempdb..TEMP_FixProfileShow_ad
--FROM a_profile_dating
--WHERE show_prefs = LOWER(show_prefs) AND show = "Y"

DECLARE CUR_FixProfileShow_ad CURSOR FOR
SELECT user_id from tempdb..TEMP_FixProfileShow_ad
FOR READ ONLY

OPEN CUR_FixProfileShow_ad
FETCH CUR_FixProfileShow_ad INTO @user_id

WHILE @@sqlstatus != 2
BEGIN
    IF @@sqlstatus = 1
    BEGIN
       CLOSE CUR_FixProfileShow_ad
       DEALLOCATE CURSOR CUR_FixProfileShow_ad
       SELECT @msgReturn = "error: there is something wrong with CUR_FixProfileShow_ad"
       PRINT @msgReturn
       RETURN 99
    END
    ELSE BEGIN

       BEGIN TRAN TRAN_FixProfileShow_ad
       
       UPDATE a_profile_dating SET show_prefs = LOWER(show_prefs)  WHERE user_id = @user_id AND show_prefs = UPPER(show_prefs)

       IF @@error = 0
       BEGIN
          COMMIT TRAN TRAN_FixProfileShow_ad
          SELECT @rowCountEffected = @rowCountEffected + 1
       END
       ELSE BEGIN
          ROLLBACK TRAN TRAN_FixProfileShow_ad
       END
      
    END

    FETCH CUR_FixProfileShow_ad INTO @user_id

END

CLOSE CUR_FixProfileShow_ad
DEALLOCATE CURSOR CUR_FixProfileShow_ad
SELECT @msgReturn = "WELL DONE with CUR_FixProfileShow_ad"
PRINT @msgReturn
SELECT @msgReturn = CONVERT(VARCHAR(12),@rowCountEffected) + "ROWS HAVE BEEN EFFECTED"
PRINT @msgReturn
        
END

go
IF OBJECT_ID('dbo.wsp_FixProfileShow_ad') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_FixProfileShow_ad >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_FixProfileShow_ad >>>'
go
EXEC sp_procxmode 'dbo.wsp_FixProfileShow_ad','unchained'
go

