-- View: pyarchinit_reperti_e_us_e_poligoni_view

-- DROP VIEW pyarchinit_reperti_e_us_e_poligoni_view;

CREATE OR REPLACE VIEW pyarchinit_reperti_e_us_e_poligoni_view AS 
 SELECT pyarchinit_reperti_e_us_view.id_invmat, pyarchinit_reperti_e_us_view.sito_rep, pyarchinit_reperti_e_us_view.area_rep, pyarchinit_reperti_e_us_view.us_rep, pyunitastratigrafiche.gid AS gid_us, pyunitastratigrafiche.scavo_s, pyunitastratigrafiche.area_s, pyunitastratigrafiche.us_s, pyunitastratigrafiche.the_geom
   FROM pyarchinit_reperti_e_us_view
   JOIN pyunitastratigrafiche ON pyarchinit_reperti_e_us_view.sito_rep = pyunitastratigrafiche.scavo_s::text AND pyarchinit_reperti_e_us_view.area_rep::text = pyunitastratigrafiche.area_s::text AND pyarchinit_reperti_e_us_view.us_rep::text = pyunitastratigrafiche.us_s::text;

ALTER TABLE pyarchinit_reperti_e_us_e_poligoni_view OWNER TO postgres;

