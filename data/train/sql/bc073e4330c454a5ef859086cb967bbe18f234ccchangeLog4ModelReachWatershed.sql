--liquibase formatted sql

--This is for the sparrow_dss schema

--logicalFilePath: changeLog4ModelReachWatershed.sql

--changeset lmurphy:watershed4a
alter table model_reach_watershed rename to model_reach_watershed_old;
--rollback alter table model_reach_watershed_old rename to model_reach_watershed;

--changeset lmurphy:watershedb
alter table model_reach_watershed_old rename constraint model_reach_id_fk to model_reach_id_fk_old;
--rollback alter table model_reach_watershed_old rename constraint model_reach_id_fk_old to model_reach_id_fk;

--changeset lmurphy:watershedc
alter table model_reach_watershed_old rename constraint watershed_id_fk to watershed_id_fk_old;
--rollback alter table model_reach_watershed_old rename constraint watershed_id_fk_old to watershed_id_fk;



--changeset lmurphy:watershed4c
alter table predefined_watershed rename to predefined_watershed_old;
--rollback alter table predefined_watershed_old rename to predefined_watershed;

--changeset lmurphy:watershed4d
alter table predefined_watershed_old rename constraint predefined_watershed_pk to predefined_watershed_pk_old;
--rollback alter table predefined_watershed_old rename constraint predefined_watershed_pk_old to predefined_watershed_pk;

--changeset lmurphy:watershed4e
alter index predefined_watershed_pk rename to predefined_watershed_pk_old;
--rollback alter index predefined_watershed_pk_old rename to predefined_watershed_pk;


--changeset lmurphy:watershed4f
create table predefined_watershed
(watershed_id                    number                               constraint nn_pred_watershed_wid not null
,name                            VARCHAR2(50 CHAR)                        constraint nn_pred_watershed_nm not null
,description                    VARCHAR2(200 CHAR)
,date_added                        DATE
,parameter_type                 VARCHAR2(20 CHAR)                       
,watershed_parameters           VARCHAR2(200 CHAR)                      
,sparrow_model_id        number(9)                               constraint nn_pred_watershed_mid not null                              
,constraint predefined_watershed_pk
   primary key (watershed_id)
,constraint pred_watershed_model_fk
   foreign key (sparrow_model_id)
     references sparrow_model (sparrow_model_id)
)
partition by list (sparrow_model_id)
(partition sparrow_model_22 values (22)
,partition sparrow_model_23 values (23)
,partition sparrow_model_24 values (24)
,partition sparrow_model_30 values (30)
,partition sparrow_model_35 values (35)
,partition sparrow_model_36 values (36)
,partition sparrow_model_37 values (37)
,partition sparrow_model_38 values (38)
,partition sparrow_model_41 values (41)
,partition sparrow_model_42 values (42)
,partition sparrow_model_43 values (43)
,partition sparrow_model_44 values (44)
,partition sparrow_model_49 values (49)
,partition sparrow_model_50 values (50)
,partition sparrow_model_51 values (51)
,partition sparrow_model_52 values (52)
,partition sparrow_model_53 values (53)
,partition sparrow_model_54 values (54)
,partition sparrow_model_55 values (55)
,partition sparrow_model_57 values (57)
,partition sparrow_model_58 values (58)
);
--rollback drop table predefined_watershed cascade constraints purge;



--changeset lmurphy:watershed4g
create table model_reach_watershed
(model_reach_id					number                   			constraint nn_model_rch_watershd_id not null
,watershed_id					number                   			constraint nn_model_rch_watershd_wid not null
,sparrow_model_id_partition		number                  			constraint nn_model_rch_watershd_mid not null
,constraint mdl_rch_watershd_uk_identifier
   unique (model_reach_id, watershed_id)
,constraint model_reach_id_fk 
   foreign key (model_reach_id) 
     references model_reach (model_reach_id)
,constraint watershed_id_fk 
   foreign key (watershed_id) 
     references predefined_watershed (watershed_id)
,constraint model_reach_watershed_model_fk
   foreign key (sparrow_model_id_partition)
     references sparrow_model (sparrow_model_id)
)
partition by list (sparrow_model_id_partition)
(partition sparrow_model_22 values (22)
,partition sparrow_model_23 values (23)
,partition sparrow_model_24 values (24)
,partition sparrow_model_30 values (30)
,partition sparrow_model_35 values (35)
,partition sparrow_model_36 values (36)
,partition sparrow_model_37 values (37)
,partition sparrow_model_38 values (38)
,partition sparrow_model_41 values (41)
,partition sparrow_model_42 values (42)
,partition sparrow_model_43 values (43)
,partition sparrow_model_44 values (44)
,partition sparrow_model_49 values (49)
,partition sparrow_model_50 values (50)
,partition sparrow_model_51 values (51)
,partition sparrow_model_52 values (52)
,partition sparrow_model_53 values (53)
,partition sparrow_model_54 values (54)
,partition sparrow_model_55 values (55)
,partition sparrow_model_57 values (57)
,partition sparrow_model_58 values (58)
);
--rollback drop table model_reach_watershed cascade constraints purge;


-- changeset lmurphy:watershed4h
insert into predefined_watershed (watershed_id, name, description, date_added, sparrow_model_id)
select watershed_id, name, description, date_added, sparrow_model_id
  from predefined_watershed_old;
--rollback delete from predefined_watershed;


-- changeset lmurphy:watershed4i
insert into model_reach_watershed
select mrwo.model_reach_id, mrwo.watershed_id, mr.sparrow_model_id
  from model_reach_watershed_old mrwo
       join model_reach mr
         on mrwo.model_reach_id = mr.model_reach_id;
--rollback delete from model_reach_watershed;


-- changeset lmurphy:watershed4j
create table model_reach_watershed_swap
(model_reach_id                    number                                    constraint nn_model_rch_watershd_swp_pk not null
,watershed_id                    number                               constraint nn_model_rch_watershd_swp_wid not null
,sparrow_model_id_partition        number                               constraint nn_model_rch_watershd_swp_mid not null
,constraint mdl_rch_wshd_sw_uk_identifier
   unique (model_reach_id, watershed_id)
,constraint model_reach_id_swp_fk 
   foreign key (model_reach_id) 
     references model_reach (model_reach_id)
,constraint watershed_id_swp_fk 
   foreign key (watershed_id) 
     references predefined_watershed (watershed_id)
,constraint mdl_rch_wshd_sw_model_fk
   foreign key (sparrow_model_id_partition)
     references sparrow_model (sparrow_model_id)
);
--rollback drop table model_reach_watershed_swap cascade constraints purge;