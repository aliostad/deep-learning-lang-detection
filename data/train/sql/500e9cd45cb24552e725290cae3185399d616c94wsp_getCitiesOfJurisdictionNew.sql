IF OBJECT_ID('dbo.wsp_getCitiesOfJurisdictionNew') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCitiesOfJurisdictionNew
    IF OBJECT_ID('dbo.wsp_getCitiesOfJurisdictionNew') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCitiesOfJurisdictionNew >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCitiesOfJurisdictionNew >>>'
END
go
create proc wsp_getCitiesOfJurisdictionNew
@jurisdictionId smallint
as
begin
   set nocount on
   select cityId, cityName
   from City_new, Jurisdiction, Country
   where City_new.jurisdictionId = Jurisdiction.jurisdictionId
   and City_new.jurisdictionId = @jurisdictionId
   and Jurisdiction.jurisdictionId = @jurisdictionId
   and Jurisdiction.parentId = @jurisdictionId
   and City_new.secondJurisdictionId = -1
   and City_new.countryId = Country.countryId
   and City_new.population >= Country.minPopulation
   order by cityName
end
go
GRANT EXECUTE ON dbo.wsp_getCitiesOfJurisdictionNew TO web
go
IF OBJECT_ID('dbo.wsp_getCitiesOfJurisdictionNew') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getCitiesOfJurisdictionNew >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCitiesOfJurisdictionNew >>>'
go
EXEC sp_procxmode 'dbo.wsp_getCitiesOfJurisdictionNew','unchained'
go
GRANT EXECUTE ON dbo.wsp_getCitiesOfJurisdictionNew TO web
go

