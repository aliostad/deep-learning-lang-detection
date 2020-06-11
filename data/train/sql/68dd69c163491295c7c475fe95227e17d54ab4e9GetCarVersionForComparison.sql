-- =============================================      
-- Author:  <Vikas J>
-- Create date: <27/01/2013>      
-- Description: <Returns the data of all the version available for the provided modelId. It will have discontinued cars data along with new cars if user chooses for all cars      
-- =============================================      
CREATE PROCEDURE [dbo].[GetCarVersionForComparison] @ModelId1 INT = 0
	,--Model Id of first car selected by user
	@ModelId2 INT = 0
	,--Model Id of second car selected by user
	@ModelId3 INT = 0
	,--Model Id of third car selected by user
	@ModelId4 INT = 0
	,--Model Id of fourth car selected by user
	@OnlyNew INT --Whether only new cars required or discontinued car needed as well
AS
BEGIN
	--Returns the data containing all the version available for models provided as parameter. If any modelId is not provided the default value 0 will be
	--considered and no rows for that will be present in the returning dataset
	IF @OnlyNew = 1
		SELECT Vs.ID AS Value
			,Vs.NAME AS [Text]
			,Vs.CarModelId
		FROM CarVersions Vs WITH (NOLOCK)
		WHERE VS.CarModelId IN (
				@ModelId1
				,@ModelId2
				,@ModelId3
				,@ModelId4
				)
			AND Vs.New = 1
			AND Vs.IsDeleted = 0
			AND Vs.Futuristic = 0
			AND IsSpecsAvailable = 1
		ORDER BY [Text];
	ELSE
		--Returns data even for discontinued versions
		SELECT Vs.ID AS Value
			,(
				Vs.NAME + ' ' + (
					CASE 
						WHEN (
								SELECT CV.NAME
								FROM CarVersions CV
								WHERE CV.Id = Vs.Id
									AND CV.New = 1
								) IS NULL
							THEN '*'
						ELSE ''
						END
					)
				) AS [Text]
			,Vs.CarModelId
		FROM CarVersions Vs WITH (NOLOCK)
		WHERE Vs.CarModelId IN (
				@ModelId1
				,@ModelId2
				,@ModelId3
				,@ModelId4
				)
			AND Vs.IsDeleted = 0
			AND Vs.Futuristic = 0
			AND IsSpecsAvailable = 1
		ORDER BY Vs.New DESC
			,[Text];
END

