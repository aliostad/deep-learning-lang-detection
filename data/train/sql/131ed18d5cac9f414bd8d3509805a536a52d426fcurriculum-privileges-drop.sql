-- packages/curriculum/sql/postgresql/curriculum-privileges-drop.sql
--
-- @author Ola Hansson (ola@polyxena.net)
-- @creation-date 2003-05-23
-- @cvs-id $Id$

-- remove children
select acs_privilege__remove_child(''read'',''curriculum_read'');
select acs_privilege__remove_child(''create'',''curriculum_create'');
select acs_privilege__remove_child(''write'',''curriculum_write'');
select acs_privilege__remove_child(''delete'',''curriculum_delete'');
select acs_privilege__remove_child(''admin'',''curriculum_admin'');
select acs_privilege__remove_child(''curriculum_admin'',''curriculum_read'');
select acs_privilege__remove_child(''curriculum_write'',''curriculum_read'');
    
select acs_privilege__drop_privilege(''curriculum_admin'');
select acs_privilege__drop_privilege(''curriculum_read'');
select acs_privilege__drop_privilege(''curriculum_create'');
select acs_privilege__drop_privilege(''curriculum_write'');
select acs_privilege__drop_privilege(''curriculum_delete'');
