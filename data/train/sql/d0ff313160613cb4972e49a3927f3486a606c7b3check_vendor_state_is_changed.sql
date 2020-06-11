CREATE PROCEDURE [dbo].[check_vendor_state_is_changed]
	@id int
	as begin

	if exists(select 1 
from vendor_states vs inner join vendor_states vs_old on vs.id=vs_old.old_id AND vs_old.id = (SELECT MAX(id) FROM vendor_states old WHERE old.old_id=@id)
where vs.id=@id AND (vs.id_vendor != vs_old.id_vendor or LTRIM(RTRIM(vs.descr))!=RTRIM(LTRIM(vs_old.descr)) 
or vs.date_end!=vs_old.date_end or vs.id_organization != vs_old.id_organization or vs.id_language!=vs_old.id_language or vs.pic_data!=vs_old.pic_data))
begin
select vs_old.*
from vendor_states vs inner join vendor_states vs_old on vs.id=vs_old.old_id AND vs_old.id = (SELECT MAX(id) FROM vendor_states old WHERE old.old_id=@id)
where vs.id=@id 
--AND vs.id_vendor = vs_old.id_vendor AND LTRIM(RTRIM(vs.descr))=RTRIM(LTRIM(vs_old.descr)) AND vs.date_end=vs_old.date_end AND vs.id_organization = vs_old.id_organization AND vs.id_langu
	
end
else begin
	select null
end
	end
