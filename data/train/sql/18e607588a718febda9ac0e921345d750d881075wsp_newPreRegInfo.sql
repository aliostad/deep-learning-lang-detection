USE Member
go

IF OBJECT_ID('dbo.wsp_newPreRegInfo') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newPreRegInfo
    IF OBJECT_ID('dbo.wsp_newPreRegInfo') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newPreRegInfo >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newPreRegInfo >>>'  
END
go

CREATE PROCEDURE wsp_newPreRegInfo
 @email              VARCHAR(129)
AS

DECLARE 
 @dateNow DATETIME
,@return INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
	BEGIN
		RETURN @return
	END

BEGIN TRAN TRAN_newPreRegInfo

IF NOT EXISTS (SELECT 1  FROM PreRegInfo WHERE email = @email) 

BEGIN
    INSERT INTO dbo.PreRegInfo ( email ,dateCreated)
    VALUES ( @email ,@dateNow)
END



IF @@error = 0
  BEGIN
    COMMIT TRAN TRAN_newPreRegInfo
    RETURN 0
  END
ELSE
  BEGIN
		ROLLBACK TRAN TRAN_newPreRegInfo
		RETURN 99
  END


go
IF OBJECT_ID('dbo.wsp_newPreRegInfo') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newPreRegInfo >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newPreRegInfo >>>'
go
EXEC sp_procxmode 'dbo.wsp_newPreRegInfo','unchained'
go
GRANT EXECUTE ON dbo.wsp_newPreRegInfo TO web
go



