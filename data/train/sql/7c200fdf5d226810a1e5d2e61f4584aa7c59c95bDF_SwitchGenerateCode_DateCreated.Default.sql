USE [NavIntegrationDB]
GO
/****** Object:  Default [DF_SwitchGenerateCode_DateCreated]    Script Date: 02/13/2012 17:15:04 ******/
ALTER TABLE [dbo].[SwitchGenerateCode] ADD  CONSTRAINT [DF_SwitchGenerateCode_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
