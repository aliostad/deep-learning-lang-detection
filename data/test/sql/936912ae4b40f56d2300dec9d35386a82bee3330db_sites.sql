-- Creates the db structure for sites tables ...
--
-- $Id: db_sites.sql 2247 2007-11-02 13:56:21Z alex $ --
--

-- Table app_sites_archives --
CREATE SEQUENCE sites_archives_seq INCREMENT BY 1 NO MAXVALUE MINVALUE 1 CACHE 1;

CREATE TABLE app_sites_archives (
    site_archive_id integer DEFAULT nextval('sites_archives_seq'::text) NOT NULL,
    routes_quantity smallint,
    max_rating smallint,
    min_rating smallint,
    mean_rating smallint,
    max_height smallint,
    min_height smallint,
    mean_height smallint,
    equipment_rating smallint,
    climbing_styles smallint[],
    rock_types smallint[],
    site_types smallint[],
    children_proof smallint,
    rain_proof smallint,
    facings smallint[],
    best_periods smallint[],
    v4_id smallint,
    v4_type varchar(4) -- area / sect (sector)
) INHERITS (app_documents_archives);

ALTER TABLE ONLY app_sites_archives ADD CONSTRAINT sites_archives_pkey PRIMARY KEY (site_archive_id);
-- added here because indexes are not inherited from parent table (app_documents_archives):
CREATE INDEX app_sites_archives_id_idx ON app_sites_archives USING btree (id); 
CREATE INDEX app_sites_archives_geom_idx ON app_sites_archives USING GIST (geom GIST_GEOMETRY_OPS); 
CREATE INDEX app_sites_archives_redirects_idx ON app_sites_archives USING btree (redirects_to); -- useful for filtering on lists

CREATE INDEX app_sites_archives_elevation_idx ON app_sites_archives USING btree (elevation);
ALTER TABLE app_sites_archives ADD CONSTRAINT enforce_dims_geom CHECK (ndims(geom) = 3);

CREATE INDEX app_sites_v4_idx ON app_sites_archives USING btree (v4_id, v4_type); -- useful for filtering on v4 type (area/sector)
CREATE INDEX app_sites_archives_latest_idx ON app_sites_archives USING btree (is_latest_version);
CREATE INDEX app_sites_archives_document_archive_id_idx ON app_sites_archives USING btree (document_archive_id);

-- Table app_sites_i18n_archives --
CREATE SEQUENCE sites_i18n_archives_seq INCREMENT BY 1 NO MAXVALUE MINVALUE 1 CACHE 1;

CREATE TABLE app_sites_i18n_archives (
    site_i18n_archive_id integer NOT NULL DEFAULT nextval('sites_i18n_archives_seq'::text),
    remarks text,
    pedestrian_access text,
    way_back text,
    external_resources text,
    site_history text
) INHERITS (app_documents_i18n_archives);

ALTER TABLE ONLY app_sites_i18n_archives ADD CONSTRAINT sites_i18n_archives_pkey PRIMARY KEY (site_i18n_archive_id);
-- added here because indexes are not inherited from parent table (app_documents_i18n_archives):
CREATE INDEX app_sites_i18n_archives_id_culture_idx ON app_sites_i18n_archives USING btree (id, culture);
-- index for text search:
-- nb : be sure to search on the lowercased version of word typed, so that this index is useful.
CREATE INDEX app_sites_i18n_archives_name_idx ON app_sites_i18n_archives USING btree (search_name);
CREATE INDEX app_sites_i18n_archives_latest_idx ON app_sites_i18n_archives USING btree (is_latest_version);
CREATE INDEX app_sites_i18n_archives_document_i18n_archive_id_idx ON app_sites_i18n_archives USING btree (document_i18n_archive_id);

-- Views --
CREATE OR REPLACE VIEW sites AS SELECT sa.oid, sa.id, sa.v4_id, sa.v4_type, sa.lon, sa.lat, sa.elevation, sa.module, sa.is_protected, sa.redirects_to, sa.geom, sa.geom_wkt, sa.routes_quantity, sa.max_rating, sa.min_rating, sa.mean_rating, sa.max_height, sa.min_height, sa.mean_height, sa.equipment_rating, sa.climbing_styles, sa.rock_types, sa.site_types, sa.children_proof, sa.rain_proof, sa.facings, sa.best_periods FROM app_sites_archives sa WHERE sa.is_latest_version; 
INSERT INTO "geometry_columns" VALUES ('','public','sites','geom',3,900913,'POINT');

CREATE OR REPLACE VIEW sites_i18n AS SELECT sa.id, sa.culture, sa.name, sa.search_name, sa.description, sa.remarks, sa.pedestrian_access, sa.way_back, sa.external_resources, sa.site_history FROM app_sites_i18n_archives sa WHERE sa.is_latest_version;

-- Rules --
CREATE OR REPLACE RULE insert_sites AS ON INSERT TO sites DO INSTEAD 
(
    INSERT INTO app_sites_archives (id, module, is_protected, redirects_to, lon, lat, elevation, geom_wkt, geom, routes_quantity, max_rating, min_rating, mean_rating, max_height, min_height, mean_height, equipment_rating, climbing_styles, rock_types, site_types, children_proof, rain_proof, facings, best_periods, v4_id, v4_type, is_latest_version) VALUES (NEW.id, 'sites', NEW.is_protected, NEW.redirects_to, NEW.lon, NEW.lat, NEW.elevation, NEW.geom_wkt, NEW.geom, NEW.routes_quantity, NEW.max_rating, NEW.min_rating, NEW.mean_rating, NEW.max_height, NEW.min_height, NEW.mean_height, NEW.equipment_rating, NEW.climbing_styles, NEW.rock_types, NEW.site_types, NEW.children_proof, NEW.rain_proof, NEW.facings, NEW.best_periods, NEW.v4_id, NEW.v4_type, true)
);

CREATE OR REPLACE RULE update_sites AS ON UPDATE TO sites DO INSTEAD 
(
    INSERT INTO app_sites_archives (id, module, is_protected, redirects_to, lon, lat, elevation, geom_wkt, geom, routes_quantity, max_rating, min_rating, mean_rating, max_height, min_height, mean_height, equipment_rating, climbing_styles, rock_types, site_types, children_proof, rain_proof, facings, best_periods, v4_id, v4_type, is_latest_version) VALUES (NEW.id, 'sites', NEW.is_protected, NEW.redirects_to, NEW.lon, NEW.lat, NEW.elevation, NEW.geom_wkt, NEW.geom, NEW.routes_quantity, NEW.max_rating, NEW.min_rating, NEW.mean_rating, NEW.max_height, NEW.min_height, NEW.mean_height, NEW.equipment_rating, NEW.climbing_styles, NEW.rock_types, NEW.site_types, NEW.children_proof, NEW.rain_proof, NEW.facings, NEW.best_periods, NEW.v4_id, NEW.v4_type, true)
); 

CREATE OR REPLACE RULE insert_sites_i18n AS ON INSERT TO sites_i18n DO INSTEAD 
(
    INSERT INTO app_sites_i18n_archives (id, culture, name, search_name, description, remarks, pedestrian_access, way_back, external_resources, site_history, is_latest_version) VALUES (NEW.id, NEW.culture, NEW.name, NEW.search_name, NEW.description, NEW.remarks, NEW.pedestrian_access, NEW.way_back, NEW.external_resources, NEW.site_history, true)
);

CREATE OR REPLACE RULE update_sites_i18n AS ON UPDATE TO sites_i18n DO INSTEAD 
(
    INSERT INTO app_sites_i18n_archives (id, culture, name, search_name, description, remarks, pedestrian_access, way_back, external_resources, site_history, is_latest_version) VALUES (NEW.id, NEW.culture, NEW.name, NEW.search_name, NEW.description, NEW.remarks, NEW.pedestrian_access, NEW.way_back, NEW.external_resources, NEW.site_history, true)
);

-- Set is_latest_version to false before adding a new version.
CREATE TRIGGER update_sites_latest_version BEFORE INSERT ON app_sites_archives FOR EACH ROW EXECUTE PROCEDURE reset_latest_version(app_sites_archives);
CREATE TRIGGER update_sites_i18n_latest_version BEFORE INSERT ON app_sites_i18n_archives FOR EACH ROW EXECUTE PROCEDURE reset_latest_version_i18n(app_sites_i18n_archives);

-- Trigger qui met à jour la table des versions pour les sites quand on fait une modif d'un site dans une langue --
-- executé en premier par Sf, avant le trigger insert_sites_archives.... --
CREATE TRIGGER insert_sites_i18n_archives AFTER INSERT ON app_sites_i18n_archives FOR EACH ROW EXECUTE PROCEDURE update_documents_versions_i18n();
-- Trigger qui met à jour la table des versions pour les sites quand on fait une modif "chiffres" sur un site --
CREATE TRIGGER insert_sites_archives AFTER INSERT ON app_sites_archives FOR EACH ROW EXECUTE PROCEDURE update_documents_versions();

-- Trigger that updates the geom columns (wkt to/from wkb conversion)
CREATE TRIGGER insert_geom_sites BEFORE INSERT OR UPDATE ON app_sites_archives FOR EACH ROW EXECUTE PROCEDURE update_geom_pt();

CREATE TRIGGER update_search_name_sites_i18n_archives BEFORE INSERT OR UPDATE ON app_sites_i18n_archives FOR EACH ROW EXECUTE PROCEDURE update_search_name();
