-- ============================

-- This file was created using Derby's dblook utility.
-- Timestamp: 2013-08-03 20:08:42.546
-- Source database is: ACMEDatabase
-- Connection URL is: jdbc:derby://localhost:1527/ACMEDatabase;user=dbuser;password=secret
-- Specified schema is: ACMEBANK
-- appendLogs: false

-- ----------------------------------------------
-- DDL Statements for schemas
-- ----------------------------------------------

CREATE SCHEMA "ACMEBANK";

-- ----------------------------------------------
-- DDL Statements for tables
-- ----------------------------------------------

CREATE TABLE "ACMEBANK"."EMPLOYEE" ("ID_EMPLOYEE" INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), "FIRSTNAME" VARCHAR(100), "LASTNAME" VARCHAR(100));

-- ----------------------------------------------
-- DDL Statements for keys
-- ----------------------------------------------

-- primary/unique
ALTER TABLE "ACMEBANK"."EMPLOYEE" ADD CONSTRAINT "SQL130803190026350" PRIMARY KEY ("ID_EMPLOYEE");

