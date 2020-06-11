/****** Object:  Table [dbo].[NewsInfo]    Script Date: 06/24/2013 20:03:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[NewsInfo](
	[NewsId] [numeric](8, 0) IDENTITY(1,1) NOT NULL,
	[NewsTitle] [varchar](50) NULL,
	[NewsPubDate] [datetime] NULL,
	[NewsAuthor] [varchar](10) NULL,
	[NewsCategory] [int] NULL,
	[NewsIndustry] [varchar](10) NULL,
	[NewsSource] [varchar](30) NULL,
	[NewsContents] [text] NULL,
	[NewsStatus] [char](1) NULL,
	[NavCreateAt] [datetime] NULL,
	[NavCreateBy] [varchar](10) NULL,
	[NavUpdateDT] [datetime] NULL,
	[NavUpdateBy] [varchar](10) NULL,
 CONSTRAINT [PK_NEWSINFO] PRIMARY KEY CLUSTERED 
(
	[NewsId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[NewsInfo] ADD  DEFAULT ('A') FOR [NewsStatus]
GO

ALTER TABLE [dbo].[NewsInfo] ADD  DEFAULT (getdate()) FOR [NavCreateAt]
GO

ALTER TABLE [dbo].[NewsInfo] ADD  DEFAULT (getdate()) FOR [NavUpdateDT]
GO

