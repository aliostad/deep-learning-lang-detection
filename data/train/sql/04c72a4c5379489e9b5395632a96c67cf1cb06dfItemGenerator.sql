SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[AppendVersionedFields]    Script Date: 05/14/2013 10:15:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AppendVersionedFields]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AppendVersionedFields]
GO

/****** Object:  StoredProcedure [dbo].[AppendItems]    Script Date: 05/14/2013 10:15:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AppendItems]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AppendItems]
GO

/****** Object:  UserDefinedTableType [dbo].[ItemsTableType]    Script Date: 05/14/2013 10:14:22 ******/
IF  EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'ItemsTableType' AND ss.name = N'dbo')
DROP TYPE [dbo].[ItemsTableType]
GO

/****** Object:  UserDefinedTableType [dbo].[VersionedFieldsTableType]    Script Date: 05/14/2013 10:14:45 ******/
IF  EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'VersionedFieldsTableType' AND ss.name = N'dbo')
DROP TYPE [dbo].[VersionedFieldsTableType]
GO

/****** Object:  UserDefinedTableType [dbo].[ItemsTableType]    Script Date: 05/14/2013 10:14:22 ******/
CREATE TYPE [dbo].[ItemsTableType] AS TABLE(
	[ID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
	[TemplateID] [uniqueidentifier] NOT NULL,
	[MasterID] [uniqueidentifier] NOT NULL,
	[ParentID] [uniqueidentifier] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[VersionedFieldsTableType]    Script Date: 05/14/2013 10:14:45 ******/
CREATE TYPE [dbo].[VersionedFieldsTableType] AS TABLE(
	[Id] [uniqueidentifier] NOT NULL,
	[ItemId] [uniqueidentifier] NOT NULL,
	[Language] [nvarchar](50) NOT NULL,
	[Version] [int] NOT NULL,
	[FieldId] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL
)
GO

/****** Object:  StoredProcedure [dbo].[AppendItems]    Script Date: 05/14/2013 10:15:06 ******/
CREATE PROCEDURE [dbo].[AppendVersionedFields](
  @versionedFields dbo.VersionedFieldsTableType READONLY
)
AS BEGIN
  INSERT INTO [VersionedFields] (
    [Id], [ItemId], [Language], [Version], [FieldId], [Value], [Created], [Updated]
  )
  SELECT [Id], [ItemId], [Language], [Version], [FieldId], [Value], [Created], [Updated]
  FROM @versionedFields
END

Go

/****** Object:  StoredProcedure [dbo].[AppendItems]    Script Date: 05/14/2013 10:15:06 ******/
CREATE PROCEDURE [dbo].[AppendItems](
  @items dbo.ItemsTableType READONLY
)
AS BEGIN
  INSERT INTO [Items] (
    [ID], [Name], [TemplateID], [MasterID], [ParentID], [Created], [Updated]
  )
  SELECT [ID], [Name], [TemplateID], [MasterID], [ParentID], [Created], [Updated]
  FROM @items
END

GO



