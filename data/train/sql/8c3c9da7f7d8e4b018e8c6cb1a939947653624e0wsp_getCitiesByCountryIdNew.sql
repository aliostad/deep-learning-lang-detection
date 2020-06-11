IF OBJECT_ID('dbo.wsp_getCitiesByCountryIdNew') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCitiesByCountryIdNew
    IF OBJECT_ID('dbo.wsp_getCitiesByCountryIdNew') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCitiesByCountryIdNew >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCitiesByCountryIdNew >>>'
END
go
 /******************************************************************
**
** CREATION:
**   Author: Travis McCauley
**   Date: May 2004
**   Description: Selects all qualifying cities for the countryId supplied
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
create proc wsp_getCitiesByCountryIdNew
@countryId int
as

begin
   set nocount on
   
BEGIN TRAN TRN_getCitiesByCountryIdNew

   select City_new.cityId, jurisdictionId, secondJurisdictionId, cityName, latitudeRad, longitudeRad, tz.legacyName, loc_m
   from City_new
   left join Timezone tz on tz.timezoneId = City_new.timezoneId and City_new.countryId = @countryId
   inner join Country on City_new.countryId = Country.countryId 
      and City_new.countryId = @countryId
      and Country.countryId = @countryId
   and City_new.population >= Country.minPopulation

if @@error =0
   COMMIT TRAN TRN_getCitiesByCountryIdNew
else 
   ROLLBACK TRAN TRN_getCitiesByCountryIdNew
   
end
go
GRANT EXECUTE ON dbo.wsp_getCitiesByCountryIdNew TO web
go
IF OBJECT_ID('dbo.wsp_getCitiesByCountryIdNew') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getCitiesByCountryIdNew >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCitiesByCountryIdNew >>>'
go
EXEC sp_procxmode 'dbo.wsp_getCitiesByCountryIdNew','unchained'
go
GRANT EXECUTE ON dbo.wsp_getCitiesByCountryIdNew TO web
go

