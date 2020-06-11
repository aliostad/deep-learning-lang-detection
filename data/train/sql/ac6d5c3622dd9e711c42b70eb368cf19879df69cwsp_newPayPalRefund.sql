IF OBJECT_ID('dbo.wsp_newPayPalRefund') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newPayPalRefund
    IF OBJECT_ID('dbo.wsp_newPayPalRefund') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newPayPalRefund >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newPayPalRefund >>>'
END
go

/*******************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        July 2009
**   Description: Inserts row into PayPalRefund
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*******************************************************************/

CREATE PROCEDURE wsp_newPayPalRefund
 @xactionId        NUMERIC(12,0)
,@refPaymentNumber VARCHAR(19)
,@refundType       VARCHAR(7)
,@refundAmount     VARCHAR(7)
,@currencyCode     CHAR(3)
AS

DECLARE
 @dateNow DATETIME
,@return  INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_newPayPalRefund
    INSERT INTO PayPalRefund (
         xactionId
        ,refPaymentNumber
        ,refundType
        ,refundAmount
        ,currencyCode
        ,dateCreated
    )
    VALUES (
         @xactionId
        ,@refPaymentNumber
        ,@refundType
        ,@refundAmount
        ,@currencyCode
        ,@dateNow
    )

    IF @@error != 0
        BEGIN
            ROLLBACK TRAN TRAN_newPayPalRefund
            RETURN 99
        END

    COMMIT TRAN TRAN_newPayPalRefund
    RETURN 0
go

GRANT EXECUTE ON dbo.wsp_newPayPalRefund TO web
go

IF OBJECT_ID('dbo.wsp_newPayPalRefund') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newPayPalRefund >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newPayPalRefund >>>'
go

EXEC sp_procxmode 'dbo.wsp_newPayPalRefund','unchained'
go
