if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ToolInactiveCustomersView]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop View [dbo].[ToolInactiveCustomersView]
GO

CREATE VIEW	[dbo].[ToolInactiveCustomersView] AS
	SELECT		GPAccountID AS [Customer ID],
				ReportDate AS [Report Date]
	FROM		ExtractAllRegionsView e
	INNER JOIN	GPCustomerView c
	ON			e.GPAccountID = c.CUSTNMBR
	GROUP BY	e.GPAccountID, e.ReportDate
	HAVING		MAX(INACTIVE)=1--This is done to eleminate duplicate customerID's 
	AND			MIN(INACTIVE)=1

GO

