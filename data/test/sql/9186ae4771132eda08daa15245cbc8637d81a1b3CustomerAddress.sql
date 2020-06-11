CREATE TABLE [customer].[CustomerAddress]
(
    [CustomerAddressId] INT IDENTITY (1,1)  NOT NULL 
,   [CustomerId]        INT                 NOT NULL
,   [AddressId]         INT                 NOT NULL
,   [IsPrimary]         BIT                 NOT NULL
,   CONSTRAINT [PK_CustomerAddress] PRIMARY KEY CLUSTERED ([CustomerAddressId])
,   CONSTRAINT [FK_CustomerAddress_Customer] FOREIGN KEY ([CustomerId]) REFERENCES [customer].[Customer](CustomerId)
,   CONSTRAINT [FK_CustomerAddress_Address] FOREIGN KEY ([AddressId]) REFERENCES [customer].[Address](AddressId)
)
