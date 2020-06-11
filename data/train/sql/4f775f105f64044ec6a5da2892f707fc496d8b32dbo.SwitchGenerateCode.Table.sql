USE [NavIntegrationDB]
GO
/****** Object:  Table [dbo].[SwitchGenerateCode]    Script Date: 02/13/2012 17:15:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SwitchGenerateCode](
	[Code] [nvarchar](16) COLLATE Latin1_General_BIN NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[DateValidUntil]  AS (dateadd(day,(30),[DateCreated])),
 CONSTRAINT [PK_SwitchGenerateCode_1] PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
