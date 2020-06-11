IF OBJECT_ID('dbo.wsp_newBibitResponse') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newBibitResponse
    IF OBJECT_ID('dbo.wsp_newBibitResponse') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newBibitResponse >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newBibitResponse >>>'
END
go

/******************************************************************
**
** CREATION:
**   Author:        Andy Tran
**   Date:          February 2004
**   Description:   Inserts row into BibitResponse
**
** REVISION(S):
**   Author:        
**   Date:          
**   Description:   
**
******************************************************************************/
CREATE PROCEDURE wsp_newBibitResponse
 @transactionId     NUMERIC(12,0)
,@referenceId       NUMERIC(12,0)
,@actionCode        VARCHAR(3)
,@responseText      VARCHAR(32)
,@avsResponseText   VARCHAR(32)
,@cvcResponseText   VARCHAR(32)
,@errorMessage      VARCHAR(255)

AS
DECLARE @return		INT
,@dateCreated		DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateCreated OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_newBibitResponse

INSERT BibitResponse (
     transactionId
    ,referenceId
    ,actionCode
    ,responseText
    ,avsResponseText
    ,cvcResponseText
    ,errorMessage
    ,dateCreated
)
VALUES (
     @transactionId
    ,@referenceId
    ,@actionCode
    ,@responseText
    ,@avsResponseText
    ,@cvcResponseText
    ,@errorMessage
    ,@dateCreated
)

IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_newBibitResponse
        RETURN 0
    END
ELSE
    BEGIN
        ROLLBACK TRAN TRAN_newBibitResponse
        RETURN 99
    END
go

GRANT EXECUTE ON dbo.wsp_newBibitResponse TO web
go

IF OBJECT_ID('dbo.wsp_newBibitResponse') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newBibitResponse >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newBibitResponse >>>'
go

EXEC sp_procxmode 'dbo.wsp_newBibitResponse','unchained'
go
