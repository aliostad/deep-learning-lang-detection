USE [NavIntegrationDB]
GO
/****** Object:  Default [DF_SwitchHeader_SecurityCodeAttempt]    Script Date: 02/13/2012 17:15:04 ******/
ALTER TABLE [dbo].[SwitchHeader] ADD  CONSTRAINT [DF_SwitchHeader_SecurityCodeAttempt]  DEFAULT ((0)) FOR [SecurityCodeAttempt]
GO
