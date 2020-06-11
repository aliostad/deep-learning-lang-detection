USE [NavIntegrationDB]
GO
/****** Object:  Default [DF_SwitchHeader_IsModelCustomized]    Script Date: 02/13/2012 17:15:04 ******/
ALTER TABLE [dbo].[SwitchHeader] ADD  CONSTRAINT [DF_SwitchHeader_IsModelCustomized]  DEFAULT ((0)) FOR [IsModelCustomized]
GO
