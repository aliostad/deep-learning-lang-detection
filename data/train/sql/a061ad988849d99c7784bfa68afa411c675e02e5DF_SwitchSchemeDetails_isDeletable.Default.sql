USE [NavIntegrationDB]
GO
/****** Object:  Default [DF_SwitchSchemeDetails_isDeletable]    Script Date: 02/13/2012 17:15:04 ******/
ALTER TABLE [dbo].[SwitchSchemeDetails] ADD  CONSTRAINT [DF_SwitchSchemeDetails_isDeletable]  DEFAULT ((0)) FOR [isDeletable]
GO
