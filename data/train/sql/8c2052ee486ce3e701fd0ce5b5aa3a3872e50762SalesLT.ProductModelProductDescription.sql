CREATE TABLE [SalesLT].[ProductModelProductDescription]
(
[ProductModelID] [int] NOT NULL,
[ProductDescriptionID] [int] NOT NULL,
[Culture] [nchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[rowguid] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_ProductModelProductDescription_rowguid] DEFAULT (newid()),
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ProductModelProductDescription_ModifiedDate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [SalesLT].[ProductModelProductDescription] ADD CONSTRAINT [PK_ProductModelProductDescription_ProductModelID_ProductDescriptionID_Culture] PRIMARY KEY CLUSTERED  ([ProductModelID], [ProductDescriptionID], [Culture]) ON [PRIMARY]
GO
ALTER TABLE [SalesLT].[ProductModelProductDescription] ADD CONSTRAINT [AK_ProductModelProductDescription_rowguid] UNIQUE NONCLUSTERED  ([rowguid]) ON [PRIMARY]
GO
ALTER TABLE [SalesLT].[ProductModelProductDescription] ADD CONSTRAINT [FK_ProductModelProductDescription_ProductDescription_ProductDescriptionID] FOREIGN KEY ([ProductDescriptionID]) REFERENCES [SalesLT].[ProductDescription] ([ProductDescriptionID])
GO
ALTER TABLE [SalesLT].[ProductModelProductDescription] ADD CONSTRAINT [FK_ProductModelProductDescription_ProductModel_ProductModelID] FOREIGN KEY ([ProductModelID]) REFERENCES [SalesLT].[ProductModel] ([ProductModelID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cross-reference table mapping product descriptions and the language the description is written in.', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductModelProductDescription', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The culture for which the description is written', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductModelProductDescription', 'COLUMN', N'Culture'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductModelProductDescription', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Foreign key to ProductDescription.ProductDescriptionID.', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductModelProductDescription', 'COLUMN', N'ProductDescriptionID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Foreign key to ProductModel.ProductModelID.', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductModelProductDescription', 'COLUMN', N'ProductModelID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered constraint. Used to support replication samples.', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductModelProductDescription', 'CONSTRAINT', N'AK_ProductModelProductDescription_rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductModelProductDescription', 'CONSTRAINT', N'DF_ProductModelProductDescription_ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing ProductDescription.ProductDescriptionID.', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductModelProductDescription', 'CONSTRAINT', N'FK_ProductModelProductDescription_ProductDescription_ProductDescriptionID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing ProductModel.ProductModelID.', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductModelProductDescription', 'CONSTRAINT', N'FK_ProductModelProductDescription_ProductModel_ProductModelID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductModelProductDescription', 'CONSTRAINT', N'PK_ProductModelProductDescription_ProductModelID_ProductDescriptionID_Culture'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductModelProductDescription', 'INDEX', N'PK_ProductModelProductDescription_ProductModelID_ProductDescriptionID_Culture'
GO
