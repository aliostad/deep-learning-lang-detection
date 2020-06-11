USE [NavIntegrationDB]
GO
/****** Object:  Table [dbo].[SwitchHistoryHeader]    Script Date: 02/13/2012 17:15:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SwitchHistoryHeader](
	[HistoryID] [int] IDENTITY(1,1) NOT NULL,
	[PortfolioID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SwitchID] [int] NOT NULL,
	[Action_Date] [datetime] NOT NULL,
	[Status] [smallint] NOT NULL
) ON [PRIMARY]
GO
