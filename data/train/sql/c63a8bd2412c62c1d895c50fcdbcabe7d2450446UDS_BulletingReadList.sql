USE [uds]
GO

/****** Object:  Table [dbo].[UDS_BulletinReadList]    Script Date: 05/21/2013 00:38:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[UDS_BulletinReadList](
	[bulletinid] [int] NOT NULL,
	[staffid] [int] NOT NULL,
	[readtime] [datetime] NOT NULL,
 CONSTRAINT [PK_UDS_BulletinReadList] PRIMARY KEY CLUSTERED 
(
	[bulletinid] ASC,
	[staffid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

