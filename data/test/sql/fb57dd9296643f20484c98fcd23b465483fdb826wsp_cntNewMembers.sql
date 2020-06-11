IF OBJECT_ID('dbo.wsp_cntNewMembers') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntNewMembers
    IF OBJECT_ID('dbo.wsp_cntNewMembers') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntNewMembers >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntNewMembers >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Jan 7, 2005  
**   Description:  Counts number of new users within time range 
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE  wsp_cntNewMembers
@startSeconds INT,
@endSeconds   INT
AS
BEGIN
    SELECT
        count(*)
    FROM
        user_info
    WHERE
        user_type IN('F', 'P') AND
        signuptime >= @startSeconds AND
        signuptime <= @endSeconds
        
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END
 
go
GRANT EXECUTE ON dbo.wsp_cntNewMembers TO web
go
IF OBJECT_ID('dbo.wsp_cntNewMembers') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntNewMembers >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntNewMembers >>>'
go
EXEC sp_procxmode 'dbo.wsp_cntNewMembers','unchained'
go
