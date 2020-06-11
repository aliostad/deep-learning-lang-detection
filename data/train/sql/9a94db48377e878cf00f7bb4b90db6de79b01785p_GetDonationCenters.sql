CREATE PROCEDURE [dbo].[p_GetDonationCenters]
	@latitude decimal(9,6),
	@longitude decimal(9,6)
AS

DECLARE @MILE_CONVERTER DECIMAL(8, 8) = 0.00062137
DECLARE @orig geography = geography::Point(@latitude, @longitude, 4326);

SELECT * FROM
(
	SELECT 
		dc.CenterId,
		Location,
		[Address],
		City,
		[State],
		Zip,
		NavLink = CONCAT('http://maps.google.com/?saddr=',@latitude,',',@longitude,'&daddr=', latitude, ',' , longitude),
		Miles = @orig.STDistance(LatitudeLongitude) * @MILE_CONVERTER
	FROM
		DonationCenter dc
) t
WHERE
	t.Miles < 50 
ORDER BY 
	Miles