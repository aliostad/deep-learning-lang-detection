IF OBJECT_ID('dbo.wsp_newCCTranInWaiting') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newCCTranInWaiting
    IF OBJECT_ID('dbo.wsp_newCCTranInWaiting') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newCCTranInWaiting >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newCCTranInWaiting >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  TK Chan
**   Date:    May 16 2005
**   Description:  Insert a row to CreditCardTransaction to mark a credit card transaction which has been authorized
**                 Copy of wsp_newCCTran
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_newCCTranInWaiting
  @xactionId  numeric(12,0)

AS
  DECLARE @rowcount INT
  DECLARE @error    INT
  DECLARE @return	INT
  DECLARE @dateGMT	DATETIME

  EXEC @return = dbo.wsp_GetDateGMT @dateGMT OUTPUT
  IF @return != 0
  BEGIN
     RETURN @return
  END
  
  BEGIN TRAN wsp_newCCTranInWaiting

  INSERT CreditCardTransaction
        (xactionId,
         dateCreated,
         CCTranStatusId )
  VALUES
        (@xactionId,
         @dateGMT,
         6) -- 6 MEANS "WAITING/NEW/NO SETTLE YET"

  SELECT @error = @@error, @rowcount = @@rowcount

  IF @error = 0 
  BEGIN
    COMMIT TRAN wsp_newCCTranInWaiting
  END 
  ELSE BEGIN
    ROLLBACK TRAN wsp_newCCTranInWaiting
  END
  
  SELECT @error AS RESULT,@rowcount AS ROWCNT,@xactionId AS PRIMKEY

go
IF OBJECT_ID('dbo.wsp_newCCTranInWaiting') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newCCTranInWaiting >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newCCTranInWaiting >>>'
go
EXEC sp_procxmode 'dbo.wsp_newCCTranInWaiting','unchained'
go
GRANT EXECUTE ON dbo.wsp_newCCTranInWaiting TO web
go
