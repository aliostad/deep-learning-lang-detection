CREATE TABLE [wsrd].[AirplaneModel]
(
[airplaneModelID] [bigint] NOT NULL IDENTITY(1, 1),
[createdBy] [bigint] NULL,
[modifiedBy] [bigint] NULL,
[createdTime] [datetime] NULL,
[updatedTime] [datetime] NULL,
[statusID] [bigint] NULL,
[groupID] [bigint] NULL,
[AirplaneModelTypeID] [bigint] NULL,
[airplaneModelType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [wsrd].[AirplaneModel] ADD CONSTRAINT [airplaneModelID_PK] PRIMARY KEY CLUSTERED  ([airplaneModelID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [wsrd].[AirplaneModel] ADD CONSTRAINT [AirplaneModelTypeID_PK] FOREIGN KEY ([AirplaneModelTypeID]) REFERENCES [wsrd].[AirplaneModelType] ([airplaneModelTypeID])
GO
ALTER TABLE [wsrd].[AirplaneModel] ADD CONSTRAINT [AirplaneModel_createdBy_PK] FOREIGN KEY ([createdBy]) REFERENCES [wsrd].[BEMS] ([bemsID])
GO
ALTER TABLE [wsrd].[AirplaneModel] ADD CONSTRAINT [AirplaneModel_GroupID_PK] FOREIGN KEY ([groupID]) REFERENCES [wsrd].[GroupDetail] ([groupID])
GO
ALTER TABLE [wsrd].[AirplaneModel] ADD CONSTRAINT [AirplaneModel_modifiedBy_PK] FOREIGN KEY ([modifiedBy]) REFERENCES [wsrd].[BEMS] ([bemsID])
GO
ALTER TABLE [wsrd].[AirplaneModel] ADD CONSTRAINT [AirplaneModel_statusID_PK] FOREIGN KEY ([statusID]) REFERENCES [wsrd].[Status] ([statusID])
GO
