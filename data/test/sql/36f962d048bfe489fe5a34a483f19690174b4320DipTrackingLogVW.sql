if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DipTrackingLogVW]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop View [dbo].[DipTrackingLogVW]
GO

/*
--Original View Definition
create  View [dbo].[DipTrackingLogVW] AS 
select *
from LogDB.dbo.DipTrackingLog
*/


--******************
--** Conditionally create view to point to either ASIA DB or US DB
--******************
declare @viewDecl varchar(8000)
set @viewDecl = 'create  View [dbo].[DipTrackingLogVW] AS select * from '+ dbo.fGetLogDBTable('DipTrackingLog')

if ( @viewDecl is not null)
	exec (@viewDecl )
else
	raiserror ('Failed to install: [dbo].[DipTrackingLogVW]', 16, 1)

GO
