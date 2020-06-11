USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_PortfolioHeaderGet]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_PortfolioHeaderGet] 

@param_strClientID nvarchar(50),
@param_strPortfolioID nvarchar(50)


AS
BEGIN

	SET NOCOUNT ON;

	select	vPGD.AccountNumber, vPGD.CompanyID, vPGD.Company, vPGD.PortfolioCurrency, 
			vPGD.PortfolioType, vPGD.PortfolioID, vPGD.ClientID, vPGD.PortfolioTypeID, 
			vPGD.PortfolioStartDate, vPGD.PlanStatus, vPGD.Liquidity, vPGD.RiskProfile, 
			vPGD.RetentionTerm, vPGD.MFPercent, vPGD.ExcludeFromReports, vPGD.ClientGenerated,
			Portfolio.SwitchConfirmationRequired
	from NavGlobalDBwwwGUID.dbo.PortfolioGeneralDetails vPGD
	left join NavGlobalDBwwwGUID.dbo.Portfolio Portfolio
		On Portfolio.ClientID = vPGD.ClientID And Portfolio.PortfolioID = vPGD.PortfolioID
	where vPGD.ClientID = @param_strClientID and vPGD.PortfolioID = @param_strPortfolioID 
END
GO
