CREATE VIEW [dbo].[ViewCommissionPaymentParents]
AS
SELECT     dbo.ViewCommissions.InquiryNumber, dbo.ViewCommissions.ShotecNo, dbo.Orders.OrderNumber, dbo.Orders.CustomerOrderNumber, 
                      dbo.Orders.SupplierOrderNumber, dbo.Orders.OrderDate, dbo.Orders.RateToEuro, SUM(dbo.ViewCommissions.CommissionAmountInEuro) 
                      AS CommissionAmountInEuro, dbo.ViewCommissions.SupplierID, dbo.ViewCommissions.BranchID, dbo.ViewCommissions.CountryID, 
                      dbo.ViewCommissions.CompanyName AS ClientName, dbo.Currencies.CurrencyCode, dbo.ViewCommissions.Paid
FROM         dbo.ViewCommissions INNER JOIN
                      dbo.Orders ON dbo.ViewCommissions.InquiryNumber = dbo.Orders.InquiryNumber INNER JOIN
                      dbo.Currencies ON dbo.ViewCommissions.OrderCurrency = dbo.Currencies.ID
GROUP BY dbo.ViewCommissions.InquiryNumber, dbo.ViewCommissions.ShotecNo, dbo.Orders.OrderNumber, dbo.Orders.CustomerOrderNumber, 
                      dbo.Orders.SupplierOrderNumber, dbo.Orders.OrderDate, dbo.Orders.RateToEuro, dbo.ViewCommissions.SupplierID, dbo.ViewCommissions.BranchID, 
                      dbo.ViewCommissions.CountryID, dbo.ViewCommissions.CompanyName, dbo.Currencies.CurrencyCode, dbo.ViewCommissions.Paid
