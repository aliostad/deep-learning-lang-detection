SELECT DateTime('now'),'create.berlin_admin_db.sql [begin] -with "BEGIN" and "COMMIT"';
SELECT DateTime('now'),'sample: spatialite berlin_administration.db < ../source_sql/create.berlin_admin_db.sql';
--- 
-- BEGIN/COMMIT done in script
.read ../source_sql/admin.berlin_stadtteile_tables.sql UTF8
--- 
-- BEGIN/COMMIT done in script
.read ../source_sql/admin.berlin_ortsteile_tables.sql UTF8
-- the created data of this script [read_geodb_berlin_tables.sql] has been incorperated into ''create_berlin_ortsteile_tables.sql'' and should no longer be used.
-- .read ../source_sql/read_geodb_berlin_tables.sql UTF8
---
SELECT DateTime('now'),'Updating Statistics';
SELECT UpdateLayerStatistics();
SELECT DateTime('now'),'VACUUM';
VACUUM;
SELECT DateTime('now'),'create.berlin_admin_db.sql [finished] [Habe fertig!]';
