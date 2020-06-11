IF OBJECT_ID('dbo.wsp_newAccountFlag') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newAccountFlag
    IF OBJECT_ID('dbo.wsp_newAccountFlag') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newAccountFlag >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newAccountFlag >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Slobodan Kandic
**   Date:  Aug 12, 2003
**   Description:  Inserts row into AccountFlag table. Note that there can only be one non-reviewed flag per account.
**
** REVISION(S):
**   Author: Mike Stairs
**   Date:  Oct 2003
**   Description: added dateModified
**
******************************************************************************/

CREATE PROCEDURE  wsp_newAccountFlag
 @userId NUMERIC(12,0)
,@reasonContentId SMALLINT
AS

DECLARE  @dateCreated       DATETIME,
         @return 	     INT  
        
EXEC @return = dbo.wsp_GetDateGMT @dateCreated OUTPUT
     
IF @return != 0
   BEGIN
	RETURN @return
   END

BEGIN TRAN TRAN_newAccountFlag

INSERT AccountFlag
(
userId
,reasonContentId
,reviewed
,dateCreated
,dateModified
)
VALUES
(
@userId
,@reasonContentId
,"N"
,@dateCreated
,@dateCreated
)
IF @@error = 0
  BEGIN
    COMMIT TRAN TRAN_newAccountFlag
    RETURN 0
  END
ELSE
  BEGIN
    ROLLBACK TRAN TRAN_newAccountFlag
    RETURN 99
  END 

 
go
GRANT EXECUTE ON dbo.wsp_newAccountFlag TO web
go
IF OBJECT_ID('dbo.wsp_newAccountFlag') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_newAccountFlag >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newAccountFlag >>>'
go
EXEC sp_procxmode 'dbo.wsp_newAccountFlag','unchained'
go
