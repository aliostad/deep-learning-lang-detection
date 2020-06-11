
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[GMR].[ReportParameterShowMRISourceForPayrollReplication]') AND type in (N'V'))  
DROP VIEW [GMR].[ReportParameterShowMRISourceForPayrollReplication]  

SET ANSI_NULLS ON 
GO  

SET QUOTED_IDENTIFIER ON 
GO  

CREATE VIEW [GMR].[ReportParameterShowMRISourceForPayrollReplication] WITH SCHEMABINDING 

AS  

SELECT  
	ReportParameterShowMRISourceForPayroll.ReportParameterShowMRISourceForPayrollId,
	ReportParameterShowMRISourceForPayroll.ReportId, 
	ReportParameterShowMRISourceForPayroll.ShowMRISourceForPayroll,
	ReportParameterShowMRISourceForPayroll.[Version],  
	ReportParameterShowMRISourceForPayroll.InsertedDate,  
	ReportParameterShowMRISourceForPayroll.UpdatedDate,   
	ReportParameterShowMRISourceForPayroll.UpdatedByStaffId
FROM  
	dbo.ReportParameterShowMRISourceForPayroll ReportParameterShowMRISourceForPayroll   
	
GO 