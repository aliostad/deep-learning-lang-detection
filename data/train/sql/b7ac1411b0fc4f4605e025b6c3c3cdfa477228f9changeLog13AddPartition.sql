--liquibase formatted sql

--This is for the sparrow_dss schema

--logicalFilePath: changeLog13AddPartition.sql

--changeset lmurphy:addpartitiona
alter table model_reach add partition sparrow_model_25 VALUES (25)
--rollback alter table model_reach drop partition sparrow_model_25;


--changeset lmurphy:addpartitionc
alter table model_reach_attrib add partition sparrow_model_25 VALUES (25)
--rollback alter table model_reach_attrib drop partition sparrow_model_25;


--changeset lmurphy:addpartitiond
alter table reach_coef add partition sparrow_model_25 VALUES (25)
--rollback alter table reach_coef drop partition sparrow_model_25;


--changeset lmurphy:addpartitione
alter table source_reach_coef add partition sparrow_model_25 VALUES (25)
--rollback alter table source_reach_coef drop partition sparrow_model_25;


--changeset lmurphy:addpartitionf
alter table source_value add partition sparrow_model_25 VALUES (25)
--rollback alter table source_value drop partition sparrow_model_25;


--changeset lmurphy:addpartitiong
alter table model_calib_sites add partition sparrow_model_25 VALUES (25)
--rollback alter table model_calib_sites drop partition sparrow_model_25;



--changeset lmurphy:addpartitionh
alter table model_reach_watershed add partition sparrow_model_25 VALUES (25)
--rollback alter table model_reach_watershed drop partition sparrow_model_25;
