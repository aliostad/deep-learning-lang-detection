USE Vivaldi
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (
	SELECT * FROM dbo.sysobjects 
	WHERE 	id = OBJECT_ID(N'[dbo].[spS_GetScenariosByFundByDate]') AND 
		OBJECTPROPERTY(id,N'IsProcedure') = 1
	)
DROP PROCEDURE [dbo].[spS_GetScenariosByFundByDate]
GO

CREATE PROCEDURE [dbo].[spS_GetScenariosByFundByDate] 
	@RefDate datetime,
	@FundId int 
AS

SET NOCOUNT ON;


SELECT	ScenView.ScenLabel AS ScenarioName
		, ScenView.Id AS ScenId
		, ScenData.ReportDate
		, ScenData.PortPerf*ScenData.MktVal/NaVs.CostNav AS PortPerf
		, ScenData.BenchPerf
		, ScenData.PortPerf*ScenData.MktVal/NaVs.CostNav - ScenData.BenchPerf AS RelPerf
		, ScenData.FundId
		, Funds.FundCode
		, Funds.FundName
FROM	tbl_ScenReports AS ScenData LEFT JOIN
		tbl_EnumScen AS ScenView ON (
			ScenData.ReportId = ScenView.Id
			) LEFT JOIN
		tbl_FundsNaVsAndPLs AS NaVs ON (
			NaVs.FundId = ScenData.FundId
			AND NaVs.NaVPLDate = ScenData.ReportDate
			) LEFT JOIN
		tbl_Funds AS Funds ON (
			ScenData.FundId = Funds.Id
			)
WHERE	ScenData.ReportDate = @RefDate
	AND	((@FundId Is NULL) OR (ScenData.FundId = @FundId))
GO

GRANT EXECUTE ON spS_GetScenariosByFundByDate TO [OMAM\StephaneD], [OMAM\ShaunF]

