IF OBJECT_ID('dbo.wsp_getLatLongByCityNew') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getLatLongByCityNew
    IF OBJECT_ID('dbo.wsp_getLatLongByCityNew') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getLatLongByCityNew >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getLatLongByCityNew >>>'
END
go 

/***********************************************************************
**
** CREATION:
**   Author: Generator 
**   Date: @TIMESTAMP@ 
**   Description: getLatLongByCity 
**
*************************************************************************/
CREATE PROCEDURE  wsp_getLatLongByCityNew
    @cityId int
AS

BEGIN

   BEGIN TRAN TRAN_getLatLongByCityNew


   
   DECLARE @lat int, @lon int   
   SELECT latitudeRad as latitude, longitudeRad as longitude
   FROM City_new
   WHERE cityId = @cityId 

  -- IF @lat IS NOT NULL

  -- BEGIN

   --SELECT @lat=@lat-2 
   --SELECT @lat as latitude, @lon as longitude 
  -- END

    


   IF @@error = 0
   BEGIN
      COMMIT TRAN TRAN_getLatLongByCityNew
   END
   ELSE BEGIN
      ROLLBACK TRAN TRAN_getLatLongByCityNew
   END

END
go

GRANT EXECUTE ON dbo.wsp_getLatLongByCityNew TO web
go

IF OBJECT_ID('dbo.wsp_getLatLongByCityNew') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getLatLongByCityNew >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getLatLongByCityNew >>>'
go

EXEC sp_procxmode 'dbo.wsp_getLatLongByCityNew','unchained'
go

