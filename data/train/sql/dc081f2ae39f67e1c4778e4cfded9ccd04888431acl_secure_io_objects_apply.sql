--invoked in ./initdb.sql
--alter table io_objects rename to tbl_io_objects;
--alter sequence io_objects_id_seq rename to tbl_io_objects_id_seq;
grant all on tbl_io_objects_id_seq to public;

create or replace view io_objects as select * from f_sel_io_objects(NULL);

revoke all on tbl_io_objects from public;

grant all on io_objects to public;


create or replace rule "r_ins_io_objects" as on insert to "io_objects" do instead 
select "f_ins_io_objects" (new."unique_id", 
                           new."last_update", 
                           new."id", 
                           new."id_io_category", 
                           new."id_io_state", 
                           new."id_maclabel", 
                           new."author", 
                           new."id_sync_type", 
                           new."id_owner_org", 
                           new."name", 
                           new."table_name", 
                           new."description", 
                           new."information", 
                           new."is_system", 
                           new."insert_time", 
                           new."is_completed", 
                           new."is_global", 
                           new."record_fill_color", 
                           new."record_text_color", 
                           new."id_search_template", 
                           new."ref_table_name",
                           new."id_io_type",
                           new."r_icon",
                           new."uuid_t");


create or replace rule "r_del_io_objects" as on delete to "io_objects" do instead select "f_del_io_objects"(old.id);


create or replace rule "r_upd_io_objects" as on update to "io_objects" do instead 
select "f_upd_io_objects" (new."unique_id", 
                           new."last_update", 
                           new."id", 
                           new."id_io_category", 
                           new."id_io_state", 
                           new."id_maclabel", 
                           new."author", 
                           new."id_sync_type", 
                           new."id_owner_org", 
                           new."name", 
                           new."table_name", 
                           new."description", 
                           new."information", 
                           new."is_system", 
                           new."insert_time", 
                           new."is_completed", 
                           new."is_global", 
                           new."record_fill_color", 
                           new."record_text_color", 
                           new."id_search_template", 
                           new."ref_table_name",
                           new."id_io_type",
                           new."r_icon",
                           new."uuid_t");
