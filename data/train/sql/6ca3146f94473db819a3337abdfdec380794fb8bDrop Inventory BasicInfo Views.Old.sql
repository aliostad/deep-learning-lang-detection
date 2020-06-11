--USE [StorageSpace]
--GO
/****** Object:  View [BasicInfo].[InventoryUnitView]    Script Date: 14/5/2014 11:00:55 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BasicInfo].[InventoryUnitView]'))
DROP VIEW [BasicInfo].[InventoryUnitView]
GO
/****** Object:  View [BasicInfo].[InventorySharedGoodView]    Script Date: 14/5/2014 11:00:55 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BasicInfo].[InventorySharedGoodView]'))
DROP VIEW [BasicInfo].[InventorySharedGoodView]
GO
/****** Object:  View [BasicInfo].[InventoryCurrencyView]    Script Date: 14/5/2014 11:00:55 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BasicInfo].[InventoryCurrencyView]'))
DROP VIEW [BasicInfo].[InventoryCurrencyView]
GO
/****** Object:  View [BasicInfo].[InventoryCompanyView]    Script Date: 14/5/2014 11:00:55 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BasicInfo].[InventoryCompanyView]'))
DROP VIEW [BasicInfo].[InventoryCompanyView]
GO
/****** Object:  View [BasicInfo].[InventoryCompanyVesselView]    Script Date: 14/5/2014 11:00:55 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BasicInfo].[InventoryCompanyVesselView]'))
DROP VIEW [BasicInfo].[InventoryCompanyVesselView]
GO
/****** Object:  View [BasicInfo].[InventoryCompanyVesselTankView]    Script Date: 14/5/2014 11:00:55 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BasicInfo].[InventoryCompanyVesselTankView]'))
DROP VIEW [BasicInfo].[InventoryCompanyVesselTankView]
GO
/****** Object:  View [BasicInfo].[InventoryCompanyGoodView]    Script Date: 14/5/2014 11:00:55 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BasicInfo].[InventoryCompanyGoodView]'))
DROP VIEW [BasicInfo].[InventoryCompanyGoodView]
GO
/****** Object:  View [BasicInfo].[InventoryCompanyGoodUnitView]    Script Date: 14/5/2014 11:00:55 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BasicInfo].[InventoryCompanyGoodUnitView]'))
DROP VIEW [BasicInfo].[InventoryCompanyGoodUnitView]
GO
/****** Object:  View [BasicInfo].[InventoryCompanyVesselGoodUnitView]    Script Date: 14/5/2014 11:00:55 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BasicInfo].[InventoryCompanyVesselGoodUnitView]'))
DROP VIEW [BasicInfo].[InventoryCompanyVesselGoodUnitView]
GO
/****** Object:  View [BasicInfo].[InventoryCompanyVesselGoodView]    Script Date: 14/5/2014 11:00:55 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BasicInfo].[InventoryCompanyVesselGoodView]'))
DROP VIEW [BasicInfo].[InventoryCompanyVesselGoodView]
GO
