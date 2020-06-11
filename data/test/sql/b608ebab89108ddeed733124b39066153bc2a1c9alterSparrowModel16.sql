--liquibase formatted sql

--This is for the sparrow_dss schema

--logicalFilePath: alterSparrowModel.sql

--changeset cschroed:addColumnsToSparrowModel
alter table SPARROW_MODEL move NOCOMPRESS;
alter table SPARROW_MODEL add (
	states nvarchar2(300),
	is_national char(1) DEFAULT 'F',
	regions nvarchar2(100),
	base_year number
);

alter table SPARROW_MODEL move COMPRESS;

--rollback alter table SPARROW_MODEL move NOCOMPRESS;
--rollback alter table SPARROW_MODEL drop (states, is_national, regions, base_year);
--rollback alter table SPARROW_MODEL move COMPRESS;