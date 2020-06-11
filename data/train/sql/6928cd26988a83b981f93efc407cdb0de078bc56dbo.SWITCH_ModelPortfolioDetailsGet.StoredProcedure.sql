USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_ModelPortfolioDetailsGet]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_ModelPortfolioDetailsGet]

@param_ModelGroupID			nvarchar(50),
@param_ModelPortfolioID		nvarchar(50)


AS
BEGIN
	SELECT 
		IFA_ID,
		ModelGroupID,
		ModelPortfolioID,
		FundID,
		Allocation,
		isDeletable 
	FROM	NavIntegrationDB.dbo.ModelPortfolioDetails
	WHERE	ModelGroupID = @param_ModelGroupID
	AND		ModelPortfolioID = @param_ModelPortfolioID
	--SELECT 
	--	 ClientID,
	--	 PortfolioID,
	--	 FundNameID,
	--	 ModelWeightingPercentage
	--FROM [NavGlobalDBwwwGUID].[dbo].[ModelPortfolioDetails] 
	--WHERE ClientID = @param_ModelGroupID
	--AND PortfolioID = @param_ModelPortfolioID 
	--AND OLDeleted = 0 order by FundName
END
GO
