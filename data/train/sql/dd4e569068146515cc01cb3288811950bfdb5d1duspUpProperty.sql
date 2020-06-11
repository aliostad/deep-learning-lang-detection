USE [LCCHPDev]
GO

DECLARE	@return_value int

select * from property where PropertyID = 11366

EXEC	@return_value = [dbo].[usp_upProperty]
		@PropertyID = 11366,
		@New_ConstructionTypeID = 3,
		@New_AreaID = 28,
		@New_isinHistoricDistrict = 0,
		@New_isRemodeled = 1,
		@New_RemodelDate = '20120524',
		@New_isinCityLimits = 1,
		@New_AddressLine1 = N'26 E. 8th St',
		@New_AddressLine2 = N'Apt 2',
		@New_City = N'Leadville',
		@New_State = N'CO',
		@New_Zipcode = N'80461',
		@New_YearBuilt = '1915',
		@New_Ownerid = NULL,
		@New_isOwnerOccuppied = 0,
		@New_ReplacedPipesFaucets = 1,
		@New_TotalRemediationCosts = 15871,
		@New_PropertyNotes = N'removed popcorn ceilings',
		@New_isResidential = 0,
		@New_isCurrentlyBeingRemodeled = 0,
		@New_hasPeelingChippingPaint = 0,
		@New_County = N'Lake',
		@New_isRental = 1,
		@DEBUG = 1

SELECT	'Return Value' = @return_value

GO
select * from property where PropertyID = 11366

/*
DECLARE @isinHIstoricDistrict bit, @ConstructionTypeID tinyint, @AreaID int, @isRemodeled bit, @RemodelDate date, @isinCityLimits bit
	, @AddressLine1 varchar(100), @AddressLine2 varchar(100), @City varchar(50), @State char(2), @ZipCode varchar(12), @YearBuilt date
	, @OwnerID int, @isOwnerOccuppied bit, @ReplacedPipesFaucets tinyint, @TotalRemediationCosts money, @PropertyNotes varchar(3000)
	, @isResidential bit, @isCurrentlyBeingRemodeled bit, @hasPeelingChippingPaint bit, @County varchar(50), @isRental bit, @PropertyID int


update Property set isinHistoricDistrict = @isinHistoricDistrict, ConstructionTypeID = @ConstructionTypeID, AreaID = @AreaID, isRemodeled = @isRemodeled
, isinCityLimits = @isinCityLimits, AddressLine1 = @AddressLine1, AddressLine2 = @AddressLine2, City = @City, State = @State, ZipCode = @ZipCode
, isOwnerOccuppied = @isOwnerOccuppied, ReplacedPipesFaucets = @ReplacedPipesFaucets, TotalRemediationCosts = @TotalRemediationCosts
, isResidential = @isResidential, isCurrentlyBeingRemodeled = @isCurrentlyBeingRemodeled, hasPeelingChippingPaint = @hasPeelingChippingPaint
, County = @County, isRental = @isRental, YearBuilt = @YearBuilt WHERE PropertyID = @PropertyID
*/