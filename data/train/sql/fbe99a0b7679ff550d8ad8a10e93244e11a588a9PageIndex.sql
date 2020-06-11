USE [petfoodinstitute]
GO
/****** Object:  Table [dbo].[CMS_PageIndex]    Script Date: 01/09/2009 16:38:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CMS_PageIndex](
	[ID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[SiteID] [numeric](18, 0) NULL,
	[NavID] [numeric](18, 0) NULL,
	[ZoneID] [numeric](18, 0) NULL,
	[ContentID] [numeric](18, 0) NULL,
	[Active] [bit] NULL,
	[Sticky] [bit] NULL,
	[Order] [numeric](18, 0) NULL,
 CONSTRAINT [PK_PageIndex] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
