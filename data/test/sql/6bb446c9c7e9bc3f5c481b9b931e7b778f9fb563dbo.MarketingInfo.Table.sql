USE [B2BProductCatalog]
GO

/****** Object:  Table [dbo].[MarketingInfo]    Script Date: 02/03/2011 10:42:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MarketingInfo](
	[pkId] [int] IDENTITY(1,1) NOT NULL,
	[StyleNumber] [varchar](18) NOT NULL,
	[SalesOrg] [varchar](4) NULL,
	[DistributionChannel] [varchar](2) NULL,
	[MarketingDescEn] [varchar](4000) NULL,
	[MarketingDescFr] [varchar](4000) NULL,
	[StyleKeywords] [varchar](1000) NULL,
	[StyleSizeRun] [varchar](75) NULL,
	[NavCategory1] [varchar](100) NULL,
	[NavCategory2] [varchar](100) NULL,
	[NavCategory3] [varchar](100) NULL,
	[NavCategory4] [varchar](100) NULL,
	[NavCategoryFr1] [varchar](100) NULL,
	[NavCategoryFr2] [varchar](100) NULL,
	[NavCategoryFr3] [varchar](100) NULL,
	[NavCategoryFr4] [varchar](100) NULL,
	[Flag1] [varchar](75) NULL,
	[Flag2] [varchar](75) NULL,
	[Flag3] [varchar](75) NULL,
	[Flag4] [varchar](75) NULL,
	[Flag5] [varchar](75) NULL,
	[Flag6] [varchar](75) NULL,
	[Flag7] [varchar](75) NULL,
	[Flag8] [varchar](75) NULL,
	[Flag9] [varchar](75) NULL,
	[Flag10] [varchar](75) NULL,
	[Flag11] [varchar](75) NULL,
	[Flag12] [varchar](75) NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UpdatedOn] [datetime] NULL,
	[Locale] [nchar](2) NULL,
 CONSTRAINT [PK_MarketingInfo] PRIMARY KEY CLUSTERED 
(
	[pkId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


