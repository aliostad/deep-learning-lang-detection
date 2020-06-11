/****** Object:  Table [dbo].[RSSChannelItem]    Script Date: 06/24/2013 20:01:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[RSSChannelItem](
	[RCItemId] [int] IDENTITY(1,1) NOT NULL,
	[RCId] [int] NULL,
	[RCItemTitle] [varchar](200) NULL,
	[RCItemLink] [varchar](100) NULL,
	[RCItemCategory] [varchar](10) NULL,
	[RCItemAuthor] [varchar](10) NULL,
	[RCItemPubDate] [datetime] NULL,
	[RCItemDescription] [varchar](max) NULL,
	[RCItemComments] [varchar](20) NULL,
	[NavCreateAt] [datetime] NULL,
	[NavCreateBy] [varchar](10) NULL,
	[NavUpdateDT] [datetime] NULL,
	[NavUpdateBy] [varchar](10) NULL,
 CONSTRAINT [PK_RSSCHANNELITEM] PRIMARY KEY CLUSTERED 
(
	[RCItemId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[RSSChannelItem] ADD  CONSTRAINT [DF__RSSChanne__NavCr__7D439ABD]  DEFAULT (getdate()) FOR [NavCreateAt]
GO

ALTER TABLE [dbo].[RSSChannelItem] ADD  CONSTRAINT [DF__RSSChanne__NavUp__7E37BEF6]  DEFAULT (getdate()) FOR [NavUpdateDT]
GO

