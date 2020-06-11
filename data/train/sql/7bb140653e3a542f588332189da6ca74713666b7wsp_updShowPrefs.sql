IF OBJECT_ID('dbo.wsp_updShowPrefs') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updShowPrefs
    IF OBJECT_ID('dbo.wsp_updShowPrefs') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updShowPrefs >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updShowPrefs >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Jack Veiga,Jeff Yang
**   Date:  Oct 22, 2002
**   Description:  Updates show_prefs on profile
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: March 24, 2004
**   Description: update language mask at the same time
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: June 9, 2006
**   Description: update mediaReleaseFlag at the same time
**
*************************************************************************/

CREATE PROCEDURE wsp_updShowPrefs
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC(12,0)
,@show_prefs CHAR(1)
,@languagesSpokenMask INT
,@mediaReleaseFlag CHAR(1)

AS
DECLARE @show CHAR(1)
IF @show_prefs = 'Y' OR @show_prefs = 'O'
   SELECT @show = 'Y'
ELSE
   SELECT @show = 'N'

BEGIN TRAN TRAN_updShowPrefs

    UPDATE a_profile_dating SET
    show_prefs = @show_prefs, show = @show, languagesSpokenMask=@languagesSpokenMask, mediaReleaseFlag=@mediaReleaseFlag
    WHERE user_id = @userId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updShowPrefs
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updShowPrefs
            RETURN 99
        END
 
go
GRANT EXECUTE ON dbo.wsp_updShowPrefs TO web
go
IF OBJECT_ID('dbo.wsp_updShowPrefs') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updShowPrefs >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updShowPrefs >>>'
go
EXEC sp_procxmode 'dbo.wsp_updShowPrefs','unchained'
go
