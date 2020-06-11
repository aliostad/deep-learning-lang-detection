--liquibase formatted sql

--This is for the sparrow_dss schema
   
--logicalFilePath: changeLog3Master.sql

--changeset drsteini:idx3a
create index model_reach_swap_enh_reach_fk on model_reach_swap(enh_reach_id);
--rollback drop index model_reach_swap_enh_reach_fk;

--changeset drsteini:idx3b
create index model_reach_swap_fnode_i on model_reach_swap(fnode);
--rollback drop index model_reach_swap_fnode_i;

--changeset drsteini:idx3c
create index model_reach_swap_hydseq_i on model_reach_swap(hydseq);
--rollback drop index model_reach_swap_hydseq_i;

--changeset drsteini:idx3d
create index model_reach_swap_rsize_i on model_reach_swap(reach_size);
--rollback drop index model_reach_swap_rsize_i;

--changeset drsteini:idx3e
create index model_reach_swap_tnode_i on model_reach_swap(tnode);
--rollback drop index model_reach_swap_tnode_i;

--changeset drsteini:idx3f
create index model_reach_swap_sprw_mdl_fk on model_reach_swap(sparrow_model_id);
--rollback drop index model_reach_swap_sprw_mdl_fk;

