USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_ModelPortfolioUpdate]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_ModelPortfolioUpdate]

@param_ModelGroupID			nvarchar(50),
@param_ModelPortfolioID		nvarchar(50),
@param_ModelPortfolioDesc	nvarchar(max)

AS
BEGIN
	UPDATE	[NavIntegrationDB].[dbo].[ModelPortfolio]
	   SET	[ModelPortfolioDesc] = @param_ModelPortfolioDesc
	 WHERE	[ModelGroupID] = @param_ModelGroupID
	 AND	[ModelPortfolioID] = @param_ModelPortfolioID
END
GO
