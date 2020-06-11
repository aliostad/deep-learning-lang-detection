if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ErrorLogVW]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop View [dbo].[ErrorLogVW]
GO

/*
--Original View Definition
create  View [dbo].[ErrorLogVW] AS 
select *
from LogDB.dbo.ErrorLog
*/


--******************
--** Conditionally create view to point to either ASIA DB or US DB
--******************
declare @viewDecl varchar(8000)
set @viewDecl = 'create  View [dbo].[ErrorLogVW] AS select * from '+ dbo.fGetLogDBTable('ErrorLog')

if ( @viewDecl is not null)
	exec (@viewDecl )
else
	raiserror ('Failed to install: [dbo].[ErrorLogVW]', 16, 1)

GO
