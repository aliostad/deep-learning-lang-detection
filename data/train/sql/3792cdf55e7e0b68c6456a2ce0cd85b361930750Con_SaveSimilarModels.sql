CREATE Procedure [dbo].[Con_SaveSimilarModels]
	@ID					NUMERIC,
	@ModelId			NUMERIC,
	@SimilarModels		VARCHAR(5000),
	@UpdatedOn			DATETIME,
	@Status				BIT OUTPUT

AS
	
BEGIN
	SET @Status = 0
	IF @ID = -1
		BEGIN
			INSERT INTO SimilarCarModels
			(
				ModelId, SimilarModels, UpdatedOn, IsActive
			) 
			VALUES 
			(
				@ModelId, @SimilarModels, @UpdatedOn, 1
			)
		
			SET @Status = 1
		END

	ELSE

		BEGIN
			UPDATE SimilarCarModels
			SET SimilarModels = @SimilarModels, UpdatedOn = @UpdatedOn
			WHERE ID = @ID AND ModelId = @ModelId

			SET @Status = 1 
		END
END



