USE [Fox_2014]
GO
/****** Object:  Table [dbo].[ShowDate]    Script Date: 10/02/2016 18:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ShowDate](
	[Id] [int] IDENTITY(10000,1) NOT FOR REPLICATION NOT NULL,
	[dtDateOfShow] [datetime] NOT NULL,
	[ShowTime] [varchar](50) NULL,
	[bLateNightShow] [bit] NOT NULL,
	[TShowId] [int] NOT NULL,
	[bActive] [bit] NOT NULL,
	[PricingText] [varchar](500) NULL,
	[TicketUrl] [varchar](500) NULL,
	[TAgeId] [int] NOT NULL,
	[TStatusId] [int] NOT NULL,
	[MenuBilling] [varchar](300) NULL,
	[bAutoBilling] [bit] NOT NULL,
	[dtStamp] [datetime] NOT NULL,
 CONSTRAINT [PK_ShowDateTime] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[ShowDate]  WITH NOCHECK ADD  CONSTRAINT [FK_ShowDate_Age] FOREIGN KEY([TAgeId])
REFERENCES [dbo].[Age] ([Id])
GO
ALTER TABLE [dbo].[ShowDate] CHECK CONSTRAINT [FK_ShowDate_Age]
GO
ALTER TABLE [dbo].[ShowDate]  WITH NOCHECK ADD  CONSTRAINT [FK_ShowDate_Show] FOREIGN KEY([TShowId])
REFERENCES [dbo].[Show] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ShowDate] CHECK CONSTRAINT [FK_ShowDate_Show]
GO
ALTER TABLE [dbo].[ShowDate]  WITH NOCHECK ADD  CONSTRAINT [FK_ShowDate_ShowStatus] FOREIGN KEY([TStatusId])
REFERENCES [dbo].[ShowStatus] ([Id])
GO
ALTER TABLE [dbo].[ShowDate] CHECK CONSTRAINT [FK_ShowDate_ShowStatus]
GO
ALTER TABLE [dbo].[ShowDate] ADD  CONSTRAINT [DF_ShowDate_bLateNightShow]  DEFAULT ((0)) FOR [bLateNightShow]
GO
ALTER TABLE [dbo].[ShowDate] ADD  CONSTRAINT [DF_ShowDate_bActive]  DEFAULT ((1)) FOR [bActive]
GO
ALTER TABLE [dbo].[ShowDate] ADD  CONSTRAINT [DF_ShowDate_TAgesId]  DEFAULT ((10000)) FOR [TAgeId]
GO
ALTER TABLE [dbo].[ShowDate] ADD  CONSTRAINT [DF_ShowDate_TStatusId]  DEFAULT ((10000)) FOR [TStatusId]
GO
ALTER TABLE [dbo].[ShowDate] ADD  CONSTRAINT [DF_ShowDate_bAutoBilling]  DEFAULT ((1)) FOR [bAutoBilling]
GO
ALTER TABLE [dbo].[ShowDate] ADD  CONSTRAINT [DF_ShowDateTime_DtStamp]  DEFAULT (getdate()) FOR [dtStamp]
GO
