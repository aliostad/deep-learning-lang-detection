IF OBJECT_ID('dbo.wsp_newBillToMobileNotify') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newBillToMobileNotify
    IF OBJECT_ID('dbo.wsp_newBillToMobileNotify') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newBillToMobileNotify >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newBillToMobileNotify >>>'
END
go

/*******************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        April 2011 
**   Description: Inserts row into BillToMobileNotify.
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*******************************************************************/

CREATE PROCEDURE wsp_newBillToMobileNotify
    @xactionId     NUMERIC(12,0)
   ,@notification  VARCHAR(1000)

AS
DECLARE
 @dateNow DATETIME
,@return  INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_newBillToMobileNotify

    INSERT INTO BillToMobileNotify (
         xactionId
        ,notification
        ,dateCreated
    )
    VALUES (
         @xactionId
        ,@notification
        ,@dateNow
    )

    IF @@error != 0
        BEGIN
            ROLLBACK TRAN TRAN_newBillToMobileNotify
            RETURN 99
        END

    COMMIT TRAN TRAN_newBillToMobileNotify
    RETURN 0
go

EXEC sp_procxmode 'dbo.wsp_newBillToMobileNotify','unchained'
go

IF OBJECT_ID('dbo.wsp_newBillToMobileNotify') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newBillToMobileNotify >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newBillToMobileNotify >>>'
go

GRANT EXECUTE ON dbo.wsp_newBillToMobileNotify TO web
go
