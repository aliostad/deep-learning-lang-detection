--
-- Type: MATERIALIZED_VIEW; Owner: BIOMART; Name: BIO_LIT_INT_MODEL_MV
--
  CREATE MATERIALIZED VIEW "BIOMART"."BIO_LIT_INT_MODEL_MV" ("BIO_LIT_INT_DATA_ID", "EXPERIMENTAL_MODEL")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS NOLOGGING
  TABLESPACE "BIOMART" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE QUERY REWRITE
  AS select distinct
  bio_lit_int_data_id, experimental_model
from (
  select
    a.bio_lit_int_data_id,
    b.experimental_model
  from
    biomart.bio_lit_int_data a
    inner join biomart.bio_lit_model_data b on a.in_vivo_model_id = b.bio_lit_model_data_id
  where
    b.experimental_model is not null
  UNION
  select
    a.bio_lit_int_data_id,
    b.experimental_model
  from
    biomart.bio_lit_int_data a
    inner join biomart.bio_lit_model_data b on a.in_vitro_model_id = b.bio_lit_model_data_id
  where
    b.experimental_model is not null
)
;
