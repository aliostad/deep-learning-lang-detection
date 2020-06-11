/****** Object:  Table [dbo].[NewsSite]    Script Date: 06/24/2013 20:03:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[NewsSite](
	[NewsURLId] [int] IDENTITY(1,1) NOT NULL,
	[NewsURL] [varchar](100) NULL,
	[NewsURLDesc] [varchar](50) NULL,
	[NewsURLStatus] [char](1) NULL,
	[NavCreateAt] [datetime] NULL,
	[NavCreateBy] [varchar](10) NULL,
	[NavUpdateDT] [datetime] NULL,
	[NavUpdateBy] [varchar](10) NULL,
 CONSTRAINT [PK_NEWSSITE] PRIMARY KEY CLUSTERED 
(
	[NewsURLId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[NewsSite] ADD  DEFAULT ('A') FOR [NewsURLStatus]
GO

ALTER TABLE [dbo].[NewsSite] ADD  DEFAULT (getdate()) FOR [NavCreateAt]
GO

ALTER TABLE [dbo].[NewsSite] ADD  DEFAULT (getdate()) FOR [NavUpdateDT]
GO

