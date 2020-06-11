USE [LCCHPDev]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_upFamilyWebScreen]
		@Family_ID = 2846,
		@isNewAddress = 1,
		@New_Last_Name = NULL,
		@PropertyID = 11302,
		@New_ConstructionType = 2,
		@New_AreaID = 29,
		@New_isinHistoricDistrict = 1,
		@New_isRemodeled = 1,
		@New_RemodelDate = '2013',
		@New_isinCityLimits = 1,
		@New_Address_Line1 = N'1459 West Glacier Road',
		@New_Address_Line2 = 'Apt B',
		@New_CityName = N'MiniKaga',
		@New_County = N'Miniwaska',
		@New_StateAbbr = N'MN',
		@New_ZipCode = N'54889',
		@New_Year_Built = NULL,
		@New_Owner_id = NULL,
		@New_is_Owner_Occupied = 1,
		@New_ReplacedPipesFaucets = 0,
		@New_TotalRemediationCosts = 5897,
		@New_PropertyNotes = NULL,
		@New_is_Residential = 0,
		@New_isCurrentlyBeingRemodeled = 0,
		@New_has_Peeling_Chipping_Patin = 0,
		@New_is_Rental = 1,
		@New_HomePhone = NULL,
		@New_WorkPhone = NULL,
		@New_Number_of_Smokers = 1,
		@New_Primary_Language_ID = 1,
		@New_Family_Notes = NULL,
		@New_Pets = 1,
		@New_Frequently_Wash_Pets = 1,
		@New_Pets_in_and_out = 1,
		-- @New_Primary_Property_ID = 11375,
		@New_ForeignTravel = 1,
		@DEBUG = 1

SELECT	'Return Value' = @return_value

GO
select * from family order by familyID desc
select * from property where propertyID = 11302