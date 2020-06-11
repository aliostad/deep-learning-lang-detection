--liquibase formatted sql

--This is for the sparrow_dss schema

--logicalFilePath: changeLog5AlterTables.sql

--changeset lmurphy:altertablesa
alter table model_reach add partition sparrow_model_37 VALUES (37)
--rollback alter table model_reach drop partition sparrow_model_37;

--changeset lmurphy:altertablesb
alter table model_reach add partition sparrow_model_38 VALUES (38)
--rollback alter table model_reach drop partition sparrow_model_38;

--changeset lmurphy:altertablesc
alter table model_reach_attrib add partition sparrow_model_37 VALUES (37)
--rollback alter table model_reach_attrib drop partition sparrow_model_37;

--changeset lmurphy:altertablesd
alter table model_reach_attrib add partition sparrow_model_38 VALUES (38)
--rollback alter table model_reach_attrib drop partition sparrow_model_38;

--changeset lmurphy:altertablesi
alter table reach_coef add partition sparrow_model_37 VALUES (37)
--rollback alter table reach_coef drop partition sparrow_model_37;

--changeset lmurphy:altertablesj
alter table reach_coef add partition sparrow_model_38 VALUES (38)
--rollback alter table reach_coef drop partition sparrow_model_38;

--changeset lmurphy:altertablesk
alter table source_reach_coef add partition sparrow_model_37 VALUES (37)
--rollback alter table source_reach_coef drop partition sparrow_model_37;

--changeset lmurphy:altertablesl
alter table source_reach_coef add partition sparrow_model_38 VALUES (38)
--rollback alter table source_reach_coef drop partition sparrow_model_38;

--changeset lmurphy:altertablesm
alter table source_value add partition sparrow_model_37 VALUES (37)
--rollback alter table source_value drop partition sparrow_model_37;

--changeset lmurphy:altertablesn
alter table source_value add partition sparrow_model_38 VALUES (38)
--rollback alter table source_value drop partition sparrow_model_38;

--changeset lmurphy:altertableso
alter table model_calib_sites add partition sparrow_model_37 VALUES (37)
--rollback alter table model_calib_sites drop partition sparrow_model_37;

--changeset lmurphy:altertablesp
alter table model_calib_sites add partition sparrow_model_38 VALUES (38)
--rollback alter table model_calib_sites drop partition sparrow_model_38;

--changeset lmurphy:altertablesq
alter table temp_resids modify (station_name varchar2 (150 char));
--rollback alter table temp_resids modify (station_name varchar2 (60 char));

--changeset lmurphy:altertablesr
alter table model_calib_sites modify (station_name varchar2 (150 char));
--rollback alter table model_calib_sites modify (station_name varchar2 (60 char));

--changeset lmurphy:altertabless
alter table model_calib_sites_swap modify (station_name varchar2 (150 char));
--rollback alter table model_calib_sites_swap modify (station_name varchar2 (60 char));

