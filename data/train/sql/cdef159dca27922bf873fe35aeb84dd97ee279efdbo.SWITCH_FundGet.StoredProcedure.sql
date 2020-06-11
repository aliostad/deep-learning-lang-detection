USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[SWITCH_FundGet]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SWITCH_FundGet] 

@param_intFundNameID int

AS
BEGIN

	SET NOCOUNT ON;
	
	select  FundNameID
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
  WHERE FundNameID = @param_intFundNameID

END
GO
