USE [StorageSpace]
GO
/****** Object:  View [dbo].[SAPIDVoyagesView]    Script Date: 14/5/2014 11:16:34 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SAPIDVoyagesView]'))
DROP VIEW [dbo].[SAPIDVoyagesView]
GO
/****** Object:  View [dbo].[HAFIZVoyagesView]    Script Date: 14/5/2014 11:16:34 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[HAFIZVoyagesView]'))
DROP VIEW [dbo].[HAFIZVoyagesView]
GO
