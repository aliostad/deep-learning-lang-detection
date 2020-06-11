SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Production].[ProductModelProductDescriptionCulture] (
		[ProductModelID]           [int] NOT NULL,
		[ProductDescriptionID]     [int] NOT NULL,
		[CultureID]                [nchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[ModifiedDate]             [datetime] NOT NULL,
		CONSTRAINT [PK_ProductModelProductDescriptionCulture_ProductModelID_ProductDescriptionID_CultureID]
		PRIMARY KEY
		CLUSTERED
		([ProductModelID], [ProductDescriptionID], [CultureID])
	ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', 'CONSTRAINT', N'PK_ProductModelProductDescriptionCulture_ProductModelID_ProductDescriptionID_CultureID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', 'INDEX', N'PK_ProductModelProductDescriptionCulture_ProductModelID_ProductDescriptionID_CultureID'
GO
ALTER TABLE [Production].[ProductModelProductDescriptionCulture]
	ADD
	CONSTRAINT [DF_ProductModelProductDescriptionCulture_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', 'CONSTRAINT', N'DF_ProductModelProductDescriptionCulture_ModifiedDate'
GO
ALTER TABLE [Production].[ProductModelProductDescriptionCulture]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductModelProductDescriptionCulture_Culture_CultureID]
	FOREIGN KEY ([CultureID]) REFERENCES [Production].[Culture] ([CultureID])
ALTER TABLE [Production].[ProductModelProductDescriptionCulture]
	CHECK CONSTRAINT [FK_ProductModelProductDescriptionCulture_Culture_CultureID]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Culture.CultureID.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', 'CONSTRAINT', N'FK_ProductModelProductDescriptionCulture_Culture_CultureID'
GO
ALTER TABLE [Production].[ProductModelProductDescriptionCulture]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductModelProductDescriptionCulture_ProductDescription_ProductDescriptionID]
	FOREIGN KEY ([ProductDescriptionID]) REFERENCES [Production].[ProductDescription] ([ProductDescriptionID])
ALTER TABLE [Production].[ProductModelProductDescriptionCulture]
	CHECK CONSTRAINT [FK_ProductModelProductDescriptionCulture_ProductDescription_ProductDescriptionID]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing ProductDescription.ProductDescriptionID.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', 'CONSTRAINT', N'FK_ProductModelProductDescriptionCulture_ProductDescription_ProductDescriptionID'
GO
ALTER TABLE [Production].[ProductModelProductDescriptionCulture]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductModelProductDescriptionCulture_ProductModel_ProductModelID]
	FOREIGN KEY ([ProductModelID]) REFERENCES [Production].[ProductModel] ([ProductModelID])
ALTER TABLE [Production].[ProductModelProductDescriptionCulture]
	CHECK CONSTRAINT [FK_ProductModelProductDescriptionCulture_ProductModel_ProductModelID]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing ProductModel.ProductModelID.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', 'CONSTRAINT', N'FK_ProductModelProductDescriptionCulture_ProductModel_ProductModelID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Culture identification number. Foreign key to Culture.CultureID.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', 'COLUMN', N'CultureID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Foreign key to ProductDescription.ProductDescriptionID.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', 'COLUMN', N'ProductDescriptionID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Foreign key to ProductModel.ProductModelID.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', 'COLUMN', N'ProductModelID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cross-reference table mapping product descriptions and the language the description is written in.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', NULL, NULL
GO
ALTER TABLE [Production].[ProductModelProductDescriptionCulture] SET (LOCK_ESCALATION = TABLE)
GO
