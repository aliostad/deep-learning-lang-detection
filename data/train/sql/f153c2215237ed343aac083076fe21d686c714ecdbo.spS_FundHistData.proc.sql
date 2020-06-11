USE VIVALDI
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (
	SELECT * FROM dbo.sysobjects 
	WHERE 	id = OBJECT_ID(N'[dbo].[spS_FundHistData]') AND 
		OBJECTPROPERTY(id,N'IsProcedure') = 1
	)
DROP PROCEDURE [dbo].[spS_FundHistData]
GO

CREATE PROCEDURE [dbo].[spS_FundHistData] 
	@FundId int,
	@EndDate datetime,
	@months int 
AS

SET NOCOUNT ON;

SELECT	NaVData.NaVPLDate AS ReportDate
	, NaVData.CostNaV AS NaV
	, NaVData.TotalPL AS TotalPL
	, NaVData.TotalPL/NaVData.CostNaV AS TotalPLPerc
	, VaRData.DollarVaR AS DollarVaR
	, VaRData.DollarVaR/NaVData.CostNaV AS VaRPerc
	, (NaVData.TotalPL/NaVData.CostNaV)/
	((VaRData.DollarVaR/NaVData.CostNaV)/ZScores.Zscore) AS ChiStatistic
	, VaREvent =
		CASE 
			WHEN NaVData.TotalPL/NaVData.CostNaV < -VaRData.DollarVaR/NaVData.CostNaV THEN
			1
		ELSE
			0
		END
	, ABS(NaVData.TotalPL)/NaVData.CostNaV AS AbsPLPerc
	, NaVData.GrossExposure As GrossExposure
	, NaVData.NetExposure AS NetExposure
	, NaVData.FIShortBonds AS FIShortExp
	, NaVData.CCYExposure AS CCYExposure
	, RelPl.BenchPl AS Benchmark
	, RelPl.RelPL As RelativePl
	, RelVaR.VaRBench AS BenchVaR
	, RelVaR.ExAnteTE1D AS ExAnteTe
	

	
FROM	tbl_FundsNavsAndPLs AS NavData LEFT JOIN
	vw_TotalVaRByFundBydate AS VaRData ON (
		NaVData.FundId = VaRData.FundId
		AND NaVData.NaVPLDate = VaRData.VaRDate
		) LEFT JOIN
	tbl_ZScores AS ZScores ON (
		VaRData.VaRConfidence = ZScores.Probability
	) LEFT JOIN
	vw_RelativePerformance AS RelPL ON (
		NaVData.FundId = RelPL.FundId
		AND NaVData.NaVPLDate = RelPL.PlDate
	) LEFT JOIN
	vw_RelativeVaRReports AS RelVaR ON (
		NaVData.FundId = RelVaR.FundId
		AND NaVData.NaVPLDate = RelVaR.ReportDate
	)

WHERE	NaVData.FundId = @FundId
	AND NaVData.NavPLDate <= @EndDate
	AND NaVData.NavPLDate > dateadd(month, -@months, @EndDate)
--	AND VaRData.DollarVaR IS NOT NULL
	
ORDER BY	NaVData.NaVPLDate ASC

GO

GRANT EXECUTE ON spS_FundHistData TO [OMAM\StephaneD], [OMAM\SimonM]