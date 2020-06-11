CREATE TABLE [mdm].[tblModelVersionFlag]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MUID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [df_tblModelVersionFlag_MUID] DEFAULT (newid()),
[Model_ID] [int] NOT NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status_ID] [tinyint] NOT NULL CONSTRAINT [df_tblModelVersionFlag_Status_ID] DEFAULT ((1)),
[CommittedOnly_ID] [tinyint] NULL,
[EnterDTM] [datetime2] (3) NOT NULL CONSTRAINT [df_tblModelVersionFlag_EnterDTM] DEFAULT (getutcdate()),
[EnterUserID] [int] NOT NULL,
[LastChgDTM] [datetime2] (3) NOT NULL CONSTRAINT [df_tblModelVersionFlag_LastChgDTM] DEFAULT (getutcdate()),
[LastChgUserID] [int] NOT NULL,
[LastChgTS] [timestamp] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [mdm].[tblModelVersionFlag] ADD CONSTRAINT [ck_tblModelVersionFlag_CommittedOnly_ID] CHECK (([CommittedOnly_ID]>=(0) AND [CommittedOnly_ID]<=(2)))
GO
ALTER TABLE [mdm].[tblModelVersionFlag] ADD CONSTRAINT [ck_tblModelVersionFlag_Status_ID] CHECK (([Status_ID]>=(1) AND [Status_ID]<=(3)))
GO
ALTER TABLE [mdm].[tblModelVersionFlag] ADD CONSTRAINT [pk_tblModelVersionFlag] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [mdm].[tblModelVersionFlag] ADD CONSTRAINT [ux_tblModelVersionFlag_Model_ID_Name] UNIQUE NONCLUSTERED  ([Model_ID], [Name]) ON [PRIMARY]
GO
ALTER TABLE [mdm].[tblModelVersionFlag] ADD CONSTRAINT [ux_tblModelVersionFlag_MUID] UNIQUE NONCLUSTERED  ([MUID]) ON [PRIMARY]
GO
ALTER TABLE [mdm].[tblModelVersionFlag] ADD CONSTRAINT [fk_tblModelVersionFlag_tblModel_Model_ID] FOREIGN KEY ([Model_ID]) REFERENCES [mdm].[tblModel] ([ID]) ON DELETE CASCADE
GO
