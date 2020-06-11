IF OBJECT_ID('dbo.wsp_getCitiesForceIntoJurisNew') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCitiesForceIntoJurisNew
    IF OBJECT_ID('dbo.wsp_getCitiesForceIntoJurisNew') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCitiesForceIntoJurisNew >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCitiesForceIntoJurisNew >>>'
END
go
create proc wsp_getCitiesForceIntoJurisNew
@jurisdictionId smallint
as
begin
   set nocount on
   select cityId, cityName
   from City_new, Jurisdiction, Country
   where City_new.jurisdictionId = Jurisdiction.jurisdictionId
   and City_new.jurisdictionId = @jurisdictionId
   and Jurisdiction.jurisdictionId = @jurisdictionId
   and City_new.countryId = Country.countryId
   and City_new.population >= Country.minPopulation
   order by cityName
end
go
GRANT EXECUTE ON dbo.wsp_getCitiesForceIntoJurisNew TO web
go
IF OBJECT_ID('dbo.wsp_getCitiesForceIntoJurisNew') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getCitiesForceIntoJurisNew >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCitiesForceIntoJurisNew >>>'
go
EXEC sp_procxmode 'dbo.wsp_getCitiesForceIntoJurisNew','unchained'
go
GRANT EXECUTE ON dbo.wsp_getCitiesForceIntoJurisNew TO web
go

