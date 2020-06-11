IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[AE_SPSS_Data_Step_3_View_1]'))
DROP VIEW [dbo].[AE_SPSS_Data_Step_3_View_1]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[AE_SPSS_Data_Step_3_View_1]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW dbo.AE_SPSS_Data_Step_3_View_1
AS
SELECT     dbo.AE_SPSS_Data_Step_1_View_1.statecode, dbo.AE_SPSS_Data_Step_1_View_1.Renew_New_Auto, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Branch_Region, dbo.AE_SPSS_Data_Step_1_View_1.program, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Written_Premium_Range, dbo.AE_SPSS_Data_Step_1_View_1.Coverage_Group, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Primary_Producer, dbo.AE_SPSS_Data_Step_1_View_1.Primary_Producer_type, 
                      dbo.AE_SPSS_Data_Step_1_View_1.County_Pop_Density_Range, dbo.AE_SPSS_Data_Step_1_View_1.Clean_Warranty_Letter_Received_YN, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Price_Monitor_Standard_Cov_Grp_Monitored_range, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Engagement_Letters_YN, dbo.AE_SPSS_Data_Step_1_View_1.Supp_Claim_Form_Received_YN, 
                      dbo.AE_SPSS_Data_Step_1_View_1.No_Prior_Coverage_YN, dbo.AE_SPSS_Data_Step_1_View_1.Suits_For_Fees_YN, 
                      dbo.AE_SPSS_Data_Step_1_View_1.No_Qualified_Peer_Review_YN, dbo.AE_SPSS_Data_Step_1_View_1.Successful_Peer_Review_YN, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Prior_Coverage_YN, dbo.AE_SPSS_Data_Step_1_View_1.Attestation_Range, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Audit_Range, dbo.AE_SPSS_Data_Step_1_View_1.BookKeeping_Range, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Compilation_Range, dbo.AE_SPSS_Data_Step_1_View_1.Corporate_Financial_Planning_Range, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Corporate_Tax_Range, dbo.AE_SPSS_Data_Step_1_View_1.Data_Processing_Range, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Individual_Tax_Range, dbo.AE_SPSS_Data_Step_1_View_1.MAS_Services_Range, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Other_Assurance_Range, dbo.AE_SPSS_Data_Step_1_View_1.Personal_Financial_Planning_Range, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Review_Range, dbo.AE_SPSS_Data_Step_1_View_1.SEC_Work_Range, 
                      dbo.AE_SPSS_Data_Step_1_View_1.AE_Limit_Type_Trim, dbo.AE_SPSS_Data_Step_1_View_1.AE_Revenue_Per_Accountant_Range, 
                      dbo.AE_SPSS_Data_Step_1_View_1.AE_Limit_Trim, dbo.AE_SPSS_Data_Step_1_View_1.AE_Revenues_range, 
                      dbo.AE_SPSS_Data_Step_1_View_1.AE_Program_Type, dbo.AE_SPSS_Data_Step_1_View_1.AE_Years_Prior_to_Retro, 
                      dbo.AE_SPSS_Data_Step_1_View_1.AE_Num_of_Accountants_Range, dbo.AE_SPSS_Data_Step_1_View_1.AE_Accountant_Type, 
                      (CASE WHEN currentearnedpremium = 0 OR
                      currentearnedpremium IS NULL THEN 0 ELSE isnull(Incurred_loss_ALAE_with_SS_NonCat / currentearnedpremium, 0) END) AS Loss_Ratio, 
                      dbo.AE_SPSS_Data_Step_1_View_1.currentearnedpremium, 
                      dbo.AE_SPSS_Data_Step_1_View_1.currentearnedpremium / dbo.AE_SPSS_Data_Step_2_View_1.Total_EarnedPrem AS Earned_Weight, 
                      dbo.AE_SPSS_Data_Step_2_View_1.Total_EarnedPrem, dbo.AE_SPSS_Data_Step_1_View_1.Incurred_Loss_ALAE_with_SS_NonCat, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Capped_Incurred_Loss_ALAE_with_SS_wo_cat, dbo.AE_SPSS_Data_Step_1_View_1.Incurred_Claims
FROM         dbo.AE_SPSS_Data_Step_1_View_1 CROSS JOIN
                      dbo.AE_SPSS_Data_Step_2_View_1
WHERE     (dbo.AE_SPSS_Data_Step_1_View_1.currentearnedpremium > 0)
GROUP BY dbo.AE_SPSS_Data_Step_1_View_1.statecode, dbo.AE_SPSS_Data_Step_1_View_1.Renew_New_Auto, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Branch_Region, dbo.AE_SPSS_Data_Step_1_View_1.program, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Written_Premium_Range, dbo.AE_SPSS_Data_Step_1_View_1.Coverage_Group, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Primary_Producer, dbo.AE_SPSS_Data_Step_1_View_1.Primary_Producer_type, 
                      dbo.AE_SPSS_Data_Step_1_View_1.County_Pop_Density_Range, dbo.AE_SPSS_Data_Step_1_View_1.Clean_Warranty_Letter_Received_YN, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Price_Monitor_Standard_Cov_Grp_Monitored_range, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Engagement_Letters_YN, dbo.AE_SPSS_Data_Step_1_View_1.Supp_Claim_Form_Received_YN, 
                      dbo.AE_SPSS_Data_Step_1_View_1.No_Prior_Coverage_YN, dbo.AE_SPSS_Data_Step_1_View_1.Suits_For_Fees_YN, 
                      dbo.AE_SPSS_Data_Step_1_View_1.No_Qualified_Peer_Review_YN, dbo.AE_SPSS_Data_Step_1_View_1.Successful_Peer_Review_YN, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Prior_Coverage_YN, dbo.AE_SPSS_Data_Step_1_View_1.Attestation_Range, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Audit_Range, dbo.AE_SPSS_Data_Step_1_View_1.BookKeeping_Range, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Compilation_Range, dbo.AE_SPSS_Data_Step_1_View_1.Corporate_Financial_Planning_Range, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Corporate_Tax_Range, dbo.AE_SPSS_Data_Step_1_View_1.Data_Processing_Range, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Individual_Tax_Range, dbo.AE_SPSS_Data_Step_1_View_1.MAS_Services_Range, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Other_Assurance_Range, dbo.AE_SPSS_Data_Step_1_View_1.Personal_Financial_Planning_Range, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Review_Range, dbo.AE_SPSS_Data_Step_1_View_1.SEC_Work_Range, 
                      dbo.AE_SPSS_Data_Step_1_View_1.AE_Limit_Type_Trim, dbo.AE_SPSS_Data_Step_1_View_1.AE_Revenue_Per_Accountant_Range, 
                      dbo.AE_SPSS_Data_Step_1_View_1.AE_Limit_Trim, dbo.AE_SPSS_Data_Step_1_View_1.AE_Revenues_range, 
                      dbo.AE_SPSS_Data_Step_1_View_1.AE_Program_Type, dbo.AE_SPSS_Data_Step_1_View_1.AE_Years_Prior_to_Retro, 
                      dbo.AE_SPSS_Data_Step_1_View_1.AE_Num_of_Accountants_Range, dbo.AE_SPSS_Data_Step_1_View_1.AE_Accountant_Type, 
                      dbo.AE_SPSS_Data_Step_2_View_1.Total_EarnedPrem, dbo.AE_SPSS_Data_Step_1_View_1.currentearnedpremium, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Incurred_Loss_ALAE_with_SS_NonCat, 
                      dbo.AE_SPSS_Data_Step_1_View_1.Capped_Incurred_Loss_ALAE_with_SS_wo_cat, dbo.AE_SPSS_Data_Step_1_View_1.Incurred_Claims
' 
GO
