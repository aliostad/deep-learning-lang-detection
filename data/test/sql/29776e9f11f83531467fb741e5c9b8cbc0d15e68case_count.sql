select 	case grp_id
	  when '01' then 'newGroup_01'
	  when '02' then 'newGroup_02'
	  when '03' then 'newGroup_02'
	else 'otherGroup' end as new_group
	,count(emp_id)
from emp_grp
group by case grp_id
 	  when '01' then 'newGroup_01'
 	  when '02' then 'newGroup_02'
	  when '03' then 'newGroup_02'
	 else 'otherGroup' end
;

--以下別解
/*
select 	case grp_id
	  when '01' then 'newGroup_01'
	  when '02' then 'newGroup_02'
	  when '03' then 'newGroup_02'
	else 'otherGroup' end as new_group
	,count(emp_id)
from emp_grp
group by new_group
;
*/

