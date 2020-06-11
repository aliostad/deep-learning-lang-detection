USE [NavIntegrationDB]
GO
/****** Object:  Table [dbo].[SwitchSchemeHistoryMessages]    Script Date: 02/13/2012 17:15:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SwitchSchemeHistoryMessages](
	[MessageID] [int] IDENTITY(1,1) NOT NULL,
	[HistoryID] [int] NOT NULL,
	[Message] [nvarchar](max) COLLATE Latin1_General_BIN NULL,
 CONSTRAINT [PK_SwitchSchemeHistoryMessages] PRIMARY KEY CLUSTERED 
(
	[MessageID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
