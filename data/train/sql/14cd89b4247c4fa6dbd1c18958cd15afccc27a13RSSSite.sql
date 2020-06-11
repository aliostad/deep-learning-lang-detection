/****** Object:  Table [dbo].[RSSSite]    Script Date: 06/24/2013 20:01:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[RSSSite](
	[RSSId] [int] IDENTITY(1,1) NOT NULL,
	[RSSURL] [varchar](100) NULL,
	[RSSSource] [char](10) NULL,
	[RSSDesc] [varchar](50) NULL,
	[NavCreateAt] [datetime] NULL,
	[NavCreateBy] [varchar](10) NULL,
	[NavUpdateDT] [datetime] NULL,
	[NavUpdateBy] [varchar](10) NULL,
 CONSTRAINT [PK_RSSSITE] PRIMARY KEY CLUSTERED 
(
	[RSSId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[RSSSite] ADD  DEFAULT (getdate()) FOR [NavCreateAt]
GO

ALTER TABLE [dbo].[RSSSite] ADD  DEFAULT (getdate()) FOR [NavUpdateDT]
GO

