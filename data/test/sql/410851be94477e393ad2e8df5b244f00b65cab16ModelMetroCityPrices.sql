CREATE TABLE [dbo].[ModelMetroCityPrices] (
    [ModelMetroCityPricesId] INT      IDENTITY (1, 1) NOT NULL,
    [CarModelId]             INT      NOT NULL,
    [CityId]                 INT      NOT NULL,
    [MinPrice]               INT      NULL,
    [MaxPrice]               INT      NULL,
    [CreatedOn]              DATETIME CONSTRAINT [DF_ModelMetroCityPrices_CreatedOn] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_ModelMetroCityPrices_ModelId_CityId] PRIMARY KEY NONCLUSTERED ([CarModelId] ASC, [CityId] ASC)
);

