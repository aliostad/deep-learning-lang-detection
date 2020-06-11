IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Renewal_Plan_Premium_View_1]'))
DROP VIEW [dbo].[Renewal_Plan_Premium_View_1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Renewal_Plan_Premium_View_1]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW dbo.Renewal_Plan_Premium_View_1
AS
SELECT     dbo.Latest_All_Lines_View_1.productcode, dbo.Latest_All_Lines_View_1.Branch_Region, dbo.Latest_All_Lines_View_1.program, 
                      SUM(dbo.Latest_All_Lines_View_1.currentwrittenpremium) AS currentwrittenpremium, dbo.Latest_All_Lines_View_1.Fiscal_AY_Year, 
                      dbo.Latest_All_Lines_View_1.Renew_New_Auto, dbo.Latest_All_Lines_View_1.Primary_Producer, 
                      dbo.Latest_All_Lines_View_1.Primary_Producer_type, dbo.Latest_All_Lines_View_1.Account_Name, dbo.Latest_All_Lines_View_1.DivisionName, 
                      dbo.Latest_All_Lines_View_1.BusinessClassDesc, dbo.Latest_All_Lines_View_1.Source_Detail_Name, dbo.Latest_All_Lines_View_1.PIC_Producer, 
                      dbo.Latest_All_Lines_View_1.underwriter, dbo.Latest_All_Lines_View_1.Written_Premium_Range_for_Automatics, 
                      dbo.Latest_All_Lines_View_1.statecode, AccessPhlyEom.dbo.MktProductMix.prodMixName, AccessPhlyEom.dbo.MktProductMix.rptMixCode, 
                      dbo.Latest_All_Lines_View_1.ProductType, AccessPhlyEom.dbo.product.productdesc
FROM         dbo.Latest_All_Lines_View_1 INNER JOIN
                      AccessPhlyEom.dbo.product ON dbo.Latest_All_Lines_View_1.productcode = AccessPhlyEom.dbo.product.productcode LEFT OUTER JOIN
                      AccessPhlyEom.dbo.MktProductMix ON dbo.Latest_All_Lines_View_1.productcode = AccessPhlyEom.dbo.MktProductMix.productMix
GROUP BY dbo.Latest_All_Lines_View_1.productcode, dbo.Latest_All_Lines_View_1.Branch_Region, dbo.Latest_All_Lines_View_1.program, 
                      dbo.Latest_All_Lines_View_1.Fiscal_AY_Year, dbo.Latest_All_Lines_View_1.Renew_New_Auto, dbo.Latest_All_Lines_View_1.Primary_Producer, 
                      dbo.Latest_All_Lines_View_1.Primary_Producer_type, dbo.Latest_All_Lines_View_1.Account_Name, dbo.Latest_All_Lines_View_1.DivisionName, 
                      dbo.Latest_All_Lines_View_1.BusinessClassDesc, dbo.Latest_All_Lines_View_1.Source_Detail_Name, dbo.Latest_All_Lines_View_1.PIC_Producer, 
                      dbo.Latest_All_Lines_View_1.underwriter, dbo.Latest_All_Lines_View_1.Written_Premium_Range_for_Automatics, 
                      dbo.Latest_All_Lines_View_1.statecode, AccessPhlyEom.dbo.MktProductMix.prodMixName, AccessPhlyEom.dbo.MktProductMix.rptMixCode, 
                      dbo.Latest_All_Lines_View_1.ProductType, AccessPhlyEom.dbo.product.productdesc
HAVING      (dbo.Latest_All_Lines_View_1.Fiscal_AY_Year = 2010)
' 
GO
