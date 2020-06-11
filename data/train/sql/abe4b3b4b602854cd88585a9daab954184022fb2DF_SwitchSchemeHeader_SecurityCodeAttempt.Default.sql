USE [NavIntegrationDB]
GO
/****** Object:  Default [DF_SwitchSchemeHeader_SecurityCodeAttempt]    Script Date: 02/13/2012 17:15:04 ******/
ALTER TABLE [dbo].[SwitchSchemeHeader] ADD  CONSTRAINT [DF_SwitchSchemeHeader_SecurityCodeAttempt]  DEFAULT ((0)) FOR [SecurityCodeAttempt]
GO
