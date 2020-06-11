-- This needs to be run after every change to a view.
-- everything in the user search_path needs to be here except '$user'
grant select on all tables in schema vertex to                          vertex_read_only_view_role;
grant select on all tables in schema vertex_materialized to             vertex_read_only_view_role;
grant select on all tables in schema vertex_verse_materialized to       vertex_read_only_view_role;
grant select on all tables in schema vertex_materialized_reference to   vertex_read_only_view_role;
grant select on all tables in schema ods_kiva to                        vertex_read_only_view_role;
grant select on all tables in schema ods_kiva_live to                   vertex_read_only_view_role;
grant select on all tables in schema verse to                           vertex_read_only_view_role;
grant select on all tables in schema verse_live to                      vertex_read_only_view_role;
grant select on all tables in schema verse_reference to                 vertex_read_only_view_role;

grant all on all tables in schema ods_kiva to vertex with grant option;
grant all on all tables in schema ods_kiva_live to vertex with grant option;
grant all on all tables in schema verse to vertex with grant option;
grant all on all tables in schema verse_live to vertex with grant option;