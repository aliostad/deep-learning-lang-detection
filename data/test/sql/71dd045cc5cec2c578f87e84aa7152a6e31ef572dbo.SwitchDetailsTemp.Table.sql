USE [NavIntegrationDB]
GO
/****** Object:  Table [dbo].[SwitchDetailsTemp]    Script Date: 02/13/2012 17:15:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SwitchDetailsTemp](
	[ClientID] [nvarchar](50) COLLATE Latin1_General_BIN NOT NULL,
	[PortfolioID] [nvarchar](50) COLLATE Latin1_General_BIN NOT NULL,
	[FundID] [int] NOT NULL,
	[Allocation] [float] NOT NULL,
	[Date_Created] [datetime] NULL,
	[Created_By] [nvarchar](50) COLLATE Latin1_General_BIN NULL,
	[Date_Updated] [datetime] NULL,
	[Updated_By] [nvarchar](50) COLLATE Latin1_General_BIN NULL,
	[isDeletable] [smallint] NOT NULL
) ON [PRIMARY]
GO
