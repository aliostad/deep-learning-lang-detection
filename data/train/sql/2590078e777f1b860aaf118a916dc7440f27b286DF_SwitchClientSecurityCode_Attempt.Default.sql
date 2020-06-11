USE [NavIntegrationDB]
GO
/****** Object:  Default [DF_SwitchClientSecurityCode_Attempt]    Script Date: 02/13/2012 17:15:04 ******/
ALTER TABLE [dbo].[SwitchClientSecurityCode] ADD  CONSTRAINT [DF_SwitchClientSecurityCode_Attempt]  DEFAULT ((0)) FOR [Attempt]
GO
