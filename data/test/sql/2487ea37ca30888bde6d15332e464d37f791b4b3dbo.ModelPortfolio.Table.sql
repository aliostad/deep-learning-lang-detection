USE [NavIntegrationDB]
GO
/****** Object:  Table [dbo].[ModelPortfolio]    Script Date: 02/13/2012 17:15:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ModelPortfolio](
	[ModelPortfolioID] [nvarchar](50) COLLATE Latin1_General_BIN NOT NULL,
	[ModelGroupID] [nvarchar](50) COLLATE Latin1_General_BIN NOT NULL,
	[ModelPortfolioName] [nvarchar](50) COLLATE Latin1_General_BIN NOT NULL,
	[ModelPortfolioDesc] [nvarchar](max) COLLATE Latin1_General_BIN NULL,
 CONSTRAINT [PK_ModelPortfolio] PRIMARY KEY CLUSTERED 
(
	[ModelPortfolioID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
