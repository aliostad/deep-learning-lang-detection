








CREATE VIEW [dbo].[Fdp_TakeRateSummaryByModelAndMarket_VW] AS

	WITH TotalsByModelAndMarket AS
	(
		SELECT 
			  H.FdpVolumeHeaderId
			, D.Id				AS DocumentId
			, D.Programme_Id	AS ProgrammeId
			, D.Gateway
			, S.MarketId
			, S.ModelId
			, S.FdpModelId
			, S.Volume AS TotalVolume
			, S.PercentageTakeRate
			, S.FdpTakeRateSummaryId
		FROM
		Fdp_VolumeHeader			AS H
		JOIN OXO_Doc				AS D	ON H.DocumentId	= D.Id
		JOIN Fdp_TakeRateSummary	AS S	ON H.FdpVolumeHeaderId = S.FdpVolumeHeaderId
											AND (S.ModelId IS NOT NULL OR S.FdpModelId IS NOT NULL)
	)
	SELECT
		  T.FdpVolumeHeaderId 
		, T.DocumentId
		, T.ProgrammeId
		, T.Gateway
		, T.MarketId
		, MK.Market_Name AS MarketName
		, MK.Market_Group_Id AS MarketGroupId
		, MK.Market_Group_Name AS MarketGroup
		, T.ModelId
		, T.FdpModelId
		, CASE
			WHEN T.ModelId IS NOT NULL THEN M.BMC
			WHEN T.FdpModelId IS NOT NULL THEN M1.BMC
		  END
		  AS BMC
		, M.Trim_Id AS TrimId
		, M1.FdpTrimId
		, T.TotalVolume
		, T.PercentageTakeRate
		, T.FdpTakeRateSummaryId
	FROM TotalsByModelAndMarket				AS T
	LEFT JOIN OXO_Programme_MarketGroupMarket_VW AS MK	ON	T.ProgrammeId = MK.Programme_Id
													AND	T.MarketId	= MK.Market_Id
	LEFT JOIN OXO_Programme_Model			AS M	ON	T.ProgrammeId = M.Programme_Id
													AND	T.ModelId		= M.Id
	LEFT JOIN Fdp_Model_VW					AS M1	ON	T.ProgrammeId = M1.ProgrammeId
													AND T.Gateway		= M1.Gateway
													AND T.FdpModelId	= M1.FdpModelId