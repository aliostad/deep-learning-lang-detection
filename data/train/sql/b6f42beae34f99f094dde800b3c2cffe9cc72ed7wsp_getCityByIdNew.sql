IF OBJECT_ID('dbo.wsp_getCityByIdNew') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCityByIdNew
    IF OBJECT_ID('dbo.wsp_getCityByIdNew') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCityByIdNew >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCityByIdNew >>>'
END
go
create proc wsp_getCityByIdNew
@id int
as

begin
   set nocount on

   select countryId, jurisdictionId, secondJurisdictionId, cityName, latitudeRad, longitudeRad, tz.legacyName from City_new
   left join Timezone tz on tz.timezoneId = City_new.timezoneId and cityId = @id
   where cityId = @id
end
go
GRANT EXECUTE ON dbo.wsp_getCityByIdNew TO web
go
IF OBJECT_ID('dbo.wsp_getCityByIdNew') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getCityByIdNew >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCityByIdNew >>>'
go
EXEC sp_procxmode 'dbo.wsp_getCityByIdNew','unchained'
go
GRANT EXECUTE ON dbo.wsp_getCityByIdNew TO web
go

