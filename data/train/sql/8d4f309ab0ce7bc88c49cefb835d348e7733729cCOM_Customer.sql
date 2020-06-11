CREATE TABLE [COM_Customer] (
		[CustomerID]                            [int] IDENTITY(1, 1) NOT NULL,
		[CustomerFirstName]                     [nvarchar](200) NOT NULL,
		[CustomerLastName]                      [nvarchar](200) NOT NULL,
		[CustomerEmail]                         [nvarchar](200) NULL,
		[CustomerPhone]                         [nvarchar](50) NULL,
		[CustomerFax]                           [nvarchar](50) NULL,
		[CustomerCompany]                       [nvarchar](200) NULL,
		[CustomerUserID]                        [int] NULL,
		[CustomerPreferredCurrencyID]           [int] NULL,
		[CustomerPreferredShippingOptionID]     [int] NULL,
		[CustomerCountryID]                     [int] NULL,
		[CustomerEnabled]                       [bit] NOT NULL,
		[CustomerPrefferedPaymentOptionID]      [int] NULL,
		[CustomerStateID]                       [int] NULL,
		[CustomerGUID]                          [uniqueidentifier] NOT NULL,
		[CustomerTaxRegistrationID]             [nvarchar](50) NULL,
		[CustomerOrganizationID]                [nvarchar](50) NULL,
		[CustomerDiscountLevelID]               [int] NULL,
		[CustomerCreated]                       [datetime] NULL,
		[CustomerLastModified]                  [datetime] NOT NULL,
		[CustomerSiteID]                        [int] NULL
) 
ALTER TABLE [COM_Customer]
	ADD
	CONSTRAINT [PK_COM_Customer]
	PRIMARY KEY
	NONCLUSTERED
	([CustomerID])
	
	
ALTER TABLE [COM_Customer]
	ADD
	CONSTRAINT [DEFAULT_COM_Customer_CustomerGUID]
	DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [CustomerGUID]
CREATE NONCLUSTERED INDEX [IX_COM_Customer_CustomerCompany]
	ON [COM_Customer] ([CustomerCompany])
	
	
CREATE NONCLUSTERED INDEX [IX_COM_Customer_CustomerCountryID]
	ON [COM_Customer] ([CustomerCountryID])
	
CREATE NONCLUSTERED INDEX [IX_COM_Customer_CustomerDiscountLevelID]
	ON [COM_Customer] ([CustomerDiscountLevelID])
	
CREATE NONCLUSTERED INDEX [IX_COM_Customer_CustomerEmail]
	ON [COM_Customer] ([CustomerEmail])
	
	
CREATE CLUSTERED INDEX [IX_COM_Customer_CustomerLastName_CustomerFirstName_CustomerEnabled]
	ON [COM_Customer] ([CustomerLastName], [CustomerFirstName], [CustomerEnabled])
	
	
CREATE NONCLUSTERED INDEX [IX_COM_Customer_CustomerPreferredCurrencyID]
	ON [COM_Customer] ([CustomerPreferredCurrencyID])
	
CREATE NONCLUSTERED INDEX [IX_COM_Customer_CustomerPreferredShippingOptionID]
	ON [COM_Customer] ([CustomerPreferredShippingOptionID])
	
CREATE NONCLUSTERED INDEX [IX_COM_Customer_CustomerPrefferedPaymentOptionID]
	ON [COM_Customer] ([CustomerPrefferedPaymentOptionID])
	
CREATE NONCLUSTERED INDEX [IX_COM_Customer_CustomerStateID]
	ON [COM_Customer] ([CustomerStateID])
	
CREATE NONCLUSTERED INDEX [IX_COM_Customer_CustomerUserID]
	ON [COM_Customer] ([CustomerUserID])
	
ALTER TABLE [COM_Customer]
	WITH CHECK
	ADD CONSTRAINT [FK_COM_Customer_CustomerCountryID_CMS_Country]
	FOREIGN KEY ([CustomerCountryID]) REFERENCES [CMS_Country] ([CountryID])
ALTER TABLE [COM_Customer]
	CHECK CONSTRAINT [FK_COM_Customer_CustomerCountryID_CMS_Country]
ALTER TABLE [COM_Customer]
	WITH CHECK
	ADD CONSTRAINT [FK_COM_Customer_CustomerDiscountLevelID_COM_DiscountLevel]
	FOREIGN KEY ([CustomerDiscountLevelID]) REFERENCES [COM_DiscountLevel] ([DiscountLevelID])
ALTER TABLE [COM_Customer]
	CHECK CONSTRAINT [FK_COM_Customer_CustomerDiscountLevelID_COM_DiscountLevel]
ALTER TABLE [COM_Customer]
	WITH CHECK
	ADD CONSTRAINT [FK_COM_Customer_CustomerSiteID_CMS_Site]
	FOREIGN KEY ([CustomerSiteID]) REFERENCES [CMS_Site] ([SiteID])
ALTER TABLE [COM_Customer]
	CHECK CONSTRAINT [FK_COM_Customer_CustomerSiteID_CMS_Site]
ALTER TABLE [COM_Customer]
	WITH CHECK
	ADD CONSTRAINT [FK_COM_Customer_CustomerStateID_CMS_State]
	FOREIGN KEY ([CustomerStateID]) REFERENCES [CMS_State] ([StateID])
ALTER TABLE [COM_Customer]
	CHECK CONSTRAINT [FK_COM_Customer_CustomerStateID_CMS_State]
ALTER TABLE [COM_Customer]
	WITH CHECK
	ADD CONSTRAINT [FK_COM_Customer_CustomerUserID_CMS_User]
	FOREIGN KEY ([CustomerUserID]) REFERENCES [CMS_User] ([UserID])
ALTER TABLE [COM_Customer]
	CHECK CONSTRAINT [FK_COM_Customer_CustomerUserID_CMS_User]
