CREATE TABLE [SalesLT].[ProductModel] (
    [ProductModelID]     INT              IDENTITY (1, 1) NOT NULL,
    [Name]               [dbo].[Name]     NOT NULL,
    [CatalogDescription] XML              NULL,
    [rowguid]            UNIQUEIDENTIFIER CONSTRAINT [DF_ProductModel_rowguid] DEFAULT (newid()) NOT NULL,
    [ModifiedDate]       DATETIME         CONSTRAINT [DF_ProductModel_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_ProductModel_ProductModelID] PRIMARY KEY CLUSTERED ([ProductModelID] ASC),
    CONSTRAINT [AK_ProductModel_Name] UNIQUE NONCLUSTERED ([Name] ASC),
    CONSTRAINT [AK_ProductModel_rowguid] UNIQUE NONCLUSTERED ([rowguid] ASC)
);


GO
CREATE SELECTIVE XML INDEX [SXI_ProductModel_Description] ON [SalesLT].[ProductModel]([CatalogDescription])
WITH XMLNAMESPACES (DEFAULT N'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription')
FOR(    Name = N'/ProductDescription/Manufacturer/Name' AS SQL NVARCHAR (200),
        ProductURL = N'/ProductDescription/Manufacturer/ProductURL' AS SQL NVARCHAR (2000)
);

