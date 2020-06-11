--USE StorageSpace

--GO 
-----------------------------------------------------------------------------------
IF OBJECT_ID ( '[BasicInfo].[UnitView]', 'view' ) IS NOT NULL 
		DROP VIEW [BasicInfo].[UnitView];
	GO
CREATE VIEW [BasicInfo].[UnitView]
AS
	SELECT u.Id, u.Abbreviation, u.Name
	FROM [Inventory].Units u
	WHERE u.IsCurrency=0 AND u.IsActive=1 
GO	
-----------------------------------------------------------------------------------
IF OBJECT_ID ( '[BasicInfo].[CurrencyView]', 'view' ) IS NOT NULL 
		DROP VIEW [BasicInfo].[CurrencyView];
	GO
CREATE VIEW [BasicInfo].[CurrencyView]
AS
	SELECT u.Id, u.Abbreviation, u.Name
	FROM [Inventory].Units u
	WHERE u.IsCurrency=1 AND u.IsActive=1 
GO	
-----------------------------------------------------------------------------------
IF OBJECT_ID ( '[BasicInfo].[SharedGoodView]', 'view' ) IS NOT NULL 
		DROP VIEW [BasicInfo].[SharedGoodView];
	GO
CREATE VIEW [BasicInfo].[SharedGoodView]
AS
	SELECT g.Id, g.Code, g.Name, g.MainUnitId,u.Abbreviation AS MainUnitCode
	FROM [Inventory].Goods g
	INNER JOIN [Inventory].Units u ON u.Id = g.MainUnitId 
GO	
-----------------------------------------------------------------------------------
IF OBJECT_ID ( '[BasicInfo].[CompanyView]', 'view' ) IS NOT NULL 
		DROP VIEW [BasicInfo].[CompanyView];
	GO
CREATE VIEW [BasicInfo].[CompanyView]
AS
	SELECT c.Id, c.Code, c.Name
	FROM [Inventory].Companies c
GO	
-----------------------------------------------------------------------------------
IF OBJECT_ID ( '[BasicInfo].[CompanyVesselView]', 'view' ) IS NOT NULL 
		DROP VIEW [BasicInfo].[CompanyVesselView];
	GO
CREATE VIEW [BasicInfo].[CompanyVesselView]
AS
	SELECT w.Id, w.Code, w.Name, w.CompanyId, w.IsActive
	FROM [Inventory].Warehouse w
GO	
-----------------------------------------------------------------------------------
IF OBJECT_ID ( '[BasicInfo].[CompanyVesselTankView]', 'view' ) IS NOT NULL 
		DROP VIEW [BasicInfo].[CompanyVesselTankView];
	GO
CREATE VIEW [BasicInfo].[CompanyVesselTankView]
AS
	SELECT (w.Id * 1000 + 1) AS Id,
       w.Id AS VesselInInventoryId,
       '---' AS Name,
       '---' AS Description
	FROM [Inventory].Warehouse w
GO	
-----------------------------------------------------------------------------------
IF OBJECT_ID ( '[BasicInfo].[CompanyGoodView]', 'view' ) IS NOT NULL 
		DROP VIEW [BasicInfo].[CompanyGoodView];
	GO
CREATE VIEW [BasicInfo].[CompanyGoodView]
AS
	SELECT c.Id * 1000 + g.Id AS Id,
	       g.Id AS SharedGoodId,
	       c.Id AS CompanyId,
	       g.Name,
	       g.Code
	FROM [Inventory].Companies c
	CROSS JOIN [Inventory].Goods g
GO	
-----------------------------------------------------------------------------------
IF OBJECT_ID ( '[BasicInfo].[CompanyGoodUnitView]', 'view' ) IS NOT NULL 
		DROP VIEW [BasicInfo].[CompanyGoodUnitView];
	GO
CREATE VIEW [BasicInfo].[CompanyGoodUnitView]
AS
	SELECT cgv.Id * 100 + uv.Id AS Id,
	       cgv.Id AS CompanyGoodId,
	       cgv.SharedGoodId,
	       cgv.CompanyId,
	       uv.Name,
	       uv.Abbreviation,
	       ISNULL(toU.Abbreviation,uv.Abbreviation) AS [To],
	       CAST(ISNULL(uc.Coefficient,1) AS DECIMAL(19,5)) AS Coefficient,
	       CAST(0 AS DECIMAL(19,5)) AS Offset,
		   CAST(NULL AS BIGINT) AS ParentId
	FROM BasicInfo.CompanyGoodView cgv
		CROSS JOIN BasicInfo.UnitView uv
		LEFT JOIN [Inventory].UnitConverts uc ON uv.Id = uc.UnitId 
		LEFT JOIN [Inventory].Units toU ON uc.SubUnitId = toU.Id
GO	


