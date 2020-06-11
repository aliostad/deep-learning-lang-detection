USE [NavIntegrationDB]
GO
/****** Object:  Table [dbo].[ModelPortfolioDetails]    Script Date: 02/13/2012 17:15:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ModelPortfolioDetails](
	[IFA_ID] [int] NOT NULL,
	[ModelGroupID] [nvarchar](50) COLLATE Latin1_General_BIN NOT NULL,
	[ModelPortfolioID] [nvarchar](50) COLLATE Latin1_General_BIN NOT NULL,
	[FundID] [int] NOT NULL,
	[Allocation] [float] NOT NULL,
	[isDeletable] [smallint] NOT NULL
) ON [PRIMARY]
GO
