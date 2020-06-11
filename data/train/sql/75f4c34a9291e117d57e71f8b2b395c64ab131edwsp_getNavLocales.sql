IF OBJECT_ID('dbo.wsp_getNavLocales') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getNavLocales
    IF OBJECT_ID('dbo.wsp_getNavLocales') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getNavLocales >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getNavLocales >>>'
END
go
  /***********************************************************************
**
** CREATION:
**   Author:  Valeri Popov
**   Date:  Apr. 8, 2004
**   Description:  Retrieves all the languages
**
** REVISION(S):
**   Author:  Valeri Popov
**   Date: Sep. 08, 2004
**   Description: added resourceLocale column
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Feb 3, 2005
**   Description: added localMiles
**
*************************************************************************/

CREATE PROCEDURE  wsp_getNavLocales
AS

BEGIN
	select NavigateLocale.localeId, 
           NavigateLocale.languageId, 
           Country.countryCodeIso, 
           NavigateLocale.resourceLocale,
           NavigateLocale.localMiles,
           NavigateLocale.localizedSearchFlag
	from NavigateLocale 
		left outer join Country on NavigateLocale.countryId = Country.countryId
    order by NavigateLocale.localeId

	RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getNavLocales TO web
go
IF OBJECT_ID('dbo.wsp_getNavLocales') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getNavLocales >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getNavLocales >>>'
go
EXEC sp_procxmode 'dbo.wsp_getNavLocales','unchained'
go
