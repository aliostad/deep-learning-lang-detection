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
ALTER TABLE [Production].[ProductModelProductDescriptionCulture]
	ADD
	CONSTRAINT [DF_ProductModelProductDescriptionCulture_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [Production].[ProductModelProductDescriptionCulture]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductModelProductDescriptionCulture_Culture_CultureID]
	FOREIGN KEY ([CultureID]) REFERENCES [Production].[Culture] ([CultureID])
ALTER TABLE [Production].[ProductModelProductDescriptionCulture]
	CHECK CONSTRAINT [FK_ProductModelProductDescriptionCulture_Culture_CultureID]

GO
ALTER TABLE [Production].[ProductModelProductDescriptionCulture]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductModelProductDescriptionCulture_ProductDescription_ProductDescriptionID]
	FOREIGN KEY ([ProductDescriptionID]) REFERENCES [Production].[ProductDescription] ([ProductDescriptionID])
ALTER TABLE [Production].[ProductModelProductDescriptionCulture]
	CHECK CONSTRAINT [FK_ProductModelProductDescriptionCulture_ProductDescription_ProductDescriptionID]

GO
ALTER TABLE [Production].[ProductModelProductDescriptionCulture]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductModelProductDescriptionCulture_ProductModel_ProductModelID]
	FOREIGN KEY ([ProductModelID]) REFERENCES [Production].[ProductModel] ([ProductModelID])
ALTER TABLE [Production].[ProductModelProductDescriptionCulture]
	CHECK CONSTRAINT [FK_ProductModelProductDescriptionCulture_ProductModel_ProductModelID]

GO
ALTER TABLE [Production].[ProductModelProductDescriptionCulture] SET (LOCK_ESCALATION = TABLE)
GO
