create proc [dbo].[spPST_MarkOldPostAsReadForAUser]

--declare 
		@entityId bigint

as

--set @entityId = -1

insert PST_ReadLog
select
	d.*
from (
	select 

		p.postId,
		e.entityId as readerEntityId,
		getdate() as readDate,
		1 as isCleared,
		getdate() as cleardate

	from PST_Master as p, ENT_Master as e
	where (p.active = 1) 
	  and ((e.entityId = @entityId) and (e.userId is not null and e.userId <> '' and e.active = 1) and ( e.entityId <> 7 and e.entityId <> 8 ) )
) as d
left join PST_ReadLog as rl on d.postId = rl.postId and d.readerEntityId = rl.readerEntityId
where rl.postReadId is null