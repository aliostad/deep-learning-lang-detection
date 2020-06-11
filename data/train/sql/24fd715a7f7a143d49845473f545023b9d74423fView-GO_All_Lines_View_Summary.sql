IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[GO_All_Lines_View_Summary]'))
DROP VIEW [dbo].[GO_All_Lines_View_Summary]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[GO_All_Lines_View_Summary]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW dbo.GO_All_Lines_View_Summary
AS
SELECT     dbo.Latest_All_Lines_View_1.statecode, dbo.Latest_All_Lines_View_1.Coverage_Reporting_group, dbo.Latest_All_Lines_View_1.productcode, 
                      dbo.Latest_All_Lines_View_1.Fiscal_AY_Year, dbo.Latest_All_Lines_View_1.currentwrittenpremium, dbo.Latest_All_Lines_View_1.currentearnedpremium, 
                      dbo.Latest_All_Lines_View_1.Policy_count_Reporting_Coverage, dbo.Latest_All_Lines_View_1.Incurred_Loss_ALAE_with_SS_NonCat, 
                      dbo.Latest_All_Lines_View_1.Capped_Incurred_Loss_ALAE_with_SS_wo_cat, dbo.Latest_All_Lines_View_1.Ult_LDF_Incurred_Loss_ALAE_with_SS_NonCat, 
                      dbo.Latest_All_Lines_View_1.Ult_LDF_Capped_Incurred_Loss_ALAE_with_SS_wo_cat, dbo.Latest_All_Lines_View_1.Reported_Claims, 
                      dbo.Latest_All_Lines_View_1.Incurred_Claims, dbo.Latest_All_Lines_View_1.Price_Monitor_Standard_CovGrp_GL_Monitored_range, 
                      dbo.Latest_All_Lines_View_1.program, dbo.Latest_All_Lines_View_1.Written_Premium_Range, dbo.Latest_All_Lines_View_1.Coverage_Group, 
                      dbo.Latest_All_Lines_View_1.Product_group, dbo.Latest_All_Lines_View_1.Policy_count_All_Cov_Combined, 
                      dbo.Latest_All_Lines_View_1.Policy_count_Coverage_Group, dbo.Latest_All_Lines_View_1.accountnumber, 
                      dbo.Latest_All_Lines_View_1.Incurred_Loss_ALAE_with_SS, dbo.Latest_All_Lines_View_1.Capped_Incurred_Loss_ALAE_with_SS, 
                      dbo.Latest_All_Lines_View_1.Ult_LDF_Incurred_Loss_ALAE_with_SS, dbo.Latest_All_Lines_View_1.Ult_LDF_Capped_Inc_Loss_ALAE_with_SS, 
                      dbo.Latest_All_Lines_View_1.GL_Aggregate_Limit, dbo.Latest_All_Lines_View_1.GL_Deductible, dbo.Latest_All_Lines_View_1.GL_Occurrence_Limit, 
                      dbo.Latest_All_Lines_View_1.policynumber, dbo.Latest_All_Lines_View_1.Account_Name, dbo.Latest_All_Lines_View_1.Incurred_Loss_ALAE_with_SS_CatOnly, 
                      dbo.Latest_All_Lines_View_1.BusinessClassDesc, dbo.Latest_All_Lines_View_1.Fiscal_AY_Month_Ending, dbo.Latest_All_Lines_View_1.Last_Reporting_Year, 
                      dbo.Latest_All_Lines_View_1.Last_Reporting_Month, dbo.Latest_All_Lines_View_1.Price_Monitor_Standard_Cov_Grp_Monitored_range, 
                      dbo.Latest_All_Lines_View_1.CompanyCode, dbo.Latest_All_Lines_View_1.programdesc, dbo.Latest_All_Lines_View_1.Primary_Umbrella, 
                      dbo.Latest_All_Lines_View_1.Account_Premium_Range, dbo.Latest_All_Lines_View_1.producttype, 
                      dbo.Policy_Information_GL_AVG_RATES_October.Guides_Outfitters_Class_Group, dbo.Policy_Information_GL_AVG_RATES_October.Guides_Outfitters_Premium, 
                      dbo.Policy_Information_GL_AVG_RATES_October.Guides_Outfitters_Exposure, dbo.Policy_Information_GL_AVG_RATES_October.Guides_Outfitters_Exposure_Adj, 
                      dbo.Policy_Information_GL_AVG_RATES_October.Guides_Outfitters_Avg_Rate, dbo.Policy_Information_GL_AVG_RATES_October.Guides_Outfitters_Avg_Rate_Range, 
                      dbo.GL_Class_Code_Avg_Rate_ALL_POLICIES_October.Class_Code, dbo.GL_Class_Code_Avg_Rate_ALL_POLICIES_October.Exposure, 
                      dbo.GL_Class_Code_Avg_Rate_ALL_POLICIES_October.Exposure_Adj_Fac, dbo.GL_Class_Code_Avg_Rate_ALL_POLICIES_October.Exposure_Adj_Type, 
                      dbo.GL_Class_Code_Avg_Rate_ALL_POLICIES_October.Exposure_Base, dbo.GL_Class_Code_Avg_Rate_ALL_POLICIES_October.Class_Description
FROM         dbo.Latest_All_Lines_View_1 LEFT OUTER JOIN
                      dbo.GL_Class_Code_Avg_Rate_ALL_POLICIES_October ON 
                      dbo.Latest_All_Lines_View_1.policynumber = dbo.GL_Class_Code_Avg_Rate_ALL_POLICIES_October.Policy_Number LEFT OUTER JOIN
                      dbo.Policy_Information_GL_AVG_RATES_October ON 
                      dbo.Latest_All_Lines_View_1.policynumber = dbo.Policy_Information_GL_AVG_RATES_October.Policynumber
WHERE     (dbo.Latest_All_Lines_View_1.productcode = ''GO'')
' 
GO
