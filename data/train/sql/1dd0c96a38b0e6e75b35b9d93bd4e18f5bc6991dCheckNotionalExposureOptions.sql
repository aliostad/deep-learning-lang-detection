USE VIVALDI;

SELECT	P.PositionDate
		, P.PositionId
		, P.SecurityType
		, P.Units
		, A.Description
		, A.CCYIso
		, A.Multiplier
		, O.Underlying
		, O.UnderPrice
		, O.Delta
		, O.UnderMult
		, BFx.LastQuote AS GBPfx
		, BFx.IsInverse AS GBPfxInv
		, Fx.LastQuote AS AssetFx
		, Fx.IsInverse AS AssetFxInv
		, N.CostNaV AS NAV
		, dbo.fn_GetBaseCCYPrice(
			O.UnderPrice
			, Fx.LastQuote
			, Fx.IsInverse
			, BFx.LastQuote
			, BFx.IsInverse
			, P.SecurityType
			, 1) AS BaseUnderPrice
		, dbo.fn_GetBaseCCYPrice(
			O.UnderPrice
			, Fx.LastQuote
			, Fx.IsInverse
			, BFx.LastQuote
			, BFx.IsInverse
			, P.SecurityType
			, 1) * P.Units * A.Multiplier AS NotionalExposure


INTO	#BaseData
FROM	tbl_Positions AS P LEFT JOIN
		tbl_AssetPrices AS A ON 
			(P.PositionDate = A.PriceDate
			AND P.SecurityType = A.SecurityType
			AND P.PositionId = A.SecurityId) LEFT JOIN
		tbl_OptionsData AS O ON 
			(P.PositionId = O.SecurityId
			AND P.PositionDate = O.PriceDate) LEFT JOIN
		vw_FxQuotes AS BFx ON
			(BFx.FxQuoteDate = P.PositionDate) LEFT JOIN
		vw_FxQuotes AS Fx ON
			(Fx.FxQuoteDate = P.PositionDate
			AND A.CCYIso = Fx.ISO) LEFT JOIN
		tbl_FundsNaVsAndPls AS N ON
			(P.PositionDate = N.NaVPLDate)


WHERE	P.FundShortName = 'SKGEN46'  
		AND P.SecurityType IN ('IndexOpt', 'EqOpt')
		AND BFx.ISO = 'GBP'
		AND N.FundId = 135

-------------------------------------------------------

SELECT * FROM #BaseData ORDER BY PositionDate DESC

-------------------------------------------------------

SELECT	PositionDate
		, Underlying
		, SUM(NotionalExposure/NaV)*100 AS NotionalExposure
FROM #BaseData
--WHERE	Underlying = 'EEM US Equity'
GROUP BY	PositionDate, Underlying
ORDER BY PositionDate DESC

-------------------------------------------------------

DROP TABLE #BaseData