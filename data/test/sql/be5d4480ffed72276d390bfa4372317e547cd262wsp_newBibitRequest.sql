IF OBJECT_ID('dbo.wsp_newBibitRequest') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newBibitRequest
    IF OBJECT_ID('dbo.wsp_newBibitRequest') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newBibitRequest >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newBibitRequest >>>'
END
go

/******************************************************************
**
** CREATION:
**   Author:        Andy Tran
**   Date:          February 2004 
**   Description:   Inserts row into BibitRequest
**
** REVISION(S):
**   Author:        
**   Date:          
**   Description:   
**
******************************************************************************/
CREATE PROCEDURE wsp_newBibitRequest
 @userId            NUMERIC(12,0)
,@transactionId     NUMERIC(12,0)
,@transactionType   VARCHAR(16)
,@merchantCode      VARCHAR(32)
,@currencyId        TINYINT
,@amount            NUMERIC(12,0)
,@cardId            INT
,@ipAddress         VARCHAR(20)
,@sessionId         VARCHAR(64)

AS
DECLARE @return     INT
,@dateCreated       DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateCreated OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_newBibitRequest

INSERT BibitRequest (
     userId
    ,transactionId
    ,transactionType
    ,merchantCode
    ,currencyId
    ,amount
    ,cardId
    ,ipAddress
    ,sessionId
    ,dateCreated
)
VALUES (
     @userId
    ,@transactionId
    ,@transactionType
    ,@merchantCode
    ,@currencyId
    ,@amount
    ,@cardId
    ,@ipAddress
    ,@sessionId
    ,@dateCreated
)

IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_newBibitRequest
        RETURN 0
    END
ELSE
    BEGIN
        ROLLBACK TRAN TRAN_newBibitRequest
        RETURN 99
    END
go

GRANT EXECUTE ON dbo.wsp_newBibitRequest TO web
go

IF OBJECT_ID('dbo.wsp_newBibitRequest') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newBibitRequest >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newBibitRequest >>>'
go

EXEC sp_procxmode 'dbo.wsp_newBibitRequest','unchained'
go
