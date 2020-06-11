CREATE TABLE [Production].[ProductModelIllustration] (
		[ProductModelID]     [int] NOT NULL,
		[IllustrationID]     [int] NOT NULL,
		[ModifiedDate]       [datetime] NOT NULL,
		CONSTRAINT [PK_ProductModelIllustration_ProductModelID_IllustrationID]
		PRIMARY KEY
		CLUSTERED
		([ProductModelID], [IllustrationID])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Production].[ProductModelIllustration]
	ADD
	CONSTRAINT [DF_ProductModelIllustration_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [Production].[ProductModelIllustration]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductModelIllustration_Illustration_IllustrationID]
	FOREIGN KEY ([IllustrationID]) REFERENCES [Production].[Illustration] ([IllustrationID])
ALTER TABLE [Production].[ProductModelIllustration]
	CHECK CONSTRAINT [FK_ProductModelIllustration_Illustration_IllustrationID]

GO
ALTER TABLE [Production].[ProductModelIllustration]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductModelIllustration_ProductModel_ProductModelID]
	FOREIGN KEY ([ProductModelID]) REFERENCES [Production].[ProductModel] ([ProductModelID])
ALTER TABLE [Production].[ProductModelIllustration]
	CHECK CONSTRAINT [FK_ProductModelIllustration_ProductModel_ProductModelID]

GO
ALTER TABLE [Production].[ProductModelIllustration] SET (LOCK_ESCALATION = TABLE)
GO
