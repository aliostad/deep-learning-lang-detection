IF OBJECT_ID('dbo.wsp_newEmailEasyStepGuide') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newEmailEasyStepGuide
    IF OBJECT_ID('dbo.wsp_newEmailEasyStepGuide') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newEmailEasyStepGuide >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newEmailEasyStepGuide >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  October 18 2002
**   Description:  Inserts row into EmailEasyStepGuide
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE wsp_newEmailEasyStepGuide
 @email CHAR(129)
,@userId NUMERIC(12,0)

AS
DECLARE @return INT

SELECT @email = UPPER(@email)

IF NOT EXISTS (SELECT 1 FROM EmailEasyStepGuide WHERE email = @email)

	BEGIN
		DECLARE @dateCreated DATETIME

		EXEC @return = wsp_GetDateGMT @dateCreated OUTPUT
		IF @return != 0
    		BEGIN
        		RETURN @return
    		END

		BEGIN TRAN TRAN_newEmailEasyStepGuide

		INSERT INTO EmailEasyStepGuide 
		(email
		,userId
		,dateCreated
		) VALUES
		(@email
		,@userId
		,@dateCreated
		)
		IF @@error = 0
			BEGIN
       			COMMIT TRAN TRAN_newEmailEasyStepGuide
       			RETURN 0
   			END
   		ELSE
   			BEGIN
       			ROLLBACK TRAN TRAN_newEmailEasyStepGuide
       			RETURN 99
   			END
	END

ELSE

  BEGIN
	RETURN 0
  END
 
go
GRANT EXECUTE ON dbo.wsp_newEmailEasyStepGuide TO web
go
IF OBJECT_ID('dbo.wsp_newEmailEasyStepGuide') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_newEmailEasyStepGuide >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newEmailEasyStepGuide >>>'
go
EXEC sp_procxmode 'dbo.wsp_newEmailEasyStepGuide','unchained'
go
