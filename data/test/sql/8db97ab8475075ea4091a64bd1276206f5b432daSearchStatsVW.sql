if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SearchStatsVW]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop View [dbo].[SearchStatsVW]
GO

/*
--Original View Definition
create  View [dbo].[SearchStatsVW] AS 
select *
from LogDB.dbo.SearchStats
*/


--******************
--** Conditionally create view to point to either ASIA DB or US DB
--******************
declare @viewDecl varchar(8000)
set @viewDecl = 'create  View [dbo].[SearchStatsVW] AS select * from '+ dbo.fGetLogDBTable('SearchStats')

if ( @viewDecl is not null)
	exec (@viewDecl )
else
	raiserror ('Failed to install: [dbo].[SearchStatsVW]', 16, 1)

GO
