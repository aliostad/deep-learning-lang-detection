USE VIVALDI
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (
	SELECT * FROM dbo.sysobjects 
	WHERE 	id = OBJECT_ID(N'[dbo].[spS_Worst3ScenariosRel]') AND 
		OBJECTPROPERTY(id,N'IsProcedure') = 1
	)
DROP PROCEDURE [dbo].[spS_Worst3ScenariosRel]
GO

CREATE PROCEDURE [dbo].[spS_Worst3ScenariosRel] 
	@RefDate datetime
AS

SET NOCOUNT ON;


SELECT	ScensA.ReportId
		, ScensA.FundId
		, ScensA.ReportDate
--		, ScensA.PortPerf
		, RANK() OVER (PARTITION BY ScensA.FundId 
		ORDER BY (ScensA.PortPerf - ScensA.BenchPerf) ASC) AS RankNo
INTO	#RankedSc
FROM		tbl_ScenReports AS ScensA 
WHERE		ScensA.ReportDate = @RefDate
			AND ScensA.PortPerf IS NOT NULL
			AND ScensA.BenchPerf IS NOT NULL

SELECT	Scenarios.ReportId
		, Scenarios.FundId
		, Scenarios.ReportDate
		, Scenarios.MktVal
		, (Scenarios.Portperf*Scenarios.MktVal/NaVs.CostNAV)/100 AS PortPerf
		, Scenarios.BenchPerf/100 AS BenchPerf
		, (Scenarios.Portperf*Scenarios.MktVal/NaVs.CostNAV - Scenarios.BenchPerf)/100 AS RelativePerf
		, Ranked.RankNo
		, Funds.FundCode
		, RepDets.ScenLabel
		, (CASE WHEN Scenarios.BenchPerf IS NULL THEN 0 ELSE 1 END) AS IsRelative
		, Funds.HoDLongName AS HoD
		, '<b>' + Funds.FundCode + ' - <i>' + Funds.FundName + '</i></b>  <font color="gray">(' 
			+ FundClass + ', ' + VehicleName 
			+ ISNULL(', benchmark: ' + BenchLong, '')
			+ ')</font>' AS FundLabel
	
FROM	tbl_ScenReports AS Scenarios JOIN
		#RankedSc AS Ranked ON (
			Scenarios.ReportId = Ranked.ReportId
			AND Scenarios.FundId = Ranked.FundId
			AND Scenarios.ReportDate = Ranked.ReportDate
			) LEFT JOIN 
		tbl_EnumScen AS RepDets ON (
			Scenarios.ReportId = RepDets.ID 
			) LEFT JOIN
		tbl_FundsNaVsAndPls AS NaVs ON (
			Scenarios.FundId = NaVs.FundId
			AND Scenarios.ReportDate = NaVs.NavPLDate
			) LEFT JOIN
		vw_FundsTypology AS Funds ON (
			Funds.FundId = Scenarios.FundId
			) 

WHERE	Scenarios.ReportDate = @RefDate
		AND Ranked.RankNo <= 3
ORDER BY	Funds.FundCode ASC
		, Scenarios.PortPerf ASC

DROP TABLE #RankedSc

GRANT EXECUTE ON spS_Worst3ScenariosRel TO [OMAM\StephaneD]
