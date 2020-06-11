IF OBJECT_ID('dbo.wsp_getCitiesOf2ndJurisdicNew') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCitiesOf2ndJurisdicNew
    IF OBJECT_ID('dbo.wsp_getCitiesOf2ndJurisdicNew') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCitiesOf2ndJurisdicNew >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCitiesOf2ndJurisdicNew >>>'
END
go
create proc wsp_getCitiesOf2ndJurisdicNew
@jurisdictionId smallint
as

begin
   set nocount on

   select cityId, cityName
   from City_new, Jurisdiction, Country
   where City_new.secondJurisdictionId = Jurisdiction.jurisdictionId
   and City_new.secondJurisdictionId = @jurisdictionId
   and Jurisdiction.jurisdictionId = @jurisdictionId
   and City_new.countryId = Country.countryId
   and City_new.population >= Country.minPopulation
   order by cityName

end
go
GRANT EXECUTE ON dbo.wsp_getCitiesOf2ndJurisdicNew TO web
go
IF OBJECT_ID('dbo.wsp_getCitiesOf2ndJurisdicNew') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getCitiesOf2ndJurisdicNew >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCitiesOf2ndJurisdicNew >>>'
go
EXEC sp_procxmode 'dbo.wsp_getCitiesOf2ndJurisdicNew','unchained'
go
GRANT EXECUTE ON dbo.wsp_getCitiesOf2ndJurisdicNew TO web
go

