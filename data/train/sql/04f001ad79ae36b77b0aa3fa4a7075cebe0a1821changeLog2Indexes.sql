--liquibase formatted sql

--This is for the sparrow_dss schema
  
--logicalFilePath: changeLog2Indexes.sql

--changeset drsteini:indexs2a
create index calib_site_geom_i on model_calib_sites(site_geom) indextype is mdsys.spatial_index;
--rollback drop index calib_site_geom_i;

--changeset drsteini:indexs2b
create index model_reach_enh_reach_fk_i on model_reach(enh_reach_id);
--rollback drop index model_reach_enh_reach_fk_i;

--changeset drsteini:indexs2c
create index model_reach_fnode_i on model_reach(fnode);
--rollback drop index model_reach_fnode_i;

--changeset drsteini:indexs2d
create index model_reach_hydseq_i on model_reach(hydseq);
--rollback drop index model_reach_hydseq_i;

--changeset drsteini:indexs2e
create index model_reach_rsize_i on model_reach(reach_size);
--rollback drop index model_reach_rsize_i;

--changeset drsteini:indexs2f
create index model_reach_tnode_i on model_reach(tnode);
--rollback drop index model_reach_tnode_i;

--changeset drsteini:indexs2g
create index model_reach_attrib_ow_name_i on model_reach_attrib(open_water_name);
--rollback drop index model_reach_attrib_ow_name_i;

--changeset drsteini:indexs2h
create index model_reach_attrib_rname_i on model_reach_attrib(reach_name);
--rollback drop index model_reach_attrib_rname_i;

--changeset drsteini:indexs2i
create index reach_coef_it_i on reach_coef(iteration);
--rollback drop index reach_coef_it_i;

--changeset drsteini:indexs2j
create index source_reach_it_i on source_reach_coef(iteration);
--rollback drop index source_reach_it_i;
