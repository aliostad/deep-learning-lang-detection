CREATE TABLE [Production].[ProductModel]
(
[ProductModelID] [int] NOT NULL IDENTITY(1, 1),
[Name] [dbo].[Name] NOT NULL,
[CatalogDescription] [xml] (CONTENT [Production].[ProductDescriptionSchemaCollection]) NULL,
[Instructions] [xml] (CONTENT [Production].[ManuInstructionsSchemaCollection]) NULL,
[rowguid] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_ProductModel_rowguid] DEFAULT (newid()),
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ProductModel_ModifiedDate] DEFAULT (getdate())
)
GO
ALTER TABLE [Production].[ProductModel] ADD CONSTRAINT [PK_ProductModel_ProductModelID] PRIMARY KEY CLUSTERED  ([ProductModelID])
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_ProductModel_Name] ON [Production].[ProductModel] ([Name])
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_ProductModel_rowguid] ON [Production].[ProductModel] ([rowguid])
GO
CREATE PRIMARY XML INDEX [PXML_ProductModel_CatalogDescription]
ON [Production].[ProductModel] ([CatalogDescription])
GO
CREATE PRIMARY XML INDEX [PXML_ProductModel_Instructions]
ON [Production].[ProductModel] ([Instructions])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product model classification.', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Detailed product catalog information in xml format.', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'COLUMN', N'CatalogDescription'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Manufacturing instructions in xml format.', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'COLUMN', N'Instructions'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product model description.', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for ProductModel records.', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'COLUMN', N'ProductModelID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'COLUMN', N'rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'CONSTRAINT', N'DF_ProductModel_ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'CONSTRAINT', N'DF_ProductModel_rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'CONSTRAINT', N'PK_ProductModel_ProductModelID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'INDEX', N'AK_ProductModel_Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'INDEX', N'AK_ProductModel_rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'INDEX', N'PK_ProductModel_ProductModelID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary XML index.', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'INDEX', N'PXML_ProductModel_CatalogDescription'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary XML index.', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'INDEX', N'PXML_ProductModel_Instructions'
GO
