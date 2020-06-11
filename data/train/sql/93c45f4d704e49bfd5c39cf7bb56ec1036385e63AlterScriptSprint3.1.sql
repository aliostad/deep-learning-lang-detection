

  USE  [wsrd];


Go
DECLARE @ConfigLookupTables VARCHAR(20);
SELECT @ConfigLookupTables ='sprint3.X';

BEGIN TRANSACTION @ConfigLookupTables
  
--INSERT INTO [wsrd].[BEMS] ([bemsID] ,[firstName] ,[lastName] ,[middleName] ,[createdBy] ,[modifiedBy] ,[createdTime] ,[updatedTime] ,[statusID]) VALUES
	--   (1662795,'Shawn','Karr','',210605,210605,'2014-09-04 14:56:45.970','2014-09-04 14:56:45.970',5)

 --INSERT INTO [wsrd].[UserGroupRoleDetail] ([bemsID] ,[roleID] ,[groupID] ,[createdBy] ,[createdTime]) VALUES (1662795,2,2,210605,'2014-09-04 14:56:45.970')

ALTER TABLE [wsrd].[GroupDetail] ADD description varchar(max)
ALTER TABLE [wsrd].[AttributeType] ADD unitID BIGINT
ALTER TABLE [wsrd].[GroupDetail] DROP COLUMN groupName
ALTER TABLE [wsrd].[Maneuver] ALTER COLUMN  type varchar(500)
ALTER TABLE [wsrd].[TestJustification] ALTER COLUMN  name varchar(500) 
ALTER TABLE [wsrd].[TestSupplierHardware] ALTER COLUMN  name varchar(500)
UPDATE  [wsrd].[Section] SET code=SUBSTRING(title,1,2) where statusID=5 
UPDATE  [wsrd].[Section] SET title=right(title, len(title)-2)  where statusID=5 
UPDATE  [wsrd].[Section] SET title=LTRIM(RTRIM(title))  where statusID=5
ALTER TABLE [wsrd].[UnitType] DROP CONSTRAINT [FK_UnitType_attributeID]
ALTER TABLE [wsrd].[AttributeType] ADD  CONSTRAINT [UNITTYPEID_FK] FOREIGN KEY([unitID])
REFERENCES [wsrd].[UnitType] ([unitID])

GO

/****** Object:  Table [wsrd].[AirplaneModelType]    Script Date: 10/27/2014 11:59:23 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [wsrd].[AirplaneModelType](
	[airplaneModelTypeID] [bigint] IDENTITY(1,1) NOT NULL,
	[airplaneModelType] [varchar](50) NULL,
	[createdBy] [bigint] NULL,
	[modifiedBy] [bigint] NULL,
	[createdTime] [datetime] NULL,
	[updatedTime] [datetime] NULL,
	[StatusID] [bigint] NULL,
 CONSTRAINT [airplaneModelID] PRIMARY KEY CLUSTERED 
(
	[airplaneModelTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [wsrd].[AirplaneModelType]  WITH CHECK ADD  CONSTRAINT [AirplaneModel_createdBy_FK] FOREIGN KEY([createdBy])
REFERENCES [wsrd].[BEMS] ([bemsID])
GO

ALTER TABLE [wsrd].[AirplaneModelType] CHECK CONSTRAINT [AirplaneModel_createdBy_FK]
GO

ALTER TABLE [wsrd].[AirplaneModelType]  WITH CHECK ADD  CONSTRAINT [AirplaneModel_modifiedBy_FK] FOREIGN KEY([modifiedBy])
REFERENCES [wsrd].[BEMS] ([bemsID])
GO

ALTER TABLE [wsrd].[AirplaneModelType] CHECK CONSTRAINT [AirplaneModel_modifiedBy_FK]
GO

ALTER TABLE [wsrd].[AirplaneModelType]  WITH CHECK ADD  CONSTRAINT [AirplaneModel_statusID_FK] FOREIGN KEY([StatusID])
REFERENCES [wsrd].[Status] ([statusID])
GO

ALTER TABLE [wsrd].[AirplaneModelType] CHECK CONSTRAINT [AirplaneModel_statusID_FK]
GO

ALTER TABLE  [wsrd].[AirplaneModelType] ADD AirplaneModelTypeID BIGINT

ALTER TABLE [wsrd].[AirplaneModel]  ADD  CONSTRAINT [AirplaneModelTypeID_FK] FOREIGN KEY([AirplaneModelTypeID])
REFERENCES [wsrd].[AirplaneModelType] ([airplaneModelTypeID])
GO


GO
SET IDENTITY_INSERT [wsrd].[AirplaneModelType] ON 

GO
INSERT [wsrd].[AirplaneModelType] ([airplaneModelTypeID], [airplaneModelType], [createdBy], [modifiedBy], [createdTime], [updatedTime], [StatusID]) VALUES (2, N'737-MAX', 210605, 210605, CAST(0x0000A3AD00000000 AS DateTime), CAST(0x0000A3AD00000000 AS DateTime), 2)
GO
INSERT [wsrd].[AirplaneModelType] ([airplaneModelTypeID], [airplaneModelType], [createdBy], [modifiedBy], [createdTime], [updatedTime], [StatusID]) VALUES (3, N'737-08    
', 210605, 210605, CAST(0x0000A3AD00000000 AS DateTime), CAST(0x0000A3AD00000000 AS DateTime), 2)
GO
INSERT [wsrd].[AirplaneModelType] ([airplaneModelTypeID], [airplaneModelType], [createdBy], [modifiedBy], [createdTime], [updatedTime], [StatusID]) VALUES (4, N'737-MIN   
', 210605, 210605, CAST(0x0000A3AD00000000 AS DateTime), CAST(0x0000A3AD00000000 AS DateTime), 5)
GO
INSERT [wsrd].[AirplaneModelType] ([airplaneModelTypeID], [airplaneModelType], [createdBy], [modifiedBy], [createdTime], [updatedTime], [StatusID]) VALUES (5, N'787-01    
', 210605, 210605, CAST(0x0000A3AD00000000 AS DateTime), CAST(0x0000A3AD00000000 AS DateTime), 5)
GO
INSERT [wsrd].[AirplaneModelType] ([airplaneModelTypeID], [airplaneModelType], [createdBy], [modifiedBy], [createdTime], [updatedTime], [StatusID]) VALUES (6, N'787-06    
', 210605, 210605, CAST(0x0000A3AD00000000 AS DateTime), CAST(0x0000A3AD00000000 AS DateTime), 5)
GO
INSERT [wsrd].[AirplaneModelType] ([airplaneModelTypeID], [airplaneModelType], [createdBy], [modifiedBy], [createdTime], [updatedTime], [StatusID]) VALUES (7, N'787-08    
', 210605, 210605, CAST(0x0000A3AD00000000 AS DateTime), CAST(0x0000A3AD00000000 AS DateTime), 5)
GO
INSERT [wsrd].[AirplaneModelType] ([airplaneModelTypeID], [airplaneModelType], [createdBy], [modifiedBy], [createdTime], [updatedTime], [StatusID]) VALUES (8, N'797-MAX   
', 210605, 210605, CAST(0x0000A3AD00000000 AS DateTime), CAST(0x0000A3AD00000000 AS DateTime), 5)
GO
SET IDENTITY_INSERT [wsrd].[AirplaneModelType] OFF
GO
--------------UPDATE script-----------------------------------------

  UPDATE [wsrd].[AirplaneModel] SET AirplaneModelTypeID=(select AirplaneModelTypeID from wsrd.AirplaneModelType where airplaneModelType='737-MAX')
   where airplaneModelType='737-MAX'

     UPDATE [wsrd].[AirplaneModel] SET AirplaneModelTypeID=(select AirplaneModelTypeID from wsrd.AirplaneModelType where airplaneModelType='737-08')
   where airplaneModelType='737-08'

   UPDATE [wsrd].[AirplaneModel] SET AirplaneModelTypeID=(select AirplaneModelTypeID from wsrd.AirplaneModelType where airplaneModelType='737-MIN')
   where airplaneModelType='737-MIN'
  

   UPDATE [wsrd].[AirplaneModel] SET AirplaneModelTypeID=(select AirplaneModelTypeID from wsrd.AirplaneModelType where airplaneModelType='787-01')
   where airplaneModelType='787-01'

     UPDATE [wsrd].[AirplaneModel] SET AirplaneModelTypeID=(select AirplaneModelTypeID from wsrd.AirplaneModelType where airplaneModelType='787-06')
   where airplaneModelType='787-06'
  

     UPDATE [wsrd].[AirplaneModel] SET AirplaneModelTypeID=(select AirplaneModelTypeID from wsrd.AirplaneModelType where airplaneModelType='787-08')
   where airplaneModelType='787-08'

     UPDATE [wsrd].[AirplaneModel] SET AirplaneModelTypeID=(select AirplaneModelTypeID from wsrd.AirplaneModelType where airplaneModelType='797-MAX')
   where airplaneModelType='797-MAX'


 -----------------------------------------------
COMMIT TRANSACTION @ConfigLookupTables;
GO