USE Member
go
IF OBJECT_ID('dbo.wsp_getNewMembersListNoStatus') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getNewMembersListNoStatus
    IF OBJECT_ID('dbo.wsp_getNewMembersListNoStatus') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getNewMembersListNoStatus >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getNewMembersListNoStatus >>>'
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
CREATE PROCEDURE wsp_getNewMembersListNoStatus
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
      FROM user_info (index user_info_idx3)
     WHERE user_type IN('F', 'P')
       AND signuptime >= @startSeconds 
       AND signuptime <  @endSeconds
    --AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go
EXEC sp_procxmode 'dbo.wsp_getNewMembersListNoStatus','unchained'
go
IF OBJECT_ID('dbo.wsp_getNewMembersListNoStatus') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getNewMembersListNoStatus >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getNewMembersListNoStatus >>>'
go
GRANT EXECUTE ON dbo.wsp_getNewMembersListNoStatus TO web
go
