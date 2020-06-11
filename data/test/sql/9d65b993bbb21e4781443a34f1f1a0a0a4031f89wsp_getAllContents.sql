IF OBJECT_ID('dbo.wsp_getAllContents') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAllContents
    IF OBJECT_ID('dbo.wsp_getAllContents') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAllContents >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAllContents >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  May 21, 2003
**   Description:  retrieves all content descriptions
**
**
** REVISION(S):
**   Author:  Yan Liu
**   Date:  Janunary 28 2009
**   Description: append dynamicalFlag to result set.
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getAllContents
AS

BEGIN  
   SELECT contentId,
          contentDesc,
          dynamicalFlag
     FROM Content
   ORDER BY contentId 

   RETURN @@error
END
go

IF OBJECT_ID('dbo.wsp_getAllContents') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getAllContents >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAllContents >>>'
go

GRANT EXECUTE ON dbo.wsp_getAllContents TO web
go
