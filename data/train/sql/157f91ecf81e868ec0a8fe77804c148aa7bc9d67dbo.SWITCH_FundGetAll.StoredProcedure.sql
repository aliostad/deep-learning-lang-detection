USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_FundGetAll]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_FundGetAll]

	@param_strFundName		NVARCHAR(50) = NULL

AS
BEGIN

	SET NOCOUNT ON;
	
	IF @param_strFundName is null BEGIN
		SELECT	FundNameID
				,FundName
				,FundManager
				,Sector
				,SubSector
				,Currency
				,Price
				,DatePriceUpdated
				,Renewalsperannum
				,SEDOL
				,FundCreatedDate
				,FundUpdatedDate
				,FundUpdatedBy
				,CompanyID
				,FeedSource
				,FeedListID
				,FundStatus
				,ParentFundNameID
				,ExpiryDate
				,CITICODE
				,ISINCODE
				,TYPECODE
				,FundTypeID
				,SecurityTypeID
				,Checked
		FROM NavGlobalDBwwwGUID.dbo.Fund
		ORDER BY FundName
	END
	ELSE BEGIN
		SELECT	FundNameID
				,FundName
				,FundManager
				,Sector
				,SubSector
				,Currency
				,Price
				,DatePriceUpdated
				,Renewalsperannum
				,SEDOL
				,FundCreatedDate
				,FundUpdatedDate
				,FundUpdatedBy
				,CompanyID
				,FeedSource
				,FeedListID
				,FundStatus
				,ParentFundNameID
				,ExpiryDate
				,CITICODE
				,ISINCODE
				,TYPECODE
				,FundTypeID
				,SecurityTypeID
				,Checked
		FROM NavGlobalDBwwwGUID.dbo.Fund
		WHERE Upper(FundName) LIKE '%' + Upper(@param_strFundName) + '%'
		ORDER BY FundName
	END
END
GO
