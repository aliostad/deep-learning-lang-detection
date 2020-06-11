IF OBJECT_ID('dbo.wsp_newUserCreditExpiry') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newUserCreditExpiry
    IF OBJECT_ID('dbo.wsp_newUserCreditExpiry') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newUserCreditExpiry >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newUserCreditExpiry >>>'
END
go
  /******************************************************************
**
** CREATION:
**   Author: Yan Liu	 
**   Date:  Mar 15 2004
**   Description: Inserts a row into UserCreditExpiry
**           
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_newUserCreditExpiry
    @userId        NUMERIC(12,0),
    @userLastOn    INT,
    @emailStatus   CHAR(1),
    @dateEmailSent DATETIME,
    @dateModified  DATETIME
AS
     
BEGIN TRAN TRAN_newUserCreditExpiry
    BEGIN
        INSERT INTO UserCreditExpiry (
            userId,
            userLastOn,
            emailStatus,
            dateEmailSent,
            dateModified
        )
        VALUES (
            @userId,       
            @userLastOn,    
            @emailStatus,       
            @dateEmailSent,
            @dateModified
        )

        IF @@error = 0
            BEGIN
                COMMIT TRAN TRAN_newUserCreditExpiry
                RETURN 0
            END
        ELSE
            BEGIN
                ROLLBACK TRAN TRAN_newUserCreditExpiry
                RETURN 99
            END
    END
go

GRANT EXECUTE ON dbo.wsp_newUserCreditExpiry TO web
go

IF OBJECT_ID('dbo.wsp_newUserCreditExpiry') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_newUserCreditExpiry >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newUserCreditExpiry >>>'
go
EXEC sp_procxmode 'dbo.wsp_newUserCreditExpiry','unchained'
go
