


CREATE VIEW [dbo].[Fdp_TakeRateSummaryByModel_VW] AS

	SELECT
		  VOL.DocumentId 
		, VOL.ProgrammeId
		, VOL.Gateway
		, VOL.ModelId
		, VOL.FdpModelId
		, CASE
			WHEN VOL.ModelId IS NOT NULL THEN M.BMC
			WHEN VOL.FdpModelId IS NOT NULL THEN M1.BMC
		  END
		  AS BMC
		, M.Trim_Id AS TrimId
		, M1.FdpTrimId
		, VOL.TotalVolume
	FROM
	(
		SELECT
			  H.DocumentId 
			, D.Programme_Id AS ProgrammeId
			, D.Gateway
			, S.ModelId
			, S.FdpModelId
			, SUM(Volume) AS TotalVolume
		FROM
		Fdp_VolumeHeader			AS H
		JOIN OXO_Doc				AS D	ON H.DocumentId = D.Id
		JOIN Fdp_TakeRateSummary	AS S	ON H.FdpVolumeHeaderId = S.FdpVolumeHeaderId
											AND (S.ModelId IS NOT NULL OR S.FdpModelId IS NOT NULL)
		GROUP BY
		  H.DocumentId
		, D.Programme_Id
		, D.Gateway
		, S.ModelId
		, S.FdpModelId
	)
	AS VOL
	LEFT JOIN OXO_Programme_Model	AS M	ON	VOL.ProgrammeId = M.Programme_Id
											AND	VOL.ModelId		= M.Id
	LEFT JOIN Fdp_Model_VW			AS M1	ON	VOL.ProgrammeId = M1.ProgrammeId
											AND VOL.Gateway		= M1.Gateway
											AND VOL.FdpModelId	= M1.FdpModelId