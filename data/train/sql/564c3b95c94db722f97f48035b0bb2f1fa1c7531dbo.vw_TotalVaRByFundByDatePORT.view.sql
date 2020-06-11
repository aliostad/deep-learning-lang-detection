USE Vivaldi
GO

IF  EXISTS (
SELECT 	* FROM dbo.sysobjects 
WHERE 	id = OBJECT_ID(N'[dbo].[vw_TotalVaRByFundByDatePORT]') AND 
	OBJECTPROPERTY(id, N'IsView') = 1
)
DROP VIEW [dbo].[vw_TotalVaRByFundByDatePORT]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_TotalVaRByFundByDatePORT]
AS

SELECT 	VaRReports.ReportId AS ReportId
	, Reports.ShortName AS ReportShortName
	, Reports.LongName AS ReportLongName
	, VaRReports.FundId AS FundId
	, Funds.FundCode AS FundShortName
	, Benchs.ID AS BenchMarkId
	, Benchs.ShortName AS BenchShort
	, Benchs.LongName AS BenchLong
	, VaRReports.ReportDate AS VaRDate
	, VaRReports.NumSec AS PositionsNumber
	, VaRReports.MarketValThousands AS FundNMVThousands
	, NAVs.CostNaV AS NAV
	, NAVs.TotalPL AS PL
	, VaRModels.ShortName AS VaRModel
	, Funds.ConfidenceInt AS VaRConfidence
	, Funds.Horizon AS VaRHorizon
	, VaRReports.VaR AS DollarVaR
--	, VaRReports.VaR/VaRReports.MarketValThousands/1000
--	, VaRreports.VaRPerc/100 AS PercentVaRv2
	, VaRReports.VaR/NaVs.CostNav AS PercentVaR
	, VaRReports.CondVaR/NaVs.CostNav AS TailVaROnNaV
	, VaRReports.CondVaR AS TailVaR
	, (VaRReports.VaR/NaVs.CostNav)/ZSc.ZScore*SQRT(252) AS ExpVol1y

FROM 	tbl_VaRReportsPORT AS VaRReports LEFT JOIN
	tbl_Funds AS Funds ON
		(VaRReports.FundId = Funds.Id) LEFT JOIN
	tbl_EnumVaRReports AS Reports ON
		(VaRReports.ReportId = Reports.ID) LEFT JOIN
	tbl_VaRModels AS VaRModels ON
		(Funds.VaRModelId = VaRModels.Id) LEFT JOIN
	tbl_FundsNavsAndPLs AS NAVs ON (
		VaRReports.FundId = Funds.Id
		AND VaRReports.FundId = NAVs.FundId
		AND VaRReports.ReportDate = NAVs.NaVPLDate
		) LEFT JOIN
	tbl_Benchmarks AS Benchs ON (
		Funds.BenchmarkId = Benchs.ID) LEFT JOIN
	tbl_ZScores AS ZSc ON (
		Funds.ConfidenceInt = ZSc.Probability
		)

WHERE	VaRReports.SecTicker = 'Totals' AND
	VaRReports.VARPerc is not null AND
	VaRReports.VaRPerc <> 0
