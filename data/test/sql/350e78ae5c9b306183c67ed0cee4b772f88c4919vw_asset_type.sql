DROP VIEW IF EXISTS asset.vw_asset_type CASCADE;

CREATE VIEW asset.vw_asset_type AS
    SELECT a.id, a.assettype_code, a.assettype_name, d.depn_name, 
        public.formatglaccount(a.assettype_gl1) AS assettype_gl1, 
        public.formatglaccount(a.assettype_gl2) AS assettype_gl2, 
        public.formatglaccount(a.assettype_gl3) AS assettype_gl3, 
        public.formatglaccount(a.assettype_gl4) AS assettype_gl4, 
        public.formatglaccount(a.assettype_gl5) AS assettype_gl5, 
        a.assettype_depnperc 
    FROM (asset.asset_type a JOIN asset.asset_depn d ON ((a.assettype_depn = d.depn_id)));

CREATE OR REPLACE RULE "_INSERT" AS ON INSERT TO vw_asset_type DO INSTEAD INSERT INTO asset_type (assettype_code, assettype_name, assettype_depn, assettype_gl1, assettype_gl2, assettype_gl3, assettype_gl4, assettype_gl5, assettype_depnperc) VALUES (new.assettype_code, new.assettype_name, CASE WHEN (new.depn_name = 'Straight Line'::text) THEN 1 WHEN (new.depn_name = 'Diminishing Value'::text) THEN 2 ELSE 0 END, public.getglaccntid(new.assettype_gl1), public.getglaccntid(new.assettype_gl2), public.getglaccntid(new.assettype_gl3), public.getglaccntid(new.assettype_gl4), public.getglaccntid(new.assettype_gl5), new.assettype_depnperc);

CREATE OR REPLACE RULE "_UPDATE" AS ON UPDATE TO vw_asset_type DO INSTEAD UPDATE asset_type SET assettype_name = new.assettype_name, assettype_depn = CASE WHEN (new.depn_name = 'Straight Line'::text) THEN 1 WHEN (new.depn_name = 'Diminishing Value'::text) THEN 2 ELSE 0 END, assettype_gl1 = public.getglaccntid(new.assettype_gl1), assettype_gl2 = public.getglaccntid(new.assettype_gl2), assettype_gl3 = public.getglaccntid(new.assettype_gl3), assettype_gl4 = public.getglaccntid(new.assettype_gl4), assettype_gl5 = public.getglaccntid(new.assettype_gl5), assettype_depnperc = new.assettype_depnperc WHERE (asset_type.assettype_code = new.assettype_code);


REVOKE ALL ON TABLE asset.vw_asset_type FROM PUBLIC;
ALTER TABLE asset.vw_asset_type OWNER TO admin;
GRANT ALL ON TABLE asset.vw_asset_type TO admin;
GRANT ALL ON TABLE asset.vw_asset_type TO xtrole;
