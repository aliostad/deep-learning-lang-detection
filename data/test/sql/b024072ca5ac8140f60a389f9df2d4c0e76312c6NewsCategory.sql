/****** Object:  Table [dbo].[NewsCategory]    Script Date: 06/24/2013 20:03:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[NewsCategory](
	[NewsCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[NewsCategoryName] [varchar](10) NULL,
	[NewsCategoryDesc] [varchar](30) NULL,
	[NavCreateAt] [datetime] NULL,
	[NavCreateBy] [varchar](10) NULL,
	[NavUpdateDT] [datetime] NULL,
	[NavUpdateBy] [varchar](10) NULL,
 CONSTRAINT [PK_NEWSCATEGORY] PRIMARY KEY CLUSTERED 
(
	[NewsCategoryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[NewsCategory] ADD  CONSTRAINT [DF__NewsCateg__NavCr__5DCAEF64]  DEFAULT (getdate()) FOR [NavCreateAt]
GO

ALTER TABLE [dbo].[NewsCategory] ADD  CONSTRAINT [DF__NewsCateg__NavUp__5EBF139D]  DEFAULT (getdate()) FOR [NavUpdateDT]
GO

