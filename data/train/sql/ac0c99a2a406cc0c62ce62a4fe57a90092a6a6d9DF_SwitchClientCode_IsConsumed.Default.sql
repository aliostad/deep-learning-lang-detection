USE [NavIntegrationDB]
GO
/****** Object:  Default [DF_SwitchClientCode_IsConsumed]    Script Date: 02/13/2012 17:15:04 ******/
ALTER TABLE [dbo].[SwitchClientSecurityCode] ADD  CONSTRAINT [DF_SwitchClientCode_IsConsumed]  DEFAULT ((0)) FOR [IsConsumed]
GO
