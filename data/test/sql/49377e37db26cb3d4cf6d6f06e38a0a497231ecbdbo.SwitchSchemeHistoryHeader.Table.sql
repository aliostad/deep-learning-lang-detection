USE [NavIntegrationDB]
GO
/****** Object:  Table [dbo].[SwitchSchemeHistoryHeader]    Script Date: 02/13/2012 17:15:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SwitchSchemeHistoryHeader](
	[HistoryID] [int] IDENTITY(1,1) NOT NULL,
	[SchemeID] [nvarchar](50) COLLATE Latin1_General_BIN NOT NULL,
	[SwitchID] [int] NOT NULL,
	[Action_Date] [datetime] NOT NULL,
	[Status] [smallint] NOT NULL,
 CONSTRAINT [PK_SwitchSchemeHistoryHeader] PRIMARY KEY CLUSTERED 
(
	[HistoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
