SELECT 	Positions.PositionDate
	, Positions.Units
	, Positions.StartPrice
	, NaVs.CostNav AS NaV
	, Assets.SecurityId
	, Assets.Description
	, Assets.CCYISO AS AssetCCY
	, Assets.IndustryGroup
	, Assets.TotalReturnEq AS EqReturn
FROM	tbl_positions as Positions LEFT JOIN
	tbl_Funds AS Funds ON
		(Positions.FundShortName = Funds.FundCode) LEFT JOIN
	tbl_FundsNaVsAndPls AS NaVs ON
		(Positions.PositionDate = NaVs.NAVPLDAte
		AND Funds.ID = Navs.FundId) LEFT JOIN
	tbl_AssetPrices AS Assets ON
		(Positions.PositionId = Assets.SecurityId
		AND Positions.Positiondate = Assets.PriceDate
		AND Positions.SecurityType = Assets.SecurityType)

WHERE	Positions.FundShortName = 'FRGEF'
	AND Assets.CCYISO = 'USD'
	AND Assets.IndustryGroup in('Real Estate','Home Builders','Home Furnishing', 'Engineering&Construction')
ORDER BY	Positions.PositionDate
		, Assets.IndustryGroup
	

	