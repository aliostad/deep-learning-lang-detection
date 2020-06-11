IF OBJECT_ID('dbo.wsp_newBillToMobileRequest') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newBillToMobileRequest
    IF OBJECT_ID('dbo.wsp_newBillToMobileRequest') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newBillToMobileRequest >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newBillToMobileRequest >>>'
END
go

/*******************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        April 2011 
**   Description: Inserts row into BillToMobileRequest.
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*******************************************************************/

CREATE PROCEDURE wsp_newBillToMobileRequest
    @xactionId  NUMERIC(12,0)
   ,@userId     NUMERIC(12,0)
   ,@request    VARCHAR(1000)

AS
DECLARE
 @dateNow DATETIME
,@return  INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_newBillToMobileRequest

    INSERT INTO BillToMobileRequest (
         xactionId
        ,userId
        ,request
        ,dateCreated
    )
    VALUES (
         @xactionId
        ,@userId
        ,@request
        ,@dateNow
    )

    IF @@error != 0
        BEGIN
            ROLLBACK TRAN TRAN_newBillToMobileRequest
            RETURN 99
        END

    COMMIT TRAN TRAN_newBillToMobileRequest
    RETURN 0
go

EXEC sp_procxmode 'dbo.wsp_newBillToMobileRequest','unchained'
go

IF OBJECT_ID('dbo.wsp_newBillToMobileRequest') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newBillToMobileRequest >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newBillToMobileRequest >>>'
go

GRANT EXECUTE ON dbo.wsp_newBillToMobileRequest TO web
go
