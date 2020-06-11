IF OBJECT_ID('dbo.wsp_newPayPalResponse') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newPayPalResponse
    IF OBJECT_ID('dbo.wsp_newPayPalResponse') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newPayPalResponse >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newPayPalResponse >>>'
END
go

/*******************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        July 2009
**   Description: Inserts row into PayPalResponse
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*******************************************************************/

CREATE PROCEDURE wsp_newPayPalResponse
 @xactionId     NUMERIC(12,0)
,@tokenId       VARCHAR(20)
,@payerId       VARCHAR(17)
,@responseCode  VARCHAR(5)
,@correlationId VARCHAR(20)
AS

DECLARE
 @dateNow DATETIME
,@return  INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_newPayPalResponse
    INSERT INTO PayPalResponse (
         xactionId
        ,tokenId
        ,payerId
        ,responseCode
        ,correlationId
        ,dateCreated
    )
    VALUES (
         @xactionId
        ,@tokenId
        ,@payerId
        ,@responseCode
        ,@correlationId
        ,@dateNow
    )

    IF @@error != 0
        BEGIN
            ROLLBACK TRAN TRAN_newPayPalResponse
            RETURN 99
        END

    COMMIT TRAN TRAN_newPayPalResponse
    RETURN 0
go

GRANT EXECUTE ON dbo.wsp_newPayPalResponse TO web
go

IF OBJECT_ID('dbo.wsp_newPayPalResponse') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newPayPalResponse >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newPayPalResponse >>>'
go

EXEC sp_procxmode 'dbo.wsp_newPayPalResponse','unchained'
go
