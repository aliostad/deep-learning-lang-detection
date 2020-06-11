USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_upQuestionnaire]    Script Date: 6/18/2015 5:16:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20130618
-- Description:	Stored Procedure to update 
--              questionnaire records
-- =============================================
-- DROP PROCEDURE usp_upQuestionnaire
CREATE PROCEDURE [dbo].[usp_upQuestionnaire]  
	-- Add the parameters for the stored procedure here
	@QuestionnaireID int = NULL,
	@New_QuestionnaireDate date = NULL,
	@New_QuestionnaireDataSourceID int = NULL,
	@New_VisitRemodeledProperty bit = NULL,
	@New_PaintDate date = NULL,
	@New_RemodelPropertyDate date = NULL,
	@New_isExposedtoPeelingPaint bit = NULL,
	@New_isTakingVitamins bit = NULL,
	@New_NursingMother bit = NULL,
	@New_NursingInfant bit = NULL,
	@New_Pregnant bit = NULL,
	@New_isUsingPacifier bit = NULL,
	@New_isUsingBottle bit = NULL,
	@New_BitesNails bit = NULL,
	@New_NonFoodEating bit = NULL,
	@New_NonFoodinMouth bit = Null,
	@New_EatOutside bit = NULL,
	@New_Suckling bit = NULL,
	@New_Mouthing bit = NULL,
	@New_FrequentHandWashing bit = NULL,
	@New_VisitsOldHomes bit = NULL,
	@New_DaycareID int = NULL,
	@New_Notes varchar(3000) = NULL,
	@DEBUG BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @NotesID int, @spupdateQuestionnairesqlStr NVARCHAR(4000);

    -- insert statements for procedure here
	BEGIN TRY
		-- Check if QuestionnaireID is valid, if not return
		IF NOT EXISTS (SELECT QuestionnaireID from Questionnaire where QuestionnaireID = @QuestionnaireID)
		BEGIN
			RAISERROR('QuestionnaireID must be specified and valid', 11,-1,'usp_upQuestionnaire');
		END
		
		-- BUILD update statement
		if (@New_QuestionnaireDate is null)
			select @New_QuestionnaireDate = QuestionnaireDate from Questionnaire where QuestionnaireID = @QuestionnaireID
		
		SELECT @spupdateQuestionnairesqlStr = N'update Questionnaire set QuestionnaireDate = @QuestionnaireDate'

		IF (@New_QuestionnaireDataSourceID IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', QuestionnaireDataSourceID = @QuestionnaireDataSourceID'

		IF (@New_VisitRemodeledProperty IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', VisitRemodeledProperty = @VisitRemodeledProperty'

		IF (@New_PaintDate IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', PaintDate = @PaintDate'

		IF (@New_RemodelPropertyDate IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', RemodelPropertyDate = @RemodelPropertyDate'

		IF (@New_isExposedtoPeelingPaint IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', isExposedtoPeelingPaint = @isExposedtoPeelingPaint'

		IF (@New_isTakingVitamins IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', isTakingVitamins = @isTakingVitamins'

		IF (@New_NursingMother IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', NursingMother = @NursingMother'

		IF (@New_NursingInfant IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', NursingInfant = @NursingInfant'

		IF (@New_Pregnant IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', Pregnant = @Pregnant'

		IF (@New_isUsingPacifier IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', isUsingPacifier = @isUsingPacifier'

		IF (@New_isUsingBottle IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', isUsingBottle = @isUsingBottle'

		IF (@New_BitesNails IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', BitesNails = @BitesNails'

		IF (@New_NonFoodEating IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', NonFoodEating = @NonFoodEating'

		IF (@New_NonFoodinMouth IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', NonFoodinMouth = @NonFoodinMouth'

		IF (@New_EatOutside IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', EatOutside = @EatOutside'

		IF (@New_Suckling IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', Suckling = @Suckling'

		IF (@New_Mouthing IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', Mouthing = @Mouthing'
		
		IF (@New_FrequentHandWashing IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', FrequentHandWashing = @FrequentHandWashing'

		IF (@New_VisitsOldHomes IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', VisitsOldHomes = @VisitsOldHomes'

		IF (@New_DaycareID IS NOT NULL)
			SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N', DayCareID = @DaycareID'

		-- make sure to only update record for specified Questionnaire
		SELECT @spupdateQuestionnairesqlStr = @spupdateQuestionnairesqlStr + N' WHERE QuestionnaireID = @QuestionnaireID'

		IF (@DEBUG = 1)
			SELECT @spupdateQuestionnairesqlStr, QuestionnaireDate = @New_QuestionnaireDate, QuestionnaireDataSourceID = @New_QuestionnaireDataSourceID
					, VisitRemodeledProperty = @New_VisitRemodeledProperty, PaintDate = @New_PaintDate, RemodelPropertyDate = @New_RemodelPropertyDate
					, isExposedtoPeelingPaint = @New_isExposedtoPeelingPaint, isTakingVitamins = @New_isTakingVitamins, NursingMother = @New_NursingMother
					, NursingInfant = @New_NursingInfant, Pregnant = @New_Pregnant, isUsingPacifier = @New_isUsingPacifier, isUsingBottle = @New_isUsingBottle
					, Bitesnails = @New_BitesNails, NonFoodEating = @New_NonFoodEating, NonFoodinMouth = @New_NonFoodinMouth, EatOutside = @New_EatOutside
					, Suckling = @New_Suckling, Mouthing = @New_Mouthing, FrequentHandWashing = @New_FrequentHandWashing, VisitsOldHomes = @New_VisitsOldHomes
					, DaycareID = @New_DaycareID, QuestionnaireID = @QuestionnaireID, DEBUG = @DEBUG

		EXEC [sp_executesql] @spupdateQuestionnairesqlStr
				, N'@QuestionnaireDate date, @QuestionnaireDataSourceID int, @VisitRemodeledProperty bit, @PaintDate date, @RemodelPropertyDate date
				, @isExposedtoPeelingPaint bit, @isTakingVitamins bit, @NursingMother bit, @NursingInfant bit, @Pregnant bit, @isUsingPacifier bit
				, @isUsingBottle bit, @BitesNails bit, @NonFoodEating bit, @NonFoodinMouth bit, @Eatoutside bit, @Suckling bit, @Mouthing bit
				, @FrequentHandWashing bit , @VisitsOldHomes bit, @DaycareID int, @QuestionnaireID int'
				, @QuestionnaireDate = @New_QuestionnaireDate
				, @QuestionnairedataSourceID = @New_QuestionnaireDataSourceID
				, @VisitRemodeledProperty = @New_VisitRemodeledProperty
				, @PaintDate = @New_PaintDate
				, @RemodelPropertyDate = @New_RemodelPropertyDate
				, @isExposedtoPeelingPaint = @New_isExposedtoPeelingPaint
				, @isTakingVitamins = @New_isTakingVitamins
				, @NursingMother = @New_NursingMother
				, @NursingInfant = @New_NursingInfant
				, @Pregnant = @New_Pregnant
				, @isUsingPacifier = @New_isUsingPacifier
				, @isUsingBottle = @New_isUsingBottle
				, @BitesNails = @New_BitesNails
				, @NonFoodEating = @New_NonFoodEating
				, @NonFoodinMouth = @New_NonFoodinMouth
				, @EatOutside = @New_EatOutside
				, @Suckling = @New_Suckling
				, @Mouthing = @New_Mouthing
				, @FrequentHandWashing = @New_FrequentHandWashing
				, @VisitsOldHomes = @New_VisitsOldHomes
				, @DaycareID = @New_DaycareID
				, @QuestionnaireID = @QuestionnaireID

			IF (@New_Notes IS NOT NULL)
			EXEC	[dbo].[usp_InsertQuestionnaireNotes]
								@Questionnaire_ID = @QuestionnaireID,
								@Notes = @New_Notes,
								@InsertedNotesID = @NotesID OUTPUT
	END TRY
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
		THROW
	END CATCH;
END


GO
