IF OBJECT_ID('dbo.wsp_newPaymentechTransaction') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newPaymentechTransaction
    IF OBJECT_ID('dbo.wsp_newPaymentechTransaction') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newPaymentechTransaction >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newPaymentechTransaction >>>'
END
go

/*******************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        March 18 2005 
**   Description: Inserts row into PaymentechTransaction
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*******************************************************************/

CREATE PROCEDURE wsp_newPaymentechTransaction
 @transactionId   NUMERIC(12,0)
,@recordType      CHAR(1)
,@transactionText VARCHAR(255)
AS
DECLARE
 @return          INT
,@dateCreated     DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateCreated OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_newPaymentechTransaction

INSERT INTO PaymentechTransaction (
     transactionId
    ,recordType
    ,transactionText
    ,dateCreated
)
VALUES (
     @transactionId
    ,@recordType
    ,@transactionText
    ,@dateCreated
)

IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_newPaymentechTransaction
        RETURN 0
    END
ELSE
    BEGIN
        ROLLBACK TRAN TRAN_newPaymentechTransaction
        RETURN 99
    END
go

GRANT EXECUTE ON dbo.wsp_newPaymentechTransaction TO web
go

IF OBJECT_ID('dbo.wsp_newPaymentechTransaction') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newPaymentechTransaction >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newPaymentechTransaction >>>'
go

EXEC sp_procxmode 'dbo.wsp_newPaymentechTransaction','unchained'
go
