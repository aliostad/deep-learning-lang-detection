CREATE VIEW [dbo].[ViewSupplierWorkLoadFull]
AS
SELECT     dbo.ViewSupplierWorkLoad.SupplierID, dbo.ViewSupplierWorkLoad.InquiryType, dbo.ViewSupplierWorkLoad.InquiryNumbers, 
                      dbo.ViewSupplierWorkLoad.PointsInquiry, dbo.ViewSupplierWorkLoad.InquiryQuotationPriceSum, dbo.ViewSupplierWorkLoad.PointsValueSum, 
                      dbo.ViewSupplierWorkLoad.PointsSum * 100 AS PointsSum, dbo.Suppliers.SupplierName AS Name, dbo.ViewSupplierWorkLoad.BranchID
FROM         dbo.ViewSupplierWorkLoad INNER JOIN
                      dbo.Suppliers ON dbo.ViewSupplierWorkLoad.SupplierID = dbo.Suppliers.SupplierID
