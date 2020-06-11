-- $Id: fact_proj_tech_data.sql,v 1.2 2014/02/21 14:30:35 skempins Exp $

EXECUTE build_util.drop_table('new_fact_project_tech_data');
CREATE TABLE new_fact_project_tech_data
   ( permit_key NUMBER NOT NULL
   , data_category_name VARCHAR2(50) NOT NULL
   , data_name VARCHAR2(50) NOT NULL
   )
TABLESPACE &TABLE_TABLESPACE
   PCTFREE 0 PCTUSED 99
   PARALLEL NOLOGGING
	 &COMPRESS_OPTION
;

INSERT /*+APPEND*/
INTO new_fact_project_tech_data
  ( permit_key
  , data_category_name
  , data_name )
SELECT 
  dim_permit.permit_key 
  , 'Development Type' data_category_name
  , dvlp_tp.tech_abbr_dsc data_name
FROM proj_dvlp
JOIN new_dim_permit dim_permit ON (dim_permit.cur_prmt_id = proj_dvlp.cur_id)
JOIN sjr_tech_abbr_et dvlp_tp ON (proj_dvlp.dvlp_tp_cd = dvlp_tp.tech_data_tp_id) 
;
COMMIT;

INSERT /*+APPEND*/
INTO new_fact_project_tech_data
  ( permit_key
  , data_category_name
  , data_name )
SELECT 
  dim_permit.permit_key 
  , 'Treatment Type' data_category_name
  , tp_dsc data_name
FROM proj_trtmnt
JOIN new_dim_permit dim_permit ON (dim_permit.cur_prmt_id = proj_trtmnt.cur_id)
JOIN sjr_abbr_def_et ON (trtmnt_tp_cd = tp_id)
;
COMMIT;

EXECUTE build_util.create_index('new_fact_project_tech_data','permit_key','&INDEX_TABLESPACE');
EXECUTE dbms_stats.gather_table_stats(USER,'new_fact_project_tech_data');
