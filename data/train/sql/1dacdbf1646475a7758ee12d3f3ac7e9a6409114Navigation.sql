/****** Object:  Table [dbo].[Navigation]    Script Date: 06/24/2013 20:03:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Navigation](
	[NavId] [int] IDENTITY(1,1) NOT NULL,
	[NavName] [varchar](10) NULL,
	[NavLink] [varchar](50) NULL,
	[NavParantId] [int] NULL,
	[NavClass] [varchar](5) NULL,
	[NavOrder] [int] NULL,
	[NavDesc] [varchar](20) NULL,
	[NavStatus] [char](1) NULL,
	[NavCreateAt] [datetime] NULL,
	[NavCreateBy] [varchar](10) NULL,
	[NavUpdateDT] [datetime] NULL,
	[NavUpdateBy] [varchar](10) NULL,
 CONSTRAINT [PK_NAVIGATION] PRIMARY KEY NONCLUSTERED 
(
	[NavId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'首页导航栏' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Navigation'
GO

ALTER TABLE [dbo].[Navigation] ADD  DEFAULT ((0)) FOR [NavParantId]
GO

ALTER TABLE [dbo].[Navigation] ADD  DEFAULT ('A') FOR [NavStatus]
GO

ALTER TABLE [dbo].[Navigation] ADD  DEFAULT (getdate()) FOR [NavCreateAt]
GO

ALTER TABLE [dbo].[Navigation] ADD  DEFAULT (getdate()) FOR [NavUpdateDT]
GO

