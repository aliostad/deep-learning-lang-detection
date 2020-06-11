USE [StorageSpace]
GO

IF  EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'BasicInfo', N'VIEW',N'SharedGoodView', NULL,NULL))
EXEC sys.sp_dropextendedproperty @name=N'MS_DiagramPaneCount' , @level0type=N'SCHEMA',@level0name=N'BasicInfo', @level1type=N'VIEW',@level1name=N'SharedGoodView'

GO
IF  EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'BasicInfo', N'VIEW',N'SharedGoodView', NULL,NULL))
EXEC sys.sp_dropextendedproperty @name=N'MS_DiagramPane1' , @level0type=N'SCHEMA',@level0name=N'BasicInfo', @level1type=N'VIEW',@level1name=N'SharedGoodView'

GO
/****** Object:  View [BasicInfo].[VesselView]    Script Date: 7/4/2014 11:39:25 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BasicInfo].[VesselView]'))
DROP VIEW [BasicInfo].[VesselView]
GO
--/****** Object:  View [BasicInfo].[UserView]    Script Date: 7/4/2014 11:39:25 AM ******/
--IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BasicInfo].[UserView]'))
--DROP VIEW [BasicInfo].[UserView]
--GO
/****** Object:  View [BasicInfo].[UnitView]    Script Date: 7/4/2014 11:39:25 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BasicInfo].[UnitView]'))
DROP VIEW [BasicInfo].[UnitView]
GO
/****** Object:  View [BasicInfo].[TankView]    Script Date: 7/4/2014 11:39:25 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BasicInfo].[TankView]'))
DROP VIEW [BasicInfo].[TankView]
GO
/****** Object:  View [BasicInfo].[SharedGoodView]    Script Date: 7/4/2014 11:39:25 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BasicInfo].[SharedGoodView]'))
DROP VIEW [BasicInfo].[SharedGoodView]
GO
/****** Object:  View [BasicInfo].[GoodView]    Script Date: 7/4/2014 11:39:25 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BasicInfo].[GoodView]'))
DROP VIEW [BasicInfo].[GoodView]
GO
/****** Object:  View [BasicInfo].[GoodPartyAssignmentView]    Script Date: 7/4/2014 11:39:25 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BasicInfo].[GoodPartyAssignmentView]'))
DROP VIEW [BasicInfo].[GoodPartyAssignmentView]
GO
/****** Object:  View [BasicInfo].[CurrencyView]    Script Date: 7/4/2014 11:39:25 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BasicInfo].[CurrencyView]'))
DROP VIEW [BasicInfo].[CurrencyView]
GO
/****** Object:  View [BasicInfo].[CompanyView]    Script Date: 7/4/2014 11:39:25 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BasicInfo].[CompanyView]'))
DROP VIEW [BasicInfo].[CompanyView]
GO
/****** Object:  View [BasicInfo].[CompanyGoodUnitView]    Script Date: 7/4/2014 11:39:25 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BasicInfo].[CompanyGoodUnitView]'))
DROP VIEW [BasicInfo].[CompanyGoodUnitView]
GO
/****** Object:  View [BasicInfo].[ActivityLocationView]    Script Date: 7/4/2014 11:39:25 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BasicInfo].[ActivityLocationView]'))
DROP VIEW [BasicInfo].[ActivityLocationView]
GO
/****** Object:  View [BasicInfo].[VoyagesView]    Script Date: 7/4/2014 11:39:25 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BasicInfo].[VoyagesView]'))
DROP VIEW [BasicInfo].[VoyagesView]
GO
