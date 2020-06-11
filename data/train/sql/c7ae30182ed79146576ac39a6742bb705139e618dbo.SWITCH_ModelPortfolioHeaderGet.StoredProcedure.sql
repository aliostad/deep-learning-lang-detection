USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_ModelPortfolioHeaderGet]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_ModelPortfolioHeaderGet] 

@param_ClientID		NVARCHAR(50),
@param_PortfolioID	NVARCHAR(50)


AS
BEGIN

	SET NOCOUNT ON;

	SELECT  
	AccountNumber, CompanyID, Company, Currency, PortfolioTypeID, PortfolioType, PortfolioID, ClientID, PortfolioStartDate, ExcludeFromReports,
	OLDeleted, IFA_ID , ClientNumber,
	ISNULL((SELECT SUM(ValuePortfolio) FROM NavGlobalDBwwwGUID.dbo.ModelPortfolioDetails MPD WHERE MPD.PortfolioID = GMP.PortfolioID and OLDeleted = 0 ),0) AS SumOfValuePortfolio ,
	ISNULL((SELECT SUM(ModelWeightingPercentage) FROM NavGlobalDBwwwGUID.dbo.ModelPortfolioDetails MPD WHERE MPD.PortfolioID = GMP.PortfolioID and OLDeleted = 0 ),0) AS SumOfModelWeightingPercentage,
	ISNULL((SELECT ME_Valuation FROM NavGlobalDBwwwGUID.dbo.PortfolioPremiums PP WHERE PP.PortfolioID = GMP.PortfolioID ),0) AS CurrentValue,
	ISNULL((SELECT PortfolioPremiumID FROM NavGlobalDBwwwGUID.dbo.PortfolioPremiums PP WHERE PP.PortfolioID = GMP.PortfolioID ),0) AS PremiumID
FROM	NavGlobalDBwwwGUID.dbo.GeneralModelPortfolio AS GMP
WHERE	IFA_ID		= 210 
AND		ClientID	= @param_ClientID 
AND		PortfolioID = @param_PortfolioID
END
GO
