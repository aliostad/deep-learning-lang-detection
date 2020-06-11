DELETE ACCOUNT_QUALIFICATION_GROUPS;

INSERT INTO account_qualification_groups
 (account_qualification_group, row_num, 
 include, include_filter, source_field, target_field, output_field, append_to_list,
 filter)
 VALUES('owner',1,
 'T_AV_AREAKEY',NULL,NULL,NULL,NULL,NULL,
 'OBJECT.c_area == "OWNER"');

INSERT INTO account_qualification_groups
 (account_qualification_group, row_num, 
 include, include_filter, source_field, target_field, output_field, append_to_list,
 filter)
 VALUES('account',1,
 'T_AV_AREAKEY',NULL,NULL,NULL,NULL,NULL,
 'OBJECT.c_area == "ACCOUNT"');

INSERT INTO account_qualification_groups
 (account_qualification_group, row_num, 
 include, include_filter, source_field, target_field, output_field, append_to_list,
 filter)
 VALUES('account_owners',1,
 'T_AV_AREAKEY',NULL,NULL,NULL,NULL,NULL,
 'OBJECT.c_area == "ACCOUNT"');

INSERT INTO account_qualification_groups
 (account_qualification_group, row_num, 
 include, include_filter, source_field, target_field, output_field, append_to_list,
 filter)
 VALUES('account_owners',2,
 'T_ACCOUNT_ANCESTOR','num_generations = 1',NULL,'id_ancestor','id_descendent','yes',
 NULL);

INSERT INTO account_qualification_groups
 (account_qualification_group, row_num, 
 include, include_filter, source_field, target_field, output_field, append_to_list,
 filter)
 VALUES('wholesaler_owners',1,
 'T_IC_RESELLERS',NULL,NULL,'id_partnerowner','id_office','yes',
 NULL);

INSERT INTO account_qualification_groups
 (account_qualification_group, row_num, 
 include, include_filter, source_field, target_field, output_field, append_to_list,
 filter)
 VALUES('wholesaler_owners',2,
 'T_ACCOUNT_ANCESTOR',NULL,NULL,'id_ancestor','id_descendent','yes',
 NULL);
