--liquibase formatted sql

--This is for the sparrow_dss schema
   
--logicalFilePath: changeLog1Indexes.sql

--changeset drsteini:indexs1a
insert into user_sdo_geom_metadata
values ('MODEL_CALIB_SITES',
        'SITE_GEOM',
        mdsys.SDO_DIM_ARRAY(mdsys.SDO_DIM_ELEMENT('X', -125, -65, 1),
                            mdsys.SDO_DIM_ELEMENT('Y', 25, 50, 1)),
        8307);
--rollback delete from user_sdo_geom_metadata where table_name = 'MODEL_CALIB_SITES' and column_name = 'SITE_GEOM';

--changeset drsteini:indexs1b
create index calib_site_geom_i on model_calib_sites(site_geom) indextype is mdsys.spatial_index;
--rollback drop index calib_site_geom_i;

--changeset drsteini:indexs1c
create index model_reach_enh_reach_fk_i on model_reach(enh_reach_id);
--rollback drop index model_reach_enh_reach_fk_i;

--changeset drsteini:indexs1d
create index model_reach_fnode_i on model_reach(fnode);
--rollback drop index model_reach_fnode_i;

--changeset drsteini:indexs1e
create index model_reach_hydseq_i on model_reach(hydseq);
--rollback drop index model_reach_hydseq_i;

--changeset drsteini:indexs1f
create index model_reach_rsize_i on model_reach(reach_size);
--rollback drop index model_reach_rsize_i;

--changeset drsteini:indexs1g
create index model_reach_tnode_i on model_reach(tnode);
--rollback drop index model_reach_tnode_i;

--changeset drsteini:indexs1h
create bitmap index sparrow_model_id_i on model_reach(sparrow_model_id);
--rollback drop index sparrow_model_id_i;

--changeset drsteini:indexs1i
create index model_reach_attrib_ow_name_i on model_reach_attrib(open_water_name);
--rollback drop index model_reach_attrib_ow_name_i;

--changeset drsteini:indexs1j
create index model_reach_attrib_rname_i on model_reach_attrib(reach_name);
--rollback drop index model_reach_attrib_rname_i;

--changeset drsteini:indexs1k
insert into user_sdo_geom_metadata
values ('MODEL_REACH_GEOM',
        'CATCH_GEOM',
        mdsys.SDO_DIM_ARRAY(mdsys.SDO_DIM_ELEMENT('X', -125, -65, 1),
                            mdsys.SDO_DIM_ELEMENT('Y', 25, 50, 1)),
        8307);
--rollback delete from user_sdo_geom_metadata where table_name = 'MODEL_REACH_GEOM' and column_name = 'CATCH_GEOM';

--changeset drsteini:indexs1l
create index model_reach_catch_geom_i on model_reach_geom(catch_geom) indextype is mdsys.spatial_index;
--rollback drop index model_reach_catch_geom_i;

--changeset drsteini:indexs1m
insert into user_sdo_geom_metadata
values ('MODEL_REACH_GEOM',
        'REACH_GEOM',
        mdsys.SDO_DIM_ARRAY(mdsys.SDO_DIM_ELEMENT('X', -125, -65, 1),
                            mdsys.SDO_DIM_ELEMENT('Y', 25, 50, 1)),
        8307);
--rollback delete from user_sdo_geom_metadata where table_name = 'MODEL_REACH_GEOM' and column_name = 'REACH_GEOM';

--changeset drsteini:indexs1n
create index model_reach_reach_geom_i on model_reach_geom(reach_geom) indextype is mdsys.spatial_index;
--rollback drop index model_reach_reach_geom_i;

--changeset drsteini:indexs1o
create index reach_coef_it_i on reach_coef(iteration);
--rollback drop index reach_coef_it_i;

--changeset drsteini:indexs1p
create index source_reach_it_i on source_reach_coef(iteration);
--rollback drop index source_reach_it_i;

