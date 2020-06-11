ALTER TABLE [SalesLT].[ProductModelProductDescription]
    ADD CONSTRAINT [PK_ProductModelProductDescription_ProductModelID_ProductDescriptionID_Culture] PRIMARY KEY CLUSTERED ([ProductModelID] ASC, [ProductDescriptionID] ASC, [Culture] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key (clustered) constraint', @level0type = N'SCHEMA', @level0name = N'SalesLT', @level1type = N'TABLE', @level1name = N'ProductModelProductDescription', @level2type = N'CONSTRAINT', @level2name = N'PK_ProductModelProductDescription_ProductModelID_ProductDescriptionID_Culture';

