CREATE TABLE [dbo].[tblDetSelTab] (
    [promotiontypeID]            INT          NOT NULL,
    [dstPromotionTypeName]       VARCHAR (50) NULL,
    [countryID]                  INT          NOT NULL,
    [buildingblockID]            INT          NOT NULL,
    [dstShowOutletSelector]      BIT          NOT NULL,
    [dstShowVolReq]              BIT          NULL,
    [dstShowPrdSelector]         BIT          NULL,
    [showIO]                     BIT          NULL,
    [dstShowModalOutletSelector] BIT          NULL,
    [importLogID]                INT          NULL
);

