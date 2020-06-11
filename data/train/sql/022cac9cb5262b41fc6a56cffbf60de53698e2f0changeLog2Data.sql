--liquibase formatted sql

--This is for the sparrow_dss schema

 
--logicalFilePath: changeLog2Data.sql


-- changeset drsteini:data2a
insert into model_reach select * from model_reach_old;
--rollback delete from model_reach;

-- changeset drsteini:data2b
insert into model_calib_sites
select mcso.model_reach_id, mcso.station_name, mcso.actual, mcso.site_geom, mcso.latitude, mcso.longitude, mcso.predict, mcso.station_id, mr.sparrow_model_id
  from model_calib_sites_old mcso
       join model_reach mr
         on mcso.model_reach_id = mr.model_reach_id;
--rollback delete from model_calib_sites;

-- changeset drsteini:data2c
insert into model_reach_attrib
select mrao.model_reach_id, mrao.reach_name, mrao.open_water_name, mrao.meanq, mrao.meanv, mrao.catch_area, mrao.cum_catch_area, mrao.reach_length, mrao.huc2,
       mrao.huc4, mrao.huc6, mrao.huc8, mrao.head_reach, mrao.shore_reach, mrao.term_trans, mrao.term_estuary, mrao.term_nonconnect, mrao.edaname, mrao.edacode,
       mrao.huc2_name, mrao.huc4_name, mrao.huc6_name, mrao.huc8_name, mr.sparrow_model_id
  from model_reach_attrib_old mrao
       join model_reach mr
         on mrao.model_reach_id = mr.model_reach_id;
--rollback delete from model_reach_attrib;

-- changeset drsteini:data2d
insert into source_value
select svo.source_value_id, svo.value, svo.source_id, svo.model_reach_id, svo.mean_pload, svo.se_pload, svo.mean_pload_inc, svo.se_pload_inc, mr.sparrow_model_id
  from source_value_old svo
       join model_reach mr
         on svo.model_reach_id = mr.model_reach_id;
--rollback delete from source_value;

-- changeset drsteini:data2e
insert into source_reach_coef
select srco.source_reach_coef_id, srco.iteration, srco.value, srco.source_id, srco.model_reach_id, mr.sparrow_model_id
  from source_reach_coef_old srco
       join model_reach mr
         on srco.model_reach_id = mr.model_reach_id;
--rollback delete from source_reach_coef;

-- changeset drsteini:data2f
insert into reach_coef
select rco.reach_coef_id, rco.iteration, rco.inc_delivery, rco.total_delivery, rco.boot_error, rco.model_reach_id, mr.sparrow_model_id
  from reach_coef_old rco
       join model_reach mr
         on rco.model_reach_id = mr.model_reach_id;
--rollback delete from reach_coef;
      