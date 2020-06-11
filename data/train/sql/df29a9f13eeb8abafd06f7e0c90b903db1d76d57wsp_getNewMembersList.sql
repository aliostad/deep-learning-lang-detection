IF OBJECT_ID('dbo.wsp_getNewMembersList') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getNewMembersList
    IF OBJECT_ID('dbo.wsp_getNewMembersList') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getNewMembersList >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getNewMembersList >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author: Mike Stairs
**   Date:  Jan 14, 2005  
**   Description:  gets list of new users within time range 
**          
** REVISION(S):
**   Author: Yan Liu 
**   Date:  July 20, 2006
**   Description: append a few new columns in the result set.
**
******************************************************************************/
CREATE PROCEDURE wsp_getNewMembersList
    @startSeconds INT,
    @endSeconds   INT
AS

BEGIN
    SELECT user_id,
           signuptime,
           firstidentitytime,
           signup_adcode,
           user_type,
           email,
           zipcode
      FROM user_info
     WHERE user_type IN('F', 'P') 
       AND signuptime >= @startSeconds 
       AND signuptime <  @endSeconds
       AND status = 'A'
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getNewMembersList TO web
go

IF OBJECT_ID('dbo.wsp_getNewMembersList') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getNewMembersList >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getNewMembersList >>>'
go

EXEC sp_procxmode 'dbo.wsp_getNewMembersList','unchained'
go
