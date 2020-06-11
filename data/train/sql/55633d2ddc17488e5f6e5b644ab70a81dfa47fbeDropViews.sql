-- --------------------------------------------------
-- drop all Views
-- -------------------------------------------------- 
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[View_Product]'))
	DROP VIEW [dbo].[View_Product]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[View_Banner]'))
	DROP VIEW [dbo].[View_Banner]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[View_Link]'))
	DROP VIEW [dbo].[View_Link]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[View_News]'))
	DROP VIEW [dbo].[View_News]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[View_Member]'))
	DROP VIEW [dbo].[View_Member]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[View_User]'))
	DROP VIEW [dbo].[View_User]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[View_UserPermission]'))
	DROP VIEW [dbo].[View_UserPermission]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[View_Course]'))
	DROP VIEW [dbo].[View_Course]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[View_Content]'))
	DROP VIEW [dbo].[View_Content]
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[View_ProductField]'))
	DROP VIEW [dbo].[View_ProductField]
GO
