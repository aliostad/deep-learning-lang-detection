USE [NavIntegrationDB]
GO
/****** Object:  Default [DF_SwitchFeeHistory_Per_Switch_Fee]    Script Date: 02/13/2012 17:15:04 ******/
ALTER TABLE [dbo].[SwitchFeeHistory] ADD  CONSTRAINT [DF_SwitchFeeHistory_Per_Switch_Fee]  DEFAULT ((0)) FOR [Per_Switch_Fee]
GO
