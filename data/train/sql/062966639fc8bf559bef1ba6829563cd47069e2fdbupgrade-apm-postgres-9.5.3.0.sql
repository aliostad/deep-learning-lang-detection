-- tim-as-software changes
alter table ts_monitors add column ts_port int NOT NULL DEFAULT 80;
alter table ts_monitors add column ts_https_port int NOT NULL DEFAULT 443;

ALTER TABLE ts_defects_interval  DROP CONSTRAINT FK6C189902545ADA6D;
ALTER TABLE ts_defects_interval  DROP CONSTRAINT FK6C189902F081AE66;

-- adding flag to tell if webview port is secure or not
alter table ts_introscope_ems add column ts_web_view_port_secure bool not null default false;
ALTER TABLE ts_usergroup_id_parameters ALTER COLUMN ts_name TYPE VARCHAR(2000);

-- the array accumulate function can be dropped here since we are going to use
-- array_agg which is built in much much much... faster than array_append
-- oracle will have its custom procedure renamed to array_agg so that we dont need
-- to write separate queries for both
drop aggregate if exists array_accumulate(integer);

insert into ts_report_param_keys (ts_id,ts_name,ts_query_string_name,ts_value_type,ts_default_value,ts_soft_delete, version_info) values (44,'sIncludedMovedOrDeleted','IncludedMovedOrDeleted','java.lang.String','',FALSE, 1);
insert into ts_report_type_param_values (ts_id,version_info,ts_param_key_id,ts_report_type_id,ts_value,ts_soft_delete) values (216,1,44,28,'0',false);
