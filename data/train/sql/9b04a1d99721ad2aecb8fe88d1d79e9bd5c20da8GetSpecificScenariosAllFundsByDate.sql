USE VIVALDI;

DECLARE	@RefDate datetime
		, @ScenId integer

SET @RefDate = '2013 Aug 27'

SELECT	F.FundCode
		, F.FundName
		, (SELECT MAX(PeopleCode) FROM vw_FundsPeopleRoles 
			WHERE RoleCode = 'PM' AND FundId = F.Id) AS PM
		, S.ScenLabel
		, (R.PortPerf/100)*R.MktVal/NAV.CostNav AS AbsPerformance
		, (R.BenchPerf/100) AS BenchPerformance
		, (R.PortPerf/100)*R.MktVal/NAV.CostNav 
				- ISNULL((R.BenchPerf/100),0) AS RelPerformance
		, R.ReportDate

FROM	tbl_scenReports AS R JOIN
		tbl_EnumScen AS S ON 
			(R.ReportId = S.Id) JOIN
		tbl_funds AS F ON 
			(F.Id = R.FundId) JOIN
		vw_FundsPeopleRoles AS D ON
			(F.Id = D.FundId) JOIN
		tbl_FundsNavsAndPLs AS NAV ON
			(R.ReportDate = NAV.NaVPLDate
			AND F.Id = NAV.FundId)

WHERE	D.RoleCode = 'HD'
		AND S.Id IN (35, 42, 40)
		AND R.ReportDate = @RefDate

ORDER BY	S.ScenLabel
			, D.PeopleCode
			, (SELECT MAX(PeopleCode) FROM vw_FundsPeopleRoles 
			WHERE RoleCode = 'PM' AND FundId = F.Id)
