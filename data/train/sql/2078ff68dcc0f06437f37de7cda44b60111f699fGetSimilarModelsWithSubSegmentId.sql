-- =============================================
-- Author:		Anchal Gupta
-- Create date: 2/12/2015
-- Description:	Getting the similar models based subsegment Id only order by popularity
-- =============================================
CREATE PROCEDURE [dbo].[GetSimilarModelsWithSubSegmentId] 
	-- Add the parameters for the stored procedure here
	 @ModelId INT
	,@SubsegmentId INT
AS
BEGIN
	SELECT Id AS ModelId, ModelBodyStyle, ModelPopularity
	FROM Carmodels WITH (NOLOCK)
	WHERE SubSegmentId = @SubsegmentId
		AND New = 1
		And IsDeleted = 0
		AND Id <> @ModelId
		
END
