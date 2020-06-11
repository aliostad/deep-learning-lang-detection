USE Vivaldi
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (
	SELECT * FROM dbo.sysobjects 
	WHERE 	id = OBJECT_ID(N'[dbo].[spS_GetScenariosByIdByDate]') AND 
		OBJECTPROPERTY(id,N'IsProcedure') = 1
	)
DROP PROCEDURE [dbo].[spS_GetScenariosByIdByDate]
GO

CREATE PROCEDURE [dbo].[spS_GetScenariosByIdByDate] 
	@RefDate datetime,
	@ScenarioId integer
AS

SET NOCOUNT ON;


SELECT	ScenView.*
	, ScenData.ReportDate
	, F.FundCode
	, F.FundName
	, ScenData.PortPerf*ScenData.MktVal/NaVs.CostNav/100 AS PortPerf
	, ScenData.BenchPerf/100 AS BenchPerf
	, ScenData.PortPerf*ScenData.MktVal/NaVs.CostNav/100 - ScenData.BenchPerf/100 AS RelPerf
FROM	tbl_ScenReports AS ScenData LEFT JOIN
		tbl_EnumScen AS ScenView ON (
			ScenData.ReportId = ScenView.Id
			) LEFT JOIN
		tbl_FundsNaVsAndPLs AS NaVs ON (
			NaVs.FundId = ScenData.FundId
			AND NaVs.NaVPLDate = ScenData.ReportDate
		) LEFT JOIN
		tbl_Funds AS F ON (ScenData.FundId = F.Id)
WHERE	ScenData.ReportDate = @RefDate
	AND	ScenView.Id= @ScenarioId

GO

GRANT EXECUTE ON spS_GetScenariosByIdByDate TO [OMAM\StephaneD]

