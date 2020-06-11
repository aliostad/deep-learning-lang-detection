--USE [StorageSpace]
--GO
IF OBJECT_ID ( '[BasicInfo].[UnitView]', 'view' ) IS NOT NULL 
		DROP VIEW [BasicInfo].[UnitView];
	GO
-----------------------------------------------------------------------------------
IF OBJECT_ID ( '[BasicInfo].[CurrencyView]', 'view' ) IS NOT NULL 
		DROP VIEW [BasicInfo].[CurrencyView];
	GO
-----------------------------------------------------------------------------------
IF OBJECT_ID ( '[BasicInfo].[SharedGoodView]', 'view' ) IS NOT NULL 
		DROP VIEW [BasicInfo].[SharedGoodView];
	GO
-----------------------------------------------------------------------------------
IF OBJECT_ID ( '[BasicInfo].[CompanyView]', 'view' ) IS NOT NULL 
		DROP VIEW [BasicInfo].[CompanyView];
	GO
-----------------------------------------------------------------------------------
IF OBJECT_ID ( '[BasicInfo].[CompanyVesselView]', 'view' ) IS NOT NULL 
		DROP VIEW [BasicInfo].[CompanyVesselView];
	GO
-----------------------------------------------------------------------------------
IF OBJECT_ID ( '[BasicInfo].[CompanyVesselTankView]', 'view' ) IS NOT NULL 
		DROP VIEW [BasicInfo].[CompanyVesselTankView];
	GO
-----------------------------------------------------------------------------------
IF OBJECT_ID ( '[BasicInfo].[CompanyGoodView]', 'view' ) IS NOT NULL 
		DROP VIEW [BasicInfo].[CompanyGoodView];
	GO
-----------------------------------------------------------------------------------
IF OBJECT_ID ( '[BasicInfo].[CompanyGoodUnitView]', 'view' ) IS NOT NULL 
		DROP VIEW [BasicInfo].[CompanyGoodUnitView];
	GO

