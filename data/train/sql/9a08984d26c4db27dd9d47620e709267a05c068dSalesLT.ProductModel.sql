CREATE TABLE [SalesLT].[ProductModel]
(
[ProductModelID] [int] NOT NULL IDENTITY(1, 1),
[Name] [dbo].[Name] NOT NULL,
[CatalogDescription] [xml] (CONTENT [SalesLT].[ProductDescriptionSchemaCollection]) NULL,
[rowguid] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_ProductModel_rowguid] DEFAULT (newid()),
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ProductModel_ModifiedDate] DEFAULT (getdate())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [SalesLT].[ProductModel] ADD CONSTRAINT [PK_ProductModel_ProductModelID] PRIMARY KEY CLUSTERED  ([ProductModelID]) ON [PRIMARY]
GO
ALTER TABLE [SalesLT].[ProductModel] ADD CONSTRAINT [AK_ProductModel_Name] UNIQUE NONCLUSTERED  ([Name]) ON [PRIMARY]
GO
ALTER TABLE [SalesLT].[ProductModel] ADD CONSTRAINT [AK_ProductModel_rowguid] UNIQUE NONCLUSTERED  ([rowguid]) ON [PRIMARY]
GO
CREATE PRIMARY XML INDEX [PXML_ProductModel_CatalogDescription] ON [SalesLT].[ProductModel] ([CatalogDescription])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered constraint.', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductModel', 'CONSTRAINT', N'AK_ProductModel_Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered constraint. Used to support replication samples.', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductModel', 'CONSTRAINT', N'AK_ProductModel_rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductModel', 'CONSTRAINT', N'DF_ProductModel_ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductModel', 'CONSTRAINT', N'DF_ProductModel_rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductModel', 'CONSTRAINT', N'PK_ProductModel_ProductModelID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductModel', 'INDEX', N'PK_ProductModel_ProductModelID'
GO
