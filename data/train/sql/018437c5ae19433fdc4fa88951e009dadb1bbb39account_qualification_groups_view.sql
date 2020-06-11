/*
drop view account_qualification_groups;
*/
create view account_qualification_groups
as
select
a.c_Name as account_qualification_group,
b.c_ExecutionSequence as row_num,
b.c_Include as include,
b.c_IncludeFilter as include_filter,
b.c_SourceField as source_field,
b.c_MatchField as target_field,
b.c_OutputField as output_field,
NULL as append_to_list,
b.c_Filter as filter
from t_be_mvm_ade_accountqualgro a
left outer join t_be_mvm_ade_accountqualifi b on a.c_AccountQualGroup_Id = b.c_AccountQualGroup_Id
;
/*
 (
account_qualification_group VARCHAR2(100),
row_num NUMBER,
include VARCHAR2(1000),
include_filter VARCHAR2(1000),
source_field VARCHAR2(1000),
target_field VARCHAR2(1000),
output_field VARCHAR2(1000),
append_to_list VARCHAR2(1000),
filter VARCHAR2(4000)
 );
*/
