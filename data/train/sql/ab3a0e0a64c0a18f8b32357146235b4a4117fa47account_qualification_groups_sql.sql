if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[account_qualification_groups]'))
drop table [dbo].[account_qualification_groups]

create table account_qualification_groups (
account_qualification_group VARCHAR(100),
row_num INTEGER,
include VARCHAR(1000),
include_filter VARCHAR(1000),
source_field VARCHAR(1000),
target_field VARCHAR(1000),
output_field VARCHAR(1000),
append_to_list VARCHAR(1000),
filter VARCHAR(4000)
 );

 INSERT INTO account_qualification_groups
 (account_qualification_group, row_num, 
 include, include_filter, source_field, target_field, output_field, append_to_list,
 filter)
 VALUES('self',1,
 NULL,NULL,NULL,NULL,NULL,NULL,
 '1 == 1');
 
  INSERT INTO account_qualification_groups
 (account_qualification_group, row_num, 
 include, include_filter, source_field, target_field, output_field, append_to_list,
 filter)
 VALUES('self_owners',1,
 'T_AV_INTERNAL',NULL,NULL,NULL,NULL,NULL,
 NULL);
 
   INSERT INTO account_qualification_groups
 (account_qualification_group, row_num, 
 include, include_filter, source_field, target_field, output_field, append_to_list,
 filter)
 VALUES('self_owners',2,
 NULL,NULL,NULL,NULL,NULL,NULL,
 'OBJECT.c_invoicemethod == "1834"');
 
  INSERT INTO account_qualification_groups
 (account_qualification_group, row_num, 
 include, include_filter, source_field, target_field, output_field, append_to_list,
 filter)
 VALUES('child_owners',1,
 'T_ACCOUNT_ANCESTOR','num_generations != 0',NULL,'id_ancestor','id_descendent','yes',
 NULL);
 
    INSERT INTO account_qualification_groups
 (account_qualification_group, row_num, 
 include, include_filter, source_field, target_field, output_field, append_to_list,
 filter)
 VALUES('child_owners',2,
 'T_AV_INTERNAL',NULL,NULL,NULL,NULL,NULL,
 'OBJECT.c_invoicemethod ne "1834"');


 
     INSERT INTO account_qualification_groups
 (account_qualification_group, row_num, 
 include, include_filter, source_field, target_field, output_field, append_to_list,
 filter)
 VALUES('child_owners',3,
 NULL,NULL,NULL,NULL,NULL,NULL,
 'GROUP.self == "0" or GROUP.self == "0"');
 
   INSERT INTO account_qualification_groups
 (account_qualification_group, row_num, 
 include, include_filter, source_field, target_field, output_field, append_to_list,
 filter)
 VALUES('child_owners2',1,
 'T_ACCOUNT_ANCESTOR','num_generations != 0',NULL,'id_ancestor','id_descendent','no',
 NULL);
 
  INSERT INTO account_qualification_groups
 (account_qualification_group, row_num, 
 include, include_filter, source_field, target_field, output_field, append_to_list,
 filter)
 VALUES('child_owners2',2,
 NULL,NULL,NULL,NULL,NULL,NULL,
 'OBJECT.id_acc ne ''0''');

   INSERT INTO account_qualification_groups
 (account_qualification_group, row_num, 
 include, include_filter, source_field, target_field, output_field, append_to_list,
 filter)
 VALUES('jonah',1,
 'JONAH_ACC_MAPPING',NULL,NULL,'source_id_acc','target_id_acc','no',
 NULL);
