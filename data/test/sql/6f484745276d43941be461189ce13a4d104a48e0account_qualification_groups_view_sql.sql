create or replace view account_qualification_groups
        as
        select
        a.c_Name as account_qualification_group,
        b.c_ExecutionSequence as row_num,
        b.c_Include as include,
        b.c_IncludeFilter as include_filter,
        b.c_SourceField as source_field,
        b.c_MatchField as target_field,
        b.c_OutputField as output_field,
        b.c_AppendRows as append_to_list,
        b.c_Filter as filter
        from t_amp_accountqualgro a
        left outer join t_amp_accountqualifi b on a.c_AccountQualGroup_Id = b.c_AccountQualGroup_Id
