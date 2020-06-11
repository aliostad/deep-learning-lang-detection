IF OBJECT_ID('dbo.wsp_updProfileShowShowP') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfileShowShowP
    IF OBJECT_ID('dbo.wsp_updProfileShowShowP') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfileShowShowP >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfileShowShowP >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Mark Jaeckle
**   Date:  November 11 2002
**   Description:  Updates show and showprefs on profile
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE wsp_updProfileShowShowP
 @productCode CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC(12,0)
,@show CHAR(1)
,@show_prefs CHAR(1)

AS

BEGIN TRAN TRAN_updProfileShowShowP
	UPDATE a_profile_dating 
	SET show_prefs = @show_prefs,show = @show
	WHERE user_id=@userId

	IF @@error = 0
		BEGIN
			COMMIT TRAN TRAN_updProfileShowShowP
			RETURN 0
		END
	ELSE
		BEGIN
			ROLLBACK TRAN TRAN_updProfileShowShowP
			RETURN 99
		END
 
go
GRANT EXECUTE ON dbo.wsp_updProfileShowShowP TO web
go
IF OBJECT_ID('dbo.wsp_updProfileShowShowP') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfileShowShowP >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfileShowShowP >>>'
go
EXEC sp_procxmode 'dbo.wsp_updProfileShowShowP','unchained'
go
