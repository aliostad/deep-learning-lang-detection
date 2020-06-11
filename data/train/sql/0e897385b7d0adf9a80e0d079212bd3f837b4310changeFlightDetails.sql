USE AtlasTravel_FINAL;
GO


CREATE PROCEDURE [dbo].[uspChangeFlightDetails]
	@f_ID int,
	@newDep_ID int,
	@newAriv_ID int,
	@newDep_Date date,
	@newAriv_Date date,
	@newF_num varchar(255)

AS

	BEGIN tran t1
		IF @f_ID IS NOT NULL
		BEGIN
			UPDATE FLIGHT 
			SET
				FlightArrivalCityID = ISNULL(NULLIF(@newAriv_ID, ''), FlightArrivalCityID),
				FlightDepartureCityID = ISNULL(NULLIF(@newDep_ID, ''), FlightDepartureCityID),
				FlightDepartureDate = ISNULL(NULLIF(@newDep_Date, ''), FlightDepartureDate),
				FlightArrivalDate = ISNULL(NULLIF(@newAriv_Date, ''), FlightArrivalDate),
				FlightNumber = ISNULL(NULLIF(@newF_num, ''), FlightNumber)
			WHERE FlightID = @f_ID
		END

	COMMIT tran t1
GO


