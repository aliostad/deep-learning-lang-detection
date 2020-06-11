USE [master]
GO

/****** Object:  Database [LoveboatViewModelCache]    Script Date: 06/17/2012 21:23:39 ******/
IF  EXISTS (SELECT name FROM sys.databases WHERE name = N'LoveboatViewModelCache')
DROP DATABASE [LoveboatViewModelCache]
GO

USE [master]
GO

/****** Object:  Database [LoveboatViewModelCache]    Script Date: 06/17/2012 21:23:39 ******/
CREATE DATABASE [LoveboatViewModelCache] 

USE [LoveboatViewModelCache]
GO

/****** Object:  Table [dbo].[ShipViewModel]    Script Date: 06/17/2012 21:26:07 ******/

CREATE TABLE [dbo].[ShipViewModel](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Location] [varchar](50) NOT NULL
) ON [PRIMARY]

GO

INSERT INTO [LoveboatViewModelCache].[dbo].[ShipViewModel]([Id],[Name],[Location]) VALUES ('AE880C6A-5567-4568-B5EE-0397B914873C','Santa Mario','Melbourne') 
GO
INSERT INTO [LoveboatViewModelCache].[dbo].[ShipViewModel]([Id],[Name],[Location]) VALUES ('CA1416EC-A1AF-4291-8241-D83712D63AC9','Queen Elizabeth II','At Sea') 
GO
INSERT INTO [LoveboatViewModelCache].[dbo].[ShipViewModel]([Id],[Name],[Location]) VALUES ('0F59214B-4C28-4ED0-8020-5B9C77B6190B','Constitution','At Sea') 
GO
INSERT INTO [LoveboatViewModelCache].[dbo].[ShipViewModel]([Id],[Name],[Location]) VALUES ('BD285736-70EF-4FA9-A368-AF9731203519','Titanic','Bristol') 
GO
INSERT INTO [LoveboatViewModelCache].[dbo].[ShipViewModel]([Id],[Name],[Location]) VALUES ('4BB7ECD8-1FCD-4D59-9700-CC923C3C633A','Hunley','At Sea')
 GO
INSERT INTO [LoveboatViewModelCache].[dbo].[ShipViewModel]([Id],[Name],[Location]) VALUES ('E329ECC8-8629-4760-8CAE-444797B02E5E','Monitor','Tokyo') 
GO
INSERT INTO [LoveboatViewModelCache].[dbo].[ShipViewModel]([Id],[Name],[Location]) VALUES ('08B36ED3-75E6-43A1-BFC5-BE726B1A6E20','Enterprise','Hamburg') 
GO
INSERT INTO [LoveboatViewModelCache].[dbo].[ShipViewModel]([Id],[Name],[Location]) VALUES ('4589F4E2-48FD-4838-B843-10348AD04EA8','Lawhill','Plymouth') 
GO
INSERT INTO [LoveboatViewModelCache].[dbo].[ShipViewModel]([Id],[Name],[Location]) VALUES ('2D6BB802-BA41-4676-A0B5-5F1BEAC79213','Colombo Express','Antwerp') 
GO
INSERT INTO [LoveboatViewModelCache].[dbo].[ShipViewModel]([Id],[Name],[Location]) VALUES ('61A12753-69B1-497A-906C-E6883FAB196B','Atlantic Conveyor','Marseilles') 
GO
INSERT INTO [LoveboatViewModelCache].[dbo].[ShipViewModel]([Id],[Name],[Location]) VALUES ('FEF80F50-F213-4817-851D-A61E47D87335','Maritime Jewel','Rotterdam') 
GO


