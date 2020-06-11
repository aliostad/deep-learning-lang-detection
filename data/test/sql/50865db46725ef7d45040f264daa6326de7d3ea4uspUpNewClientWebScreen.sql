USE [LCCHPDev]
GO

DECLARE	@return_value int, @PersonID int;

SET @PErsonID = 2874;

Select * from persontolanguage  where personID = @PErsonID
select * from persontoEthnicity where personID = @PErsonID
select * from persontoFamily where PersonID = @PErsonID
select * from PersontoHobby where PersonID = @PersonID
select * from PersontoOccupation where PersonID = @PersonID

EXEC	@return_value = [dbo].[usp_upNewClientWebScreen]
		@Family_ID = 1268,
		@Person_ID = @PErsonID,
		@New_FirstName = NULL,
		@New_MiddleName = NULL,
		@New_LastName = NULL,
		@New_BirthDate = NULL,
		@New_Gender = NULL,
		@New_StatusID = NULL,
		@New_ForeignTravel = NULL,
		@New_OutofSite = NULL,
		@New_EatsForeignFood = NULL,
		@New_PatientID = NULL,
		@New_RetestDate = NULL,
		@New_Moved = NULL,
		@New_MovedDate = NULL,
		@New_isClosed = NULL,
		@New_isResolved = NULL,
		@New_GuardianID = NULL,
		@New_PersonCode = NULL,
		@New_isSmoker = NULL,
		@New_isClient = NULL,
		@New_isNursing = NULL,
		@New_isPregnant = NULL,
		@New_EthnicityID = 3,
		@New_LanguageID = 5,
		@New_HobbyID = 12,
		@New_OccupationID = 4,
		@New_Occupation_StartDate = '20030228',
		@New_Occupation_EndDate = '20120108',
		@DEBUG = 1

SELECT	'Return Value' = @return_value


Select * from persontolanguage  where personID = @PErsonID
select * from persontoEthnicity where personID = @PErsonID
select * from persontoFamily where PersonID = @PErsonID
select * from PersontoHobby where PersonID = @PersonID
select * from PersontoOccupation where PersonID = @PersonID