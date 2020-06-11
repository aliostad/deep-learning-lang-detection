USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_upBloodTestResultsWebScreen]    Script Date: 6/18/2015 5:16:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150618
-- Description:	stored procedure to update blood test results
--              data 
-- =============================================
CREATE PROCEDURE [dbo].[usp_upBloodTestResultsWebScreen]
	-- Add the parameters for the stored procedure here
	@BloodTestResultsID int = NULL,
	@New_Sample_Date date = NULL,
	@New_Lab_Date date = NULL,
	@New_Blood_Lead_Result numeric(4,1) = NULL,
	@New_Sample_Type_ID tinyint = NULL,
	@New_Lab_ID int = NULL,
	@New_Flag smallint = NULL,
	@New_Client_Status_ID smallint = NULL,
	@New_Hemoglobin_Value numeric(4,1) = NULL,
	@New_Blood_Test_Costs money = NULL,
	@New_Taken_After_Property_Remediation_Completed bit = NULL,
	@New_Exclude_Result bit = NULL,
	@New_Notes varchar(3000) = NULL,
	@DEBUG BIT = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN
		DECLARE @ErrorLogID int, @RetestDate_return_value int,
				@updateBloodTestResultsReturnValue int;
	
		-- If no family ID was passed in exit
		IF (@BloodTestResultsID IS NULL)
		BEGIN
			RAISERROR ('Blood test results ID must be supplied', 11, -1);
			RETURN;
		END;

		BEGIN TRY  
			-- update person flag/retest date
			IF (@New_Flag IS NOT NULL)
			BEGIN
				declare @Retest_Date date, @Sample_Date date, @Person_ID int;

				-- determine personID
				select @Person_ID = PersonID, @Sample_Date = SampleDate from BloodTestResults where BloodTestResultsID = @BloodTestResultsID
				
				-- set the retest date based on integer value passed in as Flag
				SET @Retest_Date = DATEADD(dd,@New_Flag,@Sample_Date);

				-- update Person table with the new retest date
				-- anyone with a blood test is a client
				EXEC	@RetestDate_return_value = [dbo].[usp_upPerson]
						@Person_ID = @Person_ID
						, @New_RetestDate = @Retest_Date
						, @New_ClientStatusID = @New_Client_Status_ID;
			END

			-- update bloodtestResults
			EXEC	@updateBloodTestResultsReturnValue = [dbo].[usp_upBloodTestResults]
														@BloodTestResultsID = @BloodTestResultsID,
														@New_Sample_Date = @New_Sample_Date,
														@New_Lab_Date = @New_Lab_Date,
														@New_Blood_Lead_Result = @New_Blood_Lead_Result,
														@New_Hemoglobin_Value = @New_Hemoglobin_Value,
														@New_Lab_ID = @New_Lab_ID,
														@New_Blood_Test_Costs = @New_Blood_Test_Costs,
														@New_Sample_Type_ID = @New_Sample_Type_ID,
														@New_Taken_After_Property_Remediation_Completed = @New_Taken_After_Property_Remediation_Completed,
														@New_Exclude_Result = @New_Exclude_Result,
														@New_Client_Status_ID = @New_Client_Status_ID,
														@New_Notes = @New_Notes,
														@DEBUG = @DEBUG

		END TRY
		BEGIN CATCH -- insert person
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
		END CATCH; -- insert new person
	END
END



GO
