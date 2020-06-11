USE VIVALDI
GO

IF  EXISTS (
SELECT 	* FROM dbo.sysobjects 
WHERE 	id = OBJECT_ID(N'[dbo].[vw_RelativeVaRReports]') AND 
	OBJECTPROPERTY(id, N'IsView') = 1
)
DROP VIEW [dbo].[vw_RelativeVaRReports]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_RelativeVaRReports]
AS

SELECT	VAR.ReportDate
	, VAR.FundId
	, VAR.VAR
	, VAR.VARBench
	, VAR.VARActive
	, NAV.CostNaV
	, VAR.VARActive/NULLIF(NAV.CostNaV,0) AS ExAnteTE1D
	, (SELECT	SUM(CASE 	WHEN Report.PortShare > 0 THEN 
				(CASE 	WHEN Report.PortShare > Report.BenchPerc 
					THEN Report.BenchPerc 
					ELSE Report.PortShare 
				END)
			ELSE 0 
			END)
		FROM 	tbl_VaRReports AS Report
		WHERE	Report.ReportDate = VAR.ReportDate
			AND Report.ReportId = VaR.ReportId
			AND Report.SecTicker <> 'Totals'
		) / 100 AS IndexPerc
	, (SELECT	CAST(SUM(CASE 	WHEN (Report.PortShare <> 0 
					AND Report.BenchPerc <> 0) THEN 1 
				ELSE 0 
				END) AS DECIMAL(5, 1))
			/
			NULLIF(SUM(CASE 	WHEN Report.BenchPerc <> 0 THEN 1 
				ELSE 0 
				END),0)
		FROM 	tbl_VaRReports AS Report
		WHERE	Report.ReportDate = VAR.ReportDate
			AND Report.ReportId = VaR.ReportId
			AND Report.SecTicker <> 'Totals'
		) AS IndexNamesPerc
	, (VAR.VAR/NAV.CostNaV)/ZScore * SQRT(252) AS ExpFundVol1y
	, (VAR.VARBench/NULLIF(VAR.MarketValThousands*1000,0))/ZScore * SQRT(252) AS ExpBenchVol1y
	, (VAR.VARActive/NAV.CostNaV)/ZScore * SQRT(252) AS ExpTE1y
		

FROM	tbl_VaRReports AS VAR LEFT JOIN
	tbl_FundsNAVsAndPLs AS NAV ON (
		VAR.FundID = NAV.FundID
		AND VAR.ReportDate = NAV.NAVPLDate
		) LEFT JOIN
	tbl_EnumVaRReports AS Reports ON (
		VAR.ReportID = Reports.Id
		) LEFT JOIN
	tbl_Funds AS Funds ON (
		Funds.Id = VaR.FundID
		) LEFT JOIN
	tbl_ZScores AS ZSc ON (
		Funds.ConfidenceInt = ZSc.Probability
		)

WHERE	Reports.IsRelative = 1
	AND VAR.SecTicker = 'Totals'
	AND VAR.ReportDate >= '2009-8-5'

--ORDER BY VaR.FundID, VAR.ReportDate