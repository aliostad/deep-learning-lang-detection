--
-- Name: bio_lit_int_model_view; Type: VIEW; Schema: biomart; Owner: -
--
CREATE VIEW bio_lit_int_model_view AS
    SELECT DISTINCT s.bio_lit_int_data_id, s.experimental_model FROM (SELECT a.bio_lit_int_data_id, b.experimental_model FROM (bio_lit_int_data a JOIN bio_lit_model_data b ON ((a.in_vivo_model_id = b.bio_lit_model_data_id))) WHERE (b.experimental_model IS NOT NULL) UNION SELECT a.bio_lit_int_data_id, b.experimental_model FROM (bio_lit_int_data a JOIN bio_lit_model_data b ON ((a.in_vitro_model_id = b.bio_lit_model_data_id))) WHERE (b.experimental_model IS NOT NULL)) s;

