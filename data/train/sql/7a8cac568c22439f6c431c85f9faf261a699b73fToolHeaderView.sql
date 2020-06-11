if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ToolHeaderView]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop View [dbo].[ToolHeaderView]
GO


CREATE VIEW	[dbo].[ToolHeaderView] AS
SELECT		DISTINCT
			[Report Date],
			[DBASE],
			[Customer ID],
			[Customer Class],
			[Currency ID],
			[Payment Method],
			[Comment ID],
			[SOP],
			[Batch ID]

FROM		ExtractCompositeView e
LEFT JOIN	CustomersToBeSkippedView c
ON			e.[Customer ID] = c.CustomerID 
AND			e.[Report Date] = c.ReportDate
WHERE		e.[Inactive]=0
AND			c.CustomerID IS NULL

GO
