if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AdminVW]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop View [dbo].[AdminVW]
GO

/*
--Original View Definition
create  View [dbo].[AdminVW] AS 
select *
from yellowstone.admin.dbo.login
*/


--******************
--** Conditionally create view to point to either ASIA DB or US DB or EU DB
--******************
declare @viewDecl varchar(8000)
set @viewDecl = 'create  View [dbo].[AdminVW] AS select * from ' + dbo.fGetAdminDBTable()

if ( @viewDecl is not null)
	exec (@viewDecl )
else
	raiserror ('Failed to install: [dbo].[AdminVW]', 16, 1)

GO
