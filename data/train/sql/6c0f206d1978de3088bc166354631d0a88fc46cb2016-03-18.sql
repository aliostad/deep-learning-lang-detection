USE ITech
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ItechUsers SET (LOCK_ESCALATION = TABLE)
GO


ALTER TABLE dbo.Dokument SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ItechUsersDokumentRead](
	[DokId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[FirstReadAt] [datetime] NULL,
	[LastReadAt] [datetime] NULL,
	[DokVersion] [int] NOT NULL CONSTRAINT [DF_ItechUsersDokumentRead_DokVersion]  DEFAULT ((0)),
	[ReadCount] [int] NOT NULL CONSTRAINT [DF_ItechUsersDokumentRead_ReadCount]  DEFAULT ((0)),
 CONSTRAINT [PK_ItechUsersDokumentRead_1] PRIMARY KEY CLUSTERED 
(
	[DokId] ASC,
	[UserId] ASC,
	[DokVersion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[ItechUsersDokumentRead]  WITH CHECK ADD  CONSTRAINT [FK_ItechUsersDokumentRead_Dokument] FOREIGN KEY([DokId])
REFERENCES [dbo].[Dokument] ([Id])
GO

ALTER TABLE [dbo].[ItechUsersDokumentRead] CHECK CONSTRAINT [FK_ItechUsersDokumentRead_Dokument]
GO

ALTER TABLE [dbo].[ItechUsersDokumentRead]  WITH CHECK ADD  CONSTRAINT [FK_ItechUsersDokumentRead_ItechUsers] FOREIGN KEY([UserId])
REFERENCES [dbo].[ItechUsers] ([id])
GO

ALTER TABLE [dbo].[ItechUsersDokumentRead] CHECK CONSTRAINT [FK_ItechUsersDokumentRead_ItechUsers]
GO

ALTER TABLE dbo.Dokument ADD
	Version int NOT NULL CONSTRAINT DF_Dokument_Version DEFAULT 0
GO
ALTER TABLE dbo.Dokument SET (LOCK_ESCALATION = TABLE)

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ItechUsersNewsRead](
	[NewsItemId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[FirstReadAt] [datetime] NULL,
	[LastReadAt] [datetime] NULL,
	[ReadCount] [int] NOT NULL CONSTRAINT [DF_ItechUsersNewsRead_ReadCount]  DEFAULT ((0)),
 CONSTRAINT [PK_ItechUsersNewsRead] PRIMARY KEY CLUSTERED 
(
	[NewsItemId] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[ItechUsersNewsRead]  WITH CHECK ADD  CONSTRAINT [FK_ItechUsersNewsRead_ItechUsers] FOREIGN KEY([UserId])
REFERENCES [dbo].[ItechUsers] ([id])
GO

ALTER TABLE [dbo].[ItechUsersNewsRead] CHECK CONSTRAINT [FK_ItechUsersNewsRead_ItechUsers]
GO



ALTER TABLE dbo.News ADD
	[ItemId] [int] NULL


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[NewsItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NewsText] [nvarchar](max) NOT NULL,
	[ValidEnd] [datetime] NULL,
	[CreateAt] [datetime] NULL,
	[CreateBy] [nvarchar](128) NULL,
	[NewsPriorityId] [int] NOT NULL,
 CONSTRAINT [PK_NewsItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[NewsItems]  WITH CHECK ADD  CONSTRAINT [FK_NewsItems_NewsPriority] FOREIGN KEY([NewsPriorityId])
REFERENCES [dbo].[NewsPriority] ([id])
GO

ALTER TABLE [dbo].[NewsItems] CHECK CONSTRAINT [FK_NewsItems_NewsPriority]
GO

ALTER TABLE [dbo].[News]  WITH CHECK ADD  CONSTRAINT [FK_News_NewsItems] FOREIGN KEY([ItemId])
REFERENCES [dbo].[NewsItems] ([Id])
GO

ALTER TABLE [dbo].[ItechUsersNewsRead]  WITH CHECK ADD  CONSTRAINT [FK_ItechUsersNewsRead_NewsItems] FOREIGN KEY([NewsItemId])
REFERENCES [dbo].[NewsItems] ([Id])
GO

ALTER TABLE [dbo].[ItechUsersNewsRead] CHECK CONSTRAINT [FK_ItechUsersNewsRead_NewsItems]
GO

COMMIT