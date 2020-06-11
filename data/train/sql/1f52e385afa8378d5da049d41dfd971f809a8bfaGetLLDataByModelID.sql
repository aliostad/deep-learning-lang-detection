-- =============================================
-- Author:		Amit Verma
-- Create date: 18-06-2013
-- Description:	To return livelisting data for ModelIDs
-- =============================================
/*
[CD].[GetLLDataByModelID] '253,999,293,250,150,150'
*/
CREATE PROCEDURE [CD].[GetLLDataByModelID]
	@ModelIDs varchar(100)
AS
BEGIN
	SET NOCOUNT ON;
    DECLARE @TempCarModelID TABLE
	(
		ModelID INT,
		MinPrice INT,
		LLCount INT
	)
	
	INSERT INTO @TempCarModelID (ModelID)
	SELECT items FROM dbo.SplitText(@ModelIDs,',')
	
	UPDATE @TempCarModelID
	SET MinPrice = LLData.Price, LLCount = LLData.CNT
	FROM (
		SELECT ModelId
			,MIN(Price) AS Price
			,COUNT(ProfileId) CNT
		FROM LiveListings WITH (NOLOCK)
		GROUP BY ModelId
		) AS LLData
	LEFT JOIN @TempCarModelID T
	ON T.ModelID = LLData.ModelId
	
	SELECT * FROM @TempCarModelID
END

