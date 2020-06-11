USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_ModelPortfolioGet]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_ModelPortfolioGet]

@param_ModelGroupID		NVARCHAR(50),
@param_ModelPortfolioID	NVARCHAR(50)

AS
BEGIN
	SELECT 
		ModelGroupID,
		ModelPortfolioID,
		ModelPortfolioName,
		ModelPortfolioDesc
	FROM	NavIntegrationDB.dbo.ModelPortfolio
	WHERE	ModelGroupID = @param_ModelGroupID
	AND		ModelPortfolioID = @param_ModelPortfolioID
	--SELECT
	--	 ClientID, 
	--	 PortfolioID, 
	--	 AccountNumber 
	-- FROM	NavGlobalDBwwwGUID.dbo.GeneralModelPortfolio 
	-- WHERE	IFA_ID = 210 
	-- AND	ClientID = @param_ModelGroupID 
	-- AND	PortfolioID = @param_ModelPortfolioID 
END
GO
