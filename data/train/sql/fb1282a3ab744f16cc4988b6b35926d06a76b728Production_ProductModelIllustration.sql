CREATE TABLE [Production].[ProductModelIllustration] (
  [ProductModelID] [int] NOT NULL,
  [IllustrationID] [int] NOT NULL,
  [ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ProductModelIllustration_ModifiedDate] DEFAULT (getdate()),
  CONSTRAINT [PK_ProductModelIllustration_ProductModelID_IllustrationID] PRIMARY KEY CLUSTERED ([ProductModelID], [IllustrationID]),
  CONSTRAINT [FK_ProductModelIllustration_Illustration_IllustrationID] FOREIGN KEY ([IllustrationID]) REFERENCES [Production].[Illustration] ([IllustrationID]),
  CONSTRAINT [FK_ProductModelIllustration_ProductModel_ProductModelID] FOREIGN KEY ([ProductModelID]) REFERENCES [Production].[ProductModel] ([ProductModelID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Cross-reference table mapping product models and illustrations.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelIllustration'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Primary key. Foreign key to ProductModel.ProductModelID.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelIllustration', 'COLUMN', N'ProductModelID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Primary key. Foreign key to Illustration.IllustrationID.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelIllustration', 'COLUMN', N'IllustrationID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelIllustration', 'COLUMN', N'ModifiedDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelIllustration', 'INDEX', N'PK_ProductModelIllustration_ProductModelID_IllustrationID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'ProductModelIllustration', 'CONSTRAINT', N'PK_ProductModelIllustration_ProductModelID_IllustrationID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Illustration.IllustrationID.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelIllustration', 'CONSTRAINT', N'FK_ProductModelIllustration_Illustration_IllustrationID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing ProductModel.ProductModelID.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelIllustration', 'CONSTRAINT', N'FK_ProductModelIllustration_ProductModel_ProductModelID'
GO