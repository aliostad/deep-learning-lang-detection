ALTER TABLE [SalesLT].[CustomerAddress]
    ADD CONSTRAINT [FK_CustomerAddress_Customer_CustomerID] FOREIGN KEY ([CustomerID]) REFERENCES [SalesLT].[Customer] ([CustomerID]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Foreign key constraint referencing Customer.CustomerID.', @level0type = N'SCHEMA', @level0name = N'SalesLT', @level1type = N'TABLE', @level1name = N'CustomerAddress', @level2type = N'CONSTRAINT', @level2name = N'FK_CustomerAddress_Customer_CustomerID';

