IF OBJECT_ID('dbo.wsp_newBillToMobileResponse') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newBillToMobileResponse
    IF OBJECT_ID('dbo.wsp_newBillToMobileResponse') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newBillToMobileResponse >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newBillToMobileResponse >>>'
END
go

/*******************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        April 2011 
**   Description: Inserts row into BillToMobileResponse.
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*******************************************************************/

CREATE PROCEDURE wsp_newBillToMobileResponse
    @xactionId  NUMERIC(12,0)
   ,@response   VARCHAR(1000)

AS
DECLARE
 @dateNow DATETIME
,@return  INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_newBillToMobileResponse

    INSERT INTO BillToMobileResponse (
         xactionId
        ,response
        ,dateCreated
        ,dateModified
    )
    VALUES (
         @xactionId
        ,@response
        ,@dateNow
        ,@dateNow
    )

    IF @@error != 0
        BEGIN
            ROLLBACK TRAN TRAN_newBillToMobileResponse
            RETURN 99
        END

    COMMIT TRAN TRAN_newBillToMobileResponse
    RETURN 0
go

EXEC sp_procxmode 'dbo.wsp_newBillToMobileResponse','unchained'
go

IF OBJECT_ID('dbo.wsp_newBillToMobileResponse') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newBillToMobileResponse >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newBillToMobileResponse >>>'
go

GRANT EXECUTE ON dbo.wsp_newBillToMobileResponse TO web
go
