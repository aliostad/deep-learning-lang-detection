IF OBJECT_ID('dbo.wsp_newRenewalXaction') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newRenewalXaction
    IF OBJECT_ID('dbo.wsp_newRenewalXaction') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newRenewalXaction >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newRenewalXaction >>>'
END
go
 /******************************************************************
**
** CREATION:
**   Author:  Andy Tran
**   Date:  June 2008 
**   Description:  Inserts row into RenewalTransaction
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_newRenewalXaction
 @userId                     NUMERIC(12,0)
,@subscriptionOfferDetailId  SMALLINT
AS
DECLARE
 @return   INT
,@dateNow  DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_newRenewalXaction

    INSERT RenewalTransaction (
         userId
        ,subscriptionOfferDetailId
        ,dateCreated
    )
    VALUES (
         @userId
        ,@subscriptionOfferDetailId
        ,@dateNow
    )

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_newRenewalXaction
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_newRenewalXaction
            RETURN 99
        END
go

GRANT EXECUTE ON dbo.wsp_newRenewalXaction TO web
go

IF OBJECT_ID('dbo.wsp_newRenewalXaction') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_newRenewalXaction >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newRenewalXaction >>>'
go

EXEC sp_procxmode 'dbo.wsp_newRenewalXaction','unchained'
go
