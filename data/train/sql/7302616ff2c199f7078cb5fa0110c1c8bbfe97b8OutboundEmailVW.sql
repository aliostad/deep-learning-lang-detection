if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OutboundEmailVW]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop View [dbo].[OutboundEmailVW]
GO

/*
--Original View Definition
create  View [dbo].[OutboundEmailVW] AS 
select *
from LogDB.dbo.OutboundEmail
*/


--******************
--** Conditionally create view to point to either ASIA DB or US DB
--******************
declare @viewDecl varchar(8000)
set @viewDecl = 'create  View [dbo].[OutboundEmailVW] AS select * from ' + dbo.fGetLogDBTable('OutboundEmail')

if ( @viewDecl is not null)
	exec (@viewDecl )
else
	raiserror ('Failed to install: [dbo].[OutboundEmailVW]', 16, 1)

GO
