USE [NavIntegrationDB]
GO
/****** Object:  Table [dbo].[SessionState]    Script Date: 02/13/2012 17:15:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SessionState](
	[GUID] [char](38) COLLATE Latin1_General_BIN NOT NULL,
	[Session] [varchar](max) COLLATE Latin1_General_BIN NOT NULL,
	[Destination] [varchar](max) COLLATE Latin1_General_BIN NOT NULL,
	[DateCreated] [datetime] NOT NULL,
 CONSTRAINT [PK_SessionState] PRIMARY KEY CLUSTERED 
(
	[GUID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
