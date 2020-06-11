SELECT DateTime('now'),'create.berlin_segments_db.sql [begin] -with "BEGIN" and "COMMIT"';
SELECT DateTime('now'),'sample: spatialite berlin_segments.db < create.berlin_segments_db.sql';
--- 
-- BEGIN/COMMIT done in script
.read ../source_sql/segments.berlin_admin_tables.sql UTF8
---
--- 
-- BEGIN/COMMIT done in script
-- importing older format berlin_ortsteil_segments into new format berlin_ortsteil_segments
-- .read ../source_sql/import_berlin_ortsteil_segmente.sql UTF8
-- importing and rebuilding geometries of  berlin_ortsteil_segments
.read ../source_sql/segments.import_berlin_segments.sql UTF8
---
-- BEGIN/COMMIT done in script
.read ../source_sql/segments.create_segments_spatialviews.sql UTF8
-- BEGIN/COMMIT done in script
.read ../source_sql/segments.build_geometries.sql UTF8
.read ../source_sql/segments.create_geometries_spatialviews.sql UTF8
-- SELECT * FROM berlin_geometries WHERE soldner_polygon IS NULL AND soldner_segments IS NOT NULL;
SELECT DateTime('now'),'Updating Statistics';
SELECT UpdateLayerStatistics();
--- 
-- BEGIN/COMMIT done in script
-- .read create_berlin_segments_views_db UTF8;
---
SELECT DateTime('now'),'berlin_ortsteil_segments [testing]';
SELECT DISTINCT Srid(soldner_segment) FROM berlin_ortsteil_segments;
SELECT DISTINCT GeometryType(soldner_segment) FROM berlin_ortsteil_segments;
SELECT * FROM berlin_ortsteil_segments WHERE GeometryType(soldner_segment) <> 'LINESTRING';
SELECT DateTime('now'),'berlin_ortsteil_segments [finished]';
SELECT DateTime('now'),'VACUUM';
-- VACUUM;
SELECT DateTime('now'),'create.berlin_segments_db.sql [finished] [Habe fertig!]';

