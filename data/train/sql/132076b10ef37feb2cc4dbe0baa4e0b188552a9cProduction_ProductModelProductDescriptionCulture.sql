CREATE TABLE [Production].[ProductModelProductDescriptionCulture] (
  [added] [int] NULL,
  [CultureID] [nchar](6) NOT NULL,
  [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ProductModelProductDescriptionCulture_ModifiedDate] DEFAULT (getdate()),
  [ProductDescriptionID] [int] NOT NULL,
  [ProductModelID] [int] NOT NULL,
  CONSTRAINT [PK_ProductModelProductDescriptionCulture_ProductModelID_ProductDescriptionID_CultureID] PRIMARY KEY CLUSTERED ([ProductModelID], [ProductDescriptionID], [CultureID]),
  CONSTRAINT [FK_ProductModelProductDescriptionCulture_Culture_CultureID] FOREIGN KEY ([cultureid]) REFERENCES [Production].[Culture] ([cultureid]),
  CONSTRAINT [FK_ProductModelProductDescriptionCulture_ProductDescription_ProductDescriptionID] FOREIGN KEY ([productdescriptionid]) REFERENCES [Production].[ProductDescription] ([productdescriptionid]),
  CONSTRAINT [FK_ProductModelProductDescriptionCulture_ProductModel_ProductModelID] FOREIGN KEY ([productmodelid]) REFERENCES [Production].[ProductModel] ([productmodelid])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Cross-reference table mapping product descriptions and the language the description is written in.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', 'INDEX', N'PK_ProductModelProductDescriptionCulture_ProductModelID_ProductDescriptionID_CultureID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', 'CONSTRAINT', N'PK_ProductModelProductDescriptionCulture_ProductModelID_ProductDescriptionID_CultureID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', 'CONSTRAINT', N'DF_ProductModelProductDescriptionCulture_ModifiedDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Culture.CultureID.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', 'CONSTRAINT', N'FK_ProductModelProductDescriptionCulture_Culture_CultureID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing ProductDescription.ProductDescriptionID.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', 'CONSTRAINT', N'FK_ProductModelProductDescriptionCulture_ProductDescription_ProductDescriptionID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing ProductModel.ProductModelID.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', 'CONSTRAINT', N'FK_ProductModelProductDescriptionCulture_ProductModel_ProductModelID'
GO














