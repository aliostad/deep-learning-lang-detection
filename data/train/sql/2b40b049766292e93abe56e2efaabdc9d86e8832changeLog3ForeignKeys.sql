--liquibase formatted sql

--This is for the sparrow_dss schema
  
--logicalFilePath: changeLog3ForeignKeys.sql

--changeset drsteini:fks3a
alter table model_reach_swap add constraint model_reach_swap_enh_reach_fk foreign key (enh_reach_id) references stream_network.enh_reach (enh_reach_id);
--rollback alter table model_reach_swap drop constraint model_reach_swap_enh_reach_fk;
     
--changeset drsteini:fks3b
alter table model_reach_swap add constraint model_reach_swap_sprw_mdl_fk foreign key (sparrow_model_id) references sparrow_model (sparrow_model_id) on delete cascade;
--rollback alter table model_reach_swap drop constraint model_reach_swap_sprw_mdl_fk;



--changeset drsteini:fks3c
alter table source_swap add constraint source_swap_sparrow_model_fk foreign key (sparrow_model_id) references sparrow_model (sparrow_model_id) on delete cascade;
--rollback alter table source_swap drop constraint source_swap_sparrow_model_fk;



--changeset drsteini:fks3d
alter table reach_coef_swap add constraint reach_ceof_swp_model_reach_fk foreign key (model_reach_id) references model_reach_swap (model_reach_id) on delete cascade;
--rollback alter table reach_coef_swap drop constraint reach_ceof_swp_model_reach_fk;

--changeset drsteini:fks3e
alter table reach_coef_swap add constraint reach_coef_swp_sparrow_mdl_fk foreign key (sparrow_model_id) references sparrow_model (sparrow_model_id);
--rollback alter table reach_coef_swap drop constraint reach_coef_swp_sparrow_mdl_fk;



--changeset drsteini:fks3f
alter table source_reach_coef_swap add constraint source_reach_coef_swp_fk foreign key (model_reach_id) references model_reach_swap (model_reach_id) on delete cascade;
--rollback alter table source_reach_coef_swap drop constraint source_reach_coef_swp_fk;

--changeset drsteini:fks3g
alter table source_reach_coef_swap add constraint source_reach_coef_swp_src_fk foreign key (source_id) references source (source_id) on delete cascade;
--rollback alter table source_reach_coef_swap drop constraint source_reach_coef_swp_src_fk;

--changeset drsteini:fks3h
alter table source_reach_coef_swap add constraint src_reach_coef_swp_model_fk foreign key (sparrow_model_id) references sparrow_model (sparrow_model_id);
--rollback alter table source_reach_coef_swap drop constraint src_reach_coef_swp_model_fk;



--changeset drsteini:fks3i
alter table source_value_swap add constraint source_value_swp_mdl_rch_fk foreign key (model_reach_id) references model_reach_swap (model_reach_id) on delete cascade;
--rollback alter table source_value_swap drop constraint source_value_swp_mdl_rch_fk;

--changeset drsteini:fks3j
alter table source_value_swap add constraint source_value_swp_source_fk foreign key (source_id) references source (source_id) on delete cascade;
--rollback alter table source_value_swap drop constraint source_value_swp_source_fk;

--changeset drsteini:fks3k
alter table source_value_swap add constraint src_value_swp_sparrow_model_fk foreign key (sparrow_model_id) references sparrow_model (sparrow_model_id);
--rollback alter table source_value_swap drop constraint src_value_swp_sparrow_model_fk;



--changeset drsteini:fks3l
alter table model_reach_attrib_swap add constraint model_rch_attrib_swp_reach_fk foreign key (model_reach_id) references model_reach_swap (model_reach_id);
--rollback alter table model_reach_attrib_swap drop constraint model_rch_attrib_swp_reach_fk;

--changeset drsteini:fks3m
alter table model_reach_attrib_swap add constraint reach_attrib_swp_model_fk foreign key (sparrow_model_id) references sparrow_model (sparrow_model_id);
--rollback alter table model_reach_attrib_swap drop constraint reach_attrib_swp_model_fk;



--changeset drsteini:fks3n
alter table model_calib_sites_swap add constraint model_calib_sites_swp_reach_fk foreign key (model_reach_id) references model_reach_swap (model_reach_id);
--rollback alter table model_calib_sites_swap drop constraint model_calib_sites_swp_reach_fk;

--changeset drsteini:fks3o
alter table model_calib_sites_swap add constraint model_calib_sites_swp_model_fk foreign key (sparrow_model_id) references sparrow_model (sparrow_model_id);
--rollback alter table model_calib_sites_swap drop constraint model_calib_sites_swp_model_fk;
