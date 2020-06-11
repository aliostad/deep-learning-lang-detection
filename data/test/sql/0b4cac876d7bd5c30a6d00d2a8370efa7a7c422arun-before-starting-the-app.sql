
-- Backup old tables
CREATE TABLE catalogue.old_categories AS SELECT * FROM catalogue.categories;
CREATE TABLE catalogue.old_categoriesdes AS SELECT * FROM catalogue.categoriesdes;
CREATE TABLE catalogue.old_groups AS SELECT * FROM catalogue.groups;
CREATE TABLE catalogue.old_groupsdes AS SELECT * FROM catalogue.groupsdes;
CREATE TABLE catalogue.old_isolanguages AS SELECT * FROM catalogue.isolanguages;
CREATE TABLE catalogue.old_isolanguagesdes AS SELECT * FROM catalogue.isolanguagesdes;
CREATE TABLE catalogue.old_languages AS SELECT * FROM catalogue.languages;
CREATE TABLE catalogue.old_metadata AS SELECT * FROM catalogue.metadata;
CREATE TABLE catalogue.old_metadatacateg AS SELECT * FROM catalogue.metadatacateg;
CREATE TABLE catalogue.old_metadatarating AS SELECT * FROM catalogue.metadatarating;
CREATE TABLE catalogue.old_operationallowed AS SELECT * FROM catalogue.operationallowed;
CREATE TABLE catalogue.old_operations AS SELECT * FROM catalogue.operations;
CREATE TABLE catalogue.old_operationsdes AS SELECT * FROM catalogue.operationsdes;
CREATE TABLE catalogue.old_regions AS SELECT * FROM catalogue.regions;
CREATE TABLE catalogue.old_regionsdes AS SELECT * FROM catalogue.regionsdes;
CREATE TABLE catalogue.old_relations AS SELECT * FROM catalogue.relations;
CREATE TABLE catalogue.old_settings AS SELECT * FROM catalogue.settings;
CREATE TABLE catalogue.old_sources AS SELECT * FROM catalogue.sources;
CREATE TABLE catalogue.old_usergroups AS SELECT * FROM catalogue.usergroups;
CREATE TABLE catalogue.old_users AS SELECT * FROM catalogue.users;


-- Drop old tables
DROP TABLE catalogue.categoriesdes;
DROP TABLE catalogue.metadatacateg;
DROP TABLE catalogue.categories;
DROP TABLE catalogue.groupsdes;
DROP TABLE catalogue.operationallowed;
DROP TABLE catalogue.usergroups;
DROP TABLE catalogue.operationsdes;
DROP TABLE catalogue.operations;
DROP TABLE catalogue.isolanguagesdes;
DROP TABLE catalogue.metadatarating;
DROP TABLE catalogue.isolanguages;
DROP TABLE catalogue.relations;
DROP TABLE catalogue.regionsdes;
DROP TABLE catalogue.regions;
DROP TABLE catalogue.settings;
DROP TABLE catalogue.sources;
DROP TABLE catalogue.metadata;
DROP TABLE catalogue.languages;
DROP TABLE catalogue.groups;
DROP TABLE catalogue.users;


-- Startup the application to create new target structure - manually
-- Stop the application

