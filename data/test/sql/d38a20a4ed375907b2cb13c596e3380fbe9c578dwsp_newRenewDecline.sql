IF OBJECT_ID('dbo.wsp_newRenewDecline') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newRenewDecline
    IF OBJECT_ID('dbo.wsp_newRenewDecline') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newRenewDecline >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newRenewDecline >>>'
END
go

CREATE PROCEDURE dbo.wsp_newRenewDecline
   @userId                    NUMERIC(12,0),
   @xactionId                 INT
AS

BEGIN
   INSERT INTO RenewDeclineTransaction(userId, xactionId)
   VALUES(@userId, @xactionId)
END
go

IF OBJECT_ID('dbo.wsp_newRenewDecline') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newRenewDecline >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newRenewDecline >>>'
go

GRANT EXECUTE ON dbo.wsp_newRenewDecline TO web
go

