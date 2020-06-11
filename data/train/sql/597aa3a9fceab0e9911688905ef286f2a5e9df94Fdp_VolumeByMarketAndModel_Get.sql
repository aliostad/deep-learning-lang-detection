CREATE PROCEDURE dbo.[Fdp_VolumeByMarketAndModel_Get]
	  @DocumentId	INT
	, @ModelId		INT = NULL
	, @FdpModelId	INT = NULL
	, @MarketId		INT
	, @CDSId		NVARCHAR(16)
AS

	SET NOCOUNT ON;

	WITH UPDATES AS
	(
		SELECT
			  D.ModelId
			, CAST(NULL AS INT) AS FdpModelId
			, D.TotalVolume
		FROM
		Fdp_VolumeHeader AS H
		JOIN Fdp_Changeset			AS C	ON	H.FdpVolumeHeaderId	= C.FdpVolumeHeaderId
											AND C.CreatedBy			= @CDSId
											AND C.IsDeleted			= 0
											AND C.IsSaved			= 0
											AND C.MarketId			= @MarketId
		JOIN Fdp_ChangesetDataItem	AS D	ON C.FdpChangesetId		= D.FdpChangesetDataItemId
											AND D.FdpTakeRateSummaryId IS NOT NULL
											AND D.ModelId			= @ModelId
											AND D.IsDeleted			= 0
		WHERE
		H.DocumentId = @DocumentId

		UNION

		SELECT
			  CAST(NULL AS INT) AS ModelId
			, D.FdpModelId
			, D.TotalVolume
		FROM
		Fdp_VolumeHeader AS H
		JOIN Fdp_Changeset			AS C	ON	H.FdpVolumeHeaderId	= C.FdpVolumeHeaderId
											AND C.CreatedBy			= @CDSId
											AND C.IsDeleted			= 0
											AND C.IsSaved			= 0
											AND C.MarketId			= @MarketId
		JOIN Fdp_ChangesetDataItem	AS D	ON C.FdpChangesetId		= D.FdpChangesetDataItemId
											AND D.FdpTakeRateSummaryId IS NOT NULL
											AND D.FdpModelId		= @FdpModelId
											AND D.IsDeleted			= 0
		WHERE
		H.DocumentId = @DocumentId
	)

	SELECT ISNULL(UPDATES.TotalVolume, S.TotalVolume) AS TotalVolume
	FROM Fdp_TakeRateSummaryByModelAndMarket_VW AS S
	LEFT JOIN UPDATES ON S.ModelId = UPDATES.ModelId
	WHERE
	S.DocumentId = @DocumentId
	AND
	S.MarketId = @MarketId
	AND
	S.ModelId = @ModelId

	UNION

	SELECT ISNULL(UPDATES.TotalVolume, S.TotalVolume) AS TotalVolume
	FROM Fdp_TakeRateSummaryByModelAndMarket_VW AS S
	LEFT JOIN UPDATES ON S.FdpModelId = UPDATES.FdpModelId
	WHERE
	S.DocumentId = @DocumentId
	AND
	S.MarketId = @MarketId
	AND
	S.FdpModelId = @FdpModelId;