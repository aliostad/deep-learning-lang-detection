set identity_insert LogNoShowDisputes on
go

insert into LogNoShowDisputes (
	LogNoShowDisputeID,
	ResID,
	DisputeDate,
	Message,
	Reason,
	Resolved,
	UserID,
	IsCaller  )

select DisputeID,
	ReservationID,
	DisputeDate,
	Message,
	Reason,
	Resolved,
	UserID,
	IsCaller  
from Opentable.dbo.LogNoShowDisputes
GO

set identity_insert LogNoShowDisputes off
go

	

select cast(count(*) as varchar) + ' Source rows from Opentable.dbo.LogNoShowDisputes pumped to '
+ cast((select count(*) from WebDB.dbo.LogNoShowDisputes) as varchar) + ' Destination rows in LogNoShowDisputes' 
from Opentable.dbo.LogNoShowDisputes
go


