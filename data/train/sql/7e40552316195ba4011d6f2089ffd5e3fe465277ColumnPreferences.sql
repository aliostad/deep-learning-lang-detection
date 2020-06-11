CREATE TABLE [dbo].[ColumnPreferences] (
    [Id]                      VARCHAR (10) NOT NULL,
    [ShowRequestNumber]       BIT          DEFAULT ((1)) NOT NULL,
    [ShowRequestType]         BIT          DEFAULT ((0)) NOT NULL,
    [ShowWorkgroup]           BIT          DEFAULT ((1)) NOT NULL,
    [ShowVendor]              BIT          DEFAULT ((1)) NOT NULL,
    [ShowCreatedBy]           BIT          DEFAULT ((1)) NOT NULL,
    [ShowCreatedDate]         BIT          DEFAULT ((1)) NOT NULL,
    [ShowLineItems]           BIT          DEFAULT ((1)) NOT NULL,
    [ShowTotalAmount]         BIT          DEFAULT ((1)) NOT NULL,
    [ShowStatus]              BIT          DEFAULT ((1)) NOT NULL,
    [ShowApprover]            BIT          NOT NULL,
    [ShowAccountManager]      BIT          NOT NULL,
    [ShowPurchaser]           BIT          NOT NULL,
    [ShowAccountNumber]       BIT          NOT NULL,
    [ShowShipTo]              BIT          NOT NULL,
    [ShowAllowBackorder]      BIT          NOT NULL,
    [ShowRestrictedOrder]     BIT          NOT NULL,
    [ShowNeededDate]          BIT          NOT NULL,
    [ShowShippingType]        BIT          NOT NULL,
    [ShowPurchaseOrderNumber] BIT          NOT NULL,
    [ShowTag]                 BIT          DEFAULT ((0)) NOT NULL,
    [ShowLastActedOnDate]     BIT          NOT NULL,
    [ShowDaysNotActedOn]      BIT          NOT NULL,
    [ShowLastActedOnBy]       BIT          NOT NULL,
    [ShowOrderReceived]       BIT          DEFAULT ((0)) NOT NULL,
    [ShowOrderType]           BIT          NOT NULL,
    [DisplayRows]             INT          DEFAULT ((50)) NOT NULL,
    [ShowHasSplits]           BIT          DEFAULT ((0)) NOT NULL,
    [ShowShippingCost]        BIT          DEFAULT ((0)) NOT NULL,
    [ShowReferenceNumber]     BIT          DEFAULT ((1)) NOT NULL,
    [ShowFpdCompleted]        BIT          DEFAULT ((0)) NOT NULL,
    [ShowOrderPaid]           BIT          DEFAULT ((0)) NOT NULL,
    [ShowApUser]              BIT          DEFAULT ((0)) NOT NULL,
    [ShowPostStatus]          BIT          DEFAULT ((0)) NOT NULL,
    [ShowOrderNote]           BIT          DEFAULT ((0)) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);









GO
CREATE NONCLUSTERED INDEX [ColumnPreferences_UserId_IDX]
    ON [dbo].[ColumnPreferences]([Id] ASC) WITH (STATISTICS_NORECOMPUTE = ON);



