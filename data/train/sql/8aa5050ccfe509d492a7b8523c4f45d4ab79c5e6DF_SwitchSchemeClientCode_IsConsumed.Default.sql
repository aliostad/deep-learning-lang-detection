USE [NavIntegrationDB]
GO
/****** Object:  Default [DF_SwitchSchemeClientCode_IsConsumed]    Script Date: 02/13/2012 17:15:04 ******/
ALTER TABLE [dbo].[SwitchSchemeClientSecurityCode] ADD  CONSTRAINT [DF_SwitchSchemeClientCode_IsConsumed]  DEFAULT ((0)) FOR [IsConsumed]
GO
