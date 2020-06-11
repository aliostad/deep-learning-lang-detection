IF OBJECT_ID('dbo.wsp_newAccountingEvent') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.wsp_newAccountingEvent
	IF OBJECT_ID('dbo.wsp_newAccountingEvent') IS NOT NULL
		PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newAccountingEvent >>>'
	ELSE
		PRINT '<<< DROPPED PROCEDURE dbo.wsp_newAccountingEvent >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:      DataAccessGenerator
**   Date:        Oct 03 2003 at 09:13AM
**   Description:
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_newAccountingEvent
 @userId numeric(12,0)
,@eventType char(1)
,@xactionId numeric(12,0)
,@cardNum varchar(64)
,@encodedCardNum varchar(64)
,@dateCreated datetime
AS
BEGIN

BEGIN TRAN TRAN_newAccountingEvent

INSERT INTO AccountingEvent
(
 userId
,eventType
,xactionId
,cardNum
,encodedCardNum
,dateCreated
)
VALUES
(
 @userId
,@eventType
,@xactionId
,@cardNum
,@encodedCardNum
,@dateCreated
)

IF @@error = 0
	BEGIN
		COMMIT TRAN TRAN_newAccountingEvent
		RETURN 0
	END
ELSE
	BEGIN
		ROLLBACK TRAN TRAN_newAccountingEvent
		RETURN 99
	END

END
go

GRANT EXECUTE ON dbo.wsp_newAccountingEvent TO web
go

IF OBJECT_ID('dbo.wsp_newAccountingEvent') IS NOT NULL
	PRINT '<<< CREATED PROCEDURE dbo.wsp_newAccountingEvent >>>'
ELSE
	PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newAccountingEvent >>>'
go

EXEC sp_procxmode 'dbo.wsp_newAccountingEvent','unchained'
go

