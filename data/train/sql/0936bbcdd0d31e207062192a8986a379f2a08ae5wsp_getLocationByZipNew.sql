IF OBJECT_ID('dbo.wsp_getLocationByZipNew') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getLocationByZipNew
    IF OBJECT_ID('dbo.wsp_getLocationByZipNew') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getLocationByZipNew >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getLocationByZipNew >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Description: getLocationByZip 
**
*************************************************************************/
CREATE PROCEDURE  wsp_getLocationByZipNew
    @postalCode varchar(10)
AS

BEGIN

   BEGIN TRAN TRAN_getLocationByZipNew

   SELECT countryId, jurisdictionId, secondJurisdictionId, cityId 
   FROM PostalZipCode_New 
   WHERE zipcode=@postalCode

   IF @@error = 0
   BEGIN
      COMMIT TRAN TRAN_getLocationByZipNew
   END
   ELSE BEGIN
      ROLLBACK TRAN TRAN_getLocationByZipNew
   END

END

go
IF OBJECT_ID('dbo.wsp_getLocationByZipNew') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getLocationByZipNew >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getLocationByZipNew >>>'
go
EXEC sp_procxmode 'dbo.wsp_getLocationByZipNew','unchained'
go
GRANT EXECUTE ON dbo.wsp_getLocationByZipNew TO web
go
