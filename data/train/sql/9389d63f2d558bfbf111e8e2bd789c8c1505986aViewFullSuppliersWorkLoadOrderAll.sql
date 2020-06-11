CREATE VIEW [dbo].[ViewFullSuppliersWorkLoadOrderAll]
AS
SELECT     dbo.ViewSupplierWorkLoadOrderAll.SupplierID, dbo.ViewSupplierWorkLoadOrderAll.InquiryNumbers, dbo.ViewSupplierWorkLoadOrderAll.PointsInquiry, 
                      dbo.ViewSupplierWorkLoadOrderAll.OrderQuotationPriceSum, dbo.ViewSupplierWorkLoadOrderAll.PointsValueSum, 
                      dbo.ViewSupplierWorkLoadOrderAll.PointsSum * 100 AS PointsSum, dbo.Suppliers.SupplierName, dbo.ViewSupplierWorkLoadOrderAll.BranchID
FROM         dbo.ViewSupplierWorkLoadOrderAll INNER JOIN
                      dbo.Suppliers ON dbo.ViewSupplierWorkLoadOrderAll.SupplierID = dbo.Suppliers.SupplierID
