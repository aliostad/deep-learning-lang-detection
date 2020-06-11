-- =============================================
-- Author:		Chetan Kane
-- Create date: 05/03/2012
-- Description:	SP to get the name of Make name, Model Name, Version name of the car for price quote
-- =============================================
CREATE PROCEDURE [dbo].[Microsite_GetCarDetails]
	@VersonId INT,
	@MakeName VARCHAR(50) OUT,
	@ModelName VARCHAR(50) OUT,
	@VersionName VARCHAR(50) OUT,
	@MakeId INT OUT,
	@ModelId INT OUT	
AS
BEGIN
	SELECT @MakeName = Make, @ModelName = Model, @VersionName = [Version], @MakeId = MakeId, @ModelId = ModelId FROM vwMMV WHERE VersionId = @VersonId
END

