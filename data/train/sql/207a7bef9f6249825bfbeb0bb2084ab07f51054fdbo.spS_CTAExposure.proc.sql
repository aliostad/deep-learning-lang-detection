USE Vivaldi
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (
	SELECT * FROM dbo.sysobjects 
	WHERE 	id = OBJECT_ID(N'[dbo].[spS_CTAExposure]') AND 
		OBJECTPROPERTY(id,N'IsProcedure') = 1
	)
DROP PROCEDURE [dbo].[spS_CTAExposure]
GO

CREATE PROCEDURE [dbo].[spS_CTAExposure]
	@RefDate datetime,
	@FundId int 
AS

SET NOCOUNT ON;


SELECT	Sum(FutPos.MarginBase) AS TM
	, Sum(FutPos.PointsValueBase) AS TNP
	, SUM(FutPos.NotionalBase) AS TNN
	, SUM(ABS(FutPos.PointsValueBase)) AS TGP
	, SUM(ABS(FutPos.NotionalBase)) AS TGN
	, NaVs.MktNaVPrices AS NaV

INTO	#Totals
FROM	vw_FuturesPositions AS FutPos LEFT JOIN
	tbl_FundsNavsAndPLs AS NaVs ON
		(FutPos.FundId = NaVs.FundId
		AND FutPos.PositionDate = NaVs.NaVPLDate)
WHERE	FutPos.FundId = @FundId
	AND FutPos.PositionDate = @RefDate

GROUP BY	NaVs.MktNaVPrices


----------------------------------------------------------------------------------------------------------------------

SELECT	FutPos.SecurityGroup
	, FutPos.SecurityType
	, Sum(FutPos.MarginBase) AS TotalMargin
 	, Sum(FutPos.PointsValueBase) AS NetPoints
	, SUM(FutPos.NotionalBase) AS NetNotionals
	, SUM(ABS(FutPos.PointsValueBase)) AS GrossPoints
	, SUM(ABS(FutPos.NotionalBase)) AS GrossNotionals
	, Sum(FutPos.MarginBase)/Totals.TM AS TotalMarginPerc
 	, Sum(FutPos.PointsValueBase)/Totals.TNP AS NetPointsPerc
	, SUM(FutPos.NotionalBase)/Totals.TNN AS NetNotionalsPerc
	, SUM(ABS(FutPos.PointsValueBase))/Totals.TGP AS GrossPointsPerc
	, SUM(ABS(FutPos.NotionalBase))/Totals.TGN AS GrossNotionalsPerc
	, Sum(FutPos.MarginBase)/Totals.NaV AS TotalMarginOnNaV
	, Totals.NaV

INTO #AllExp

FROM vw_FuturesPositions AS FutPos, #Totals AS Totals

WHERE	FutPos.FundId = @FundId
	AND FutPos.PositionDate = @RefDate

GROUP BY FutPos.SecurityType
	, FutPos.SecurityGroup
	, Totals.TM
	, Totals.TNP
	, Totals.TNN
	, Totals.TGP
	, Totals.TGN
	, Totals.NaV

----------------------------------------------------------------------------------------------------------------------

SELECT * FROM #AllExp

UNION
SELECT 	'Totals'
	, 'OnNaV'
	, SUM(TotalMargin)/NaV
	, SUM(NetPoints)/NaV
	, SUM(NetNotionals)/NaV
	, SUM(GrossPoints)/NaV
	, SUM(GrossNotionals)/NaV
	, 0
	, 0
	, 0
	, 0
	, 0
	, SUM(TotalMarginOnNaV)
	, NAV

FROM	#AllExp

GROUP BY NaV

----------------------------------------------------------------------------------------------------------------------

DROP Table #Totals
DROP Table #AllExp

GO

GRANT EXECUTE ON [spS_CTAExposure] TO [OMAM\StephaneD], [OMAM\MargaretA]