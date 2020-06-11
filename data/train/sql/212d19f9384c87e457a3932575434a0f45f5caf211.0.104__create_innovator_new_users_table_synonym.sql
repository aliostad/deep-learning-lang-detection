--liquibase formatted sql

--changeset Novacroft:11.0.104
CREATE OR REPLACE SYNONYM ${schemaName}."USERS" FOR ${innovatorNewSchemaName}."USERS";
CREATE OR REPLACE SYNONYM ${schemaName}."GROUPS" FOR ${innovatorNewSchemaName}."GROUPS";
CREATE OR REPLACE SYNONYM ${schemaName}."ORGANISATIONACCESS" FOR ${innovatorNewSchemaName}."ORGANISATIONACCESS";
CREATE OR REPLACE SYNONYM ${schemaName}."PROJECT" FOR ${innovatorNewSchemaName}."PROJECT";
CREATE OR REPLACE SYNONYM ${schemaName}."USER_GROUPS" FOR ${innovatorNewSchemaName}."USER_GROUPS";