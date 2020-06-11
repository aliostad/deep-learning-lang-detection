USE [NavIntegrationDB]
GO
/****** Object:  Default [DF_SwitchDetailsTemp_isDeletable]    Script Date: 02/13/2012 17:15:04 ******/
ALTER TABLE [dbo].[SwitchDetailsTemp] ADD  CONSTRAINT [DF_SwitchDetailsTemp_isDeletable]  DEFAULT ((0)) FOR [isDeletable]
GO
