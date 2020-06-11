if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TraceLogVW]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop View [dbo].[TraceLogVW]
GO

/*
--Original View Definition
create  View [dbo].[TraceLogVW] AS 
select *
from LogDB.dbo.TraceLog
*/


--******************
--** Conditionally create view to point to either ASIA DB or US DB
--******************
declare @viewDecl varchar(8000)
set @viewDecl = 'create  View [dbo].[TraceLogVW] AS select * from '+ dbo.fGetLogDBTable('TraceLog')

if ( @viewDecl is not null)
	exec (@viewDecl )
else
	raiserror ('Failed to install: [dbo].[TraceLogVW]', 16, 1)

GO
