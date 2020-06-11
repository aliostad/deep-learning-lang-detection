USE [NavIntegrationDB]
GO
/****** Object:  Default [DF_ModelPortfolioDetails_isDeletable]    Script Date: 02/13/2012 17:15:04 ******/
ALTER TABLE [dbo].[ModelPortfolioDetails] ADD  CONSTRAINT [DF_ModelPortfolioDetails_isDeletable]  DEFAULT ((0)) FOR [isDeletable]
GO
