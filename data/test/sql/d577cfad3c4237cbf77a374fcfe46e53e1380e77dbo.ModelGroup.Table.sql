USE [NavIntegrationDB]
GO
/****** Object:  Table [dbo].[ModelGroup]    Script Date: 02/13/2012 17:15:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ModelGroup](
	[ModelGroupID] [nvarchar](50) COLLATE Latin1_General_BIN NOT NULL,
	[ModelGroupName] [nvarchar](50) COLLATE Latin1_General_BIN NOT NULL,
	[IFA_ID] [int] NOT NULL,
	[ModelGroupCode] [int] NOT NULL,
	[Date_Created] [datetime] NULL,
 CONSTRAINT [PK_ModelGroup] PRIMARY KEY CLUSTERED 
(
	[ModelGroupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
