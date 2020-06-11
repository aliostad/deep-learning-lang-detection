SELECT	Funds.FundId
	, Funds.FundCode
	, Funds.FundClass
	, SUM(PLs.TotalPl/PLs.CostNaV) AS AbsPLPerc
	, Funds.Benchmark
	, SUM(Benchs.Perf) AS BenchPerf
	, SUM(PLs.TotalPl/PLs.CostNaV) - SUM(Benchs.Perf) AS RelPl
FROM	vw_FundsTypology AS Funds RIGHT JOIN
	tbl_FundsNavsAndPLs AS PLs ON
		(Funds.FundId = PLs.FundId) LEFT JOIN
	tbl_BenchmData AS Benchs ON
		(Funds.BenchmarkId = Benchs.Id
		AND PLs.NavPlDate = Benchs.PriceDate)
WHERE 	PLs.NavPlDate <= '2009-11-30'
	AND PLs.NavPlDate > '2009-11-15'
	AND Funds.IsAlive = '1'
	AND FUnds.IsSkip = '0'
GROUP BY	Funds.FundId
		, Funds.FundCode
		, Funds.FundClass
		, Funds.Benchmark
ORDER BY Funds.FundClass
	, FundCode