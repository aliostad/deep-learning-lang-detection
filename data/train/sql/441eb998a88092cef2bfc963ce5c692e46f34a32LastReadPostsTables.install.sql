/****** Object:  Table [dbo].[fr_Forum_LastRead]    Script Date: 27/06/2014 12:58:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fr_Forum_LastRead]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[fr_Forum_LastRead](
	[Id] [uniqueidentifier] NOT NULL,
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[ContentId] [uniqueidentifier] NOT NULL,
	[UserId] [int] NOT NULL,
	[LastReadContentId] [uniqueidentifier] NOT NULL,
	[LastReadReplyCount] [int] NOT NULL,
	[LastReadDate] [datetime] NOT NULL,
 CONSTRAINT [PK_fr_Forum_LastRead] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[fr_Forum_LastRead] ADD  CONSTRAINT [DF_fr_Forum_LastRead_Id]  DEFAULT (newid()) FOR [Id]


CREATE UNIQUE NONCLUSTERED INDEX [IX_fr_Forum_LastRead_Application_Content_User] ON [dbo].[fr_Forum_LastRead]
(
	[ApplicationId] ASC,
	[ContentId] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


CREATE NONCLUSTERED INDEX [IX_fr_Forum_LastRead_UserId] ON [dbo].[fr_Forum_LastRead]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


END
