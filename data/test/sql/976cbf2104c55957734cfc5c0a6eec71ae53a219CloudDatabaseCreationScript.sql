
USE [Flash_Card_Db]
GO

/****** Object:  Table [dbo].[CloudUser]    Script Date: 12/13/2013 13:19:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CloudUser](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserEmail] [nvarchar](100) NOT NULL,
	[Password] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_dbo.CloudUser] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [Flash_Card_Db]
GO

/****** Object:  Table [dbo].[CloudFlashCardSet]    Script Date: 12/13/2013 13:19:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CloudFlashCardSet](
	[ID] [int] NOT NULL,
	[SetName] [nvarchar](50) NULL,
	[UserID] [int] NOT NULL,
 CONSTRAINT [PK_dbo.CloudFlashCardSet] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CloudFlashCardSet]  WITH CHECK ADD  CONSTRAINT [CloudUser_CloudFlashCardSet] FOREIGN KEY([UserID])
REFERENCES [dbo].[CloudUser] ([Id])
GO

ALTER TABLE [dbo].[CloudFlashCardSet] CHECK CONSTRAINT [CloudUser_CloudFlashCardSet]
GO



USE [Flash_Card_Db]
GO

/****** Object:  Table [dbo].[CloudFlashCard]    Script Date: 12/13/2013 13:18:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CloudFlashCard](
	[ID] [int] NOT NULL,
	[Definition] [text] NULL,
	[Pinyin] [nvarchar](50) NULL,
	[Simplified] [nvarchar](50) NULL,
	[Traditional] [nvarchar](50) NULL,
	[OwnerID] [int] NOT NULL,
	[SetID] [int] NOT NULL,
 CONSTRAINT [PK_dbo.CloudFlashCard] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[OwnerID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[CloudFlashCard]  WITH CHECK ADD  CONSTRAINT [CloudFlashCardSet_CloudFlashCard] FOREIGN KEY([SetID], [OwnerID])
REFERENCES [dbo].[CloudFlashCardSet] ([ID], [UserID])
GO

ALTER TABLE [dbo].[CloudFlashCard] CHECK CONSTRAINT [CloudFlashCardSet_CloudFlashCard]
GO


