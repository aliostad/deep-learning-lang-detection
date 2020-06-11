USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_upFamily]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20150214
-- Description:	Stored Procedure to update Family information
-- =============================================

CREATE PROCEDURE [dbo].[usp_upFamily]  
	-- Add the parameters for the stored procedure here
	@Family_ID int = NULL,
	@New_Last_Name varchar(50) = NULL,
	@New_Number_of_Smokers tinyint = 0,
	@New_Primary_Language_ID tinyint = 1,
	@New_Notes varchar(3000) = NULL,
	@New_Pets tinyint = NULL,
	@New_Frequently_Wash_Pets bit = NULL,
	@New_Pets_in_and_out bit = NULL,
	@New_Primary_Property_ID int = NULL,
	@New_ForeignTravel bit = NULL,
	@DEBUG BIT = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @ErrorLogID int, @spupdateFamilysqlStr nvarchar(4000)
			, @NotesID INT, @Recompile BIT = 1;
	
	BEGIN TRY -- update Family information
		-- BUILD update statement
		IF (@New_Last_Name IS NULL)
			SELECT @New_Last_Name = LastName from family where FamilyID = @Family_ID;
	
		SELECT @spupdateFamilysqlStr = N'update Family set Lastname = @LastName'

		IF (@New_Number_of_Smokers IS NOT NULL)
			SELECT @spupdateFamilysqlStr = @spupdateFamilysqlStr + N', NumberofSmokers = @NumberofSmokers'

		IF (@New_Primary_Language_ID IS NOT NULL)
			SELECT @spupdateFamilysqlStr = @spupdateFamilysqlStr + N', PrimaryLanguageID = @PrimaryLanguageID'

		IF (@New_Pets IS NOT NULL)
			SELECT @spupdateFamilysqlStr = @spupdateFamilysqlStr + N', Pets = @Pets'

		IF (@New_Frequently_Wash_Pets IS NOT NULL)
			SELECT @spupdateFamilysqlStr = @spupdateFamilysqlStr + N', FrequentlyWashPets = @FrequentlyWashPets'	
			
		IF (@New_Pets_in_and_out IS NOT NULL)
			SELECT @spupdateFamilysqlStr = @spupdateFamilysqlStr + N', Petsinandout = @Petsinandout'

		IF (@New_Primary_Property_ID IS NOT NULL)
			SELECT @spupdateFamilysqlStr = @spupdateFamilysqlStr + N', PrimaryPropertyID = @PrimaryPropertyID'

		IF (@New_ForeignTravel IS NOT NULL)
			SELECT @spupdateFamilysqlStr = @spupdateFamilysqlStr + N', ForeignTravel = @ForeignTravel'


		SELECT @spupdateFamilysqlStr = @spupdateFamilysqlStr + N' WHERE FamilyID = @FamilyID'

		IF @DEBUG = 1
			SELECT @spupdateFamilysqlStr, 'Lastname' = @New_Last_Name, 'NumberofSmokers' = @New_Number_of_Smokers
				, 'PrimaryLanguageID' = @New_Primary_Language_ID, 'Pets' = @New_Pets, 'Petsinandout' = @New_Pets_in_and_out
				, 'PrimaryPropertyID' = @New_Primary_Property_ID, 'FrequentlyWashPets' = @New_Frequently_Wash_Pets
				, 'ForeignTravel' = @New_ForeignTravel
			
			IF (@New_Notes IS NOT NULL)
			BEGIN
				IF @DEBUG = 1
					SELECT 'EXEC [dbo].[usp_InsertFamilyNotes] @Family_ID = @Family_ID, @Notes = @New_Notes, @InsertedNotesID = @NotesID OUTPUT ' 
						, @Family_ID, @New_Notes 

				EXEC	[dbo].[usp_InsertFamilyNotes]
							@Family_ID = @Family_ID,
							@Notes = @New_Notes,
							@InsertedNotesID = @NotesID OUTPUT
			END
	
			-- update Family table
			EXEC [sp_executesql] @spupdateFamilysqlStr
				, N'@LastName VARCHAR(50), @NumberofSmokers tinyint, @PrimaryLanguageID tinyint
				, @Pets tinyint, @Petsinandout BIT, @PrimaryPropertyID int, @FrequentlyWashPets bit, @ForeignTravel bit, @FamilyID int'
				, @LastName = @New_Last_Name
				, @NumberofSmokers = @New_Number_of_Smokers
				, @PrimaryLanguageID = @New_Primary_Language_ID
				, @Pets = @New_Pets
				, @Petsinandout = @New_Pets_in_and_out
				, @PrimaryPropertyID = @New_Primary_Property_ID
				, @FrequentlyWashPets = @New_Frequently_Wash_Pets
				, @ForeignTravel = @New_ForeignTravel
				, @FamilyID = @Family_ID
	END TRY -- update Family
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END
GO
