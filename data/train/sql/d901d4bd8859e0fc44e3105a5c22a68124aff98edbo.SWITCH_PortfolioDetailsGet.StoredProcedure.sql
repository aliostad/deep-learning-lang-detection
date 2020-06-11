USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_PortfolioDetailsGet]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_PortfolioDetailsGet] 

@param_strClientID nvarchar(50),
@param_strPortfolioID nvarchar(50)


AS
BEGIN

	SET NOCOUNT ON;
	
	select         
			ClientID, 
			PortfolioID, 
			PortfolioStartDate, 
			Company, 
			FundManagerWeb,                       
			CompanyID, 
			NameOfFund, 
			FundNameID, 
			Sector, 
			SectorID, 
			DataDate,                 
			ClientCurrency, 
			PortfolioCurrency, 
			NumberOfUnits, 
			Price, 
			SEDOL,         
			PurchaseCostFund, 
			FundCurrency, 
			PurchaseCostPortfolio,                 
			CurrentValuePortfolio,                 
			CurrentValueClient,         
			AllocationPercent,
			GainOrLossPercent,                       
            GainOrLossPortfolio, 
            PortfolioType, 
            PortfolioTypeID, 
            AccountNumber, 
            DatePriceUpdated,                       
			ClientGenerated, 
			FundID, 
			ExcludeFromReports, 
			OLDeleted, 
			PlanStatus, 
			fundcode, 
			[Type], 
			TYPECODE, 
			PortfolioDataCreatedDate, 
			ModelWeightingPercentage, 
			Liquidity, 
			RiskProfile, 
			RetentionTerm, 
			MFPercent,			
			(select SUM(CurrentValueClient)
				from NavGlobalDBwwwGUID.dbo.PortfolioDetailsTest2 
				where	ClientID = @param_strClientID 
				and PortfolioID = @param_strPortfolioID 
				and OLDeleted = 0) as TotalCurrentValueClient,
			(select NavGlobalDBwwwGUID.dbo.Portfolio.SwitchIFAPermit
				from NavGlobalDBwwwGUID.dbo.Portfolio
				where	ClientID = @param_strClientID 
						and PortfolioID = @param_strPortfolioID 
						and OLDeleted = 0) as SwitchIFAPermit
         
	from NavGlobalDBwwwGUID.dbo.PortfolioDetailsTest2 
	where	ClientID = @param_strClientID 
			and PortfolioID = @param_strPortfolioID 
			and OLDeleted = 0 
	order by NameOfFund, DataDate desc

END
GO
