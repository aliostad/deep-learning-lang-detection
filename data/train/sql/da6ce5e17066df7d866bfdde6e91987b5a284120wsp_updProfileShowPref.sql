IF OBJECT_ID('dbo.wsp_updProfileShowPref') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfileShowPref
    IF OBJECT_ID('dbo.wsp_updProfileShowPref') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfileShowPref >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfileShowPref >>>'
END
go
  /*************************************************************************
**
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  June 7 2002
**   Description:  Updates show preferences for a given user id
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
**************************************************************************/

CREATE PROCEDURE wsp_updProfileShowPref
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@userId numeric(12,0)
AS

BEGIN TRAN TRAN_updProfileShowPref

    UPDATE a_profile_dating SET
    show_prefs = LOWER(show_prefs)
    WHERE user_id = @userId
    AND show_prefs = UPPER(show_prefs)

    IF @@rowcount = 1
        BEGIN
            COMMIT TRAN TRAN_updProfileShowPref
            RETURN 0
        END
    ELSE
        BEGIN
            UPDATE a_profile_dating SET
            show_prefs = "Y" 
            WHERE user_id = @userId
            AND show_prefs = LOWER(show_prefs)

            IF @@error = 0
                BEGIN
                    COMMIT TRAN TRAN_updProfileShowPref
                    RETURN 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_updProfileShowPref
                    RETURN 99
                END
        END 
 
go
GRANT EXECUTE ON dbo.wsp_updProfileShowPref TO web
go
IF OBJECT_ID('dbo.wsp_updProfileShowPref') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfileShowPref >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfileShowPref >>>'
go
EXEC sp_procxmode 'dbo.wsp_updProfileShowPref','unchained'
go
