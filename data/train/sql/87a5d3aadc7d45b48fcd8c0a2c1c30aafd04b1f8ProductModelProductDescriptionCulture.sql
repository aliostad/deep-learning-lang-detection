/****** Object:  Table [Production].[ProductModelProductDescriptionCulture]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [Production].[ProductModelProductDescriptionCulture](
	[ProductModelID] [int] NOT NULL,
	[ProductDescriptionID] [int] NOT NULL,
	[CultureID] [nchar](6) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ProductModelProductDescriptionCulture_ModifiedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_ProductModelProductDescriptionCulture_ProductModelID_ProductDescriptionID_CultureID] PRIMARY KEY CLUSTERED 
(
	[ProductModelID] ASC,
	[ProductDescriptionID] ASC,
	[CultureID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [Production].[ProductModelProductDescriptionCulture]  WITH CHECK ADD  CONSTRAINT [FK_ProductModelProductDescriptionCulture_Culture_CultureID] FOREIGN KEY([CultureID])
REFERENCES [Production].[Culture] ([CultureID])
ALTER TABLE [Production].[ProductModelProductDescriptionCulture] CHECK CONSTRAINT [FK_ProductModelProductDescriptionCulture_Culture_CultureID]
ALTER TABLE [Production].[ProductModelProductDescriptionCulture]  WITH CHECK ADD  CONSTRAINT [FK_ProductModelProductDescriptionCulture_ProductDescription_ProductDescriptionID] FOREIGN KEY([ProductDescriptionID])
REFERENCES [Production].[ProductDescription] ([ProductDescriptionID])
ALTER TABLE [Production].[ProductModelProductDescriptionCulture] CHECK CONSTRAINT [FK_ProductModelProductDescriptionCulture_ProductDescription_ProductDescriptionID]
ALTER TABLE [Production].[ProductModelProductDescriptionCulture]  WITH CHECK ADD  CONSTRAINT [FK_ProductModelProductDescriptionCulture_ProductModel_ProductModelID] FOREIGN KEY([ProductModelID])
REFERENCES [Production].[ProductModel] ([ProductModelID])
ALTER TABLE [Production].[ProductModelProductDescriptionCulture] CHECK CONSTRAINT [FK_ProductModelProductDescriptionCulture_ProductModel_ProductModelID]
