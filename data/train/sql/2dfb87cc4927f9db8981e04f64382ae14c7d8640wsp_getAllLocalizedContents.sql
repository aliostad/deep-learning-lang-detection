IF OBJECT_ID('dbo.wsp_getAllLocalizedContents') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAllLocalizedContents
    IF OBJECT_ID('dbo.wsp_getAllLocalizedContents') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAllLocalizedContents >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAllLocalizedContents >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  May 21, 2003
**   Description:  retrieves all package descriptions
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
CREATE PROCEDURE dbo.wsp_getAllLocalizedContents
AS

BEGIN  
   SELECT localeId,
          contentId,
          contentText,
          dynamicalFlag
     FROM LocaleContent
   ORDER BY localeId 

   RETURN @@error
END
go

IF OBJECT_ID('dbo.wsp_getAllLocalizedContents') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getAllLocalizedContents >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAllLocalizedContents >>>'
go

GRANT EXECUTE ON dbo.wsp_getAllLocalizedContents TO web
go

