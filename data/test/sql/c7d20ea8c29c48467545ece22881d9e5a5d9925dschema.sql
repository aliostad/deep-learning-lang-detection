-- Timestamp: 2015-05-13 14:15:27.714
-- Source database is: test_sessions
-- Connection URL is: jdbc:derby://localhost:1527/test_sessions;user=db;password=db
-- appendLogs: false

-- ----------------------------------------------
-- DDL Statements for schemas
-- ----------------------------------------------

CREATE SCHEMA "DB";

-- ----------------------------------------------
-- DDL Statements for tables
-- ----------------------------------------------

CREATE TABLE "DB"."TOKENS" ("ID" VARCHAR(48) NOT NULL, "USERID" VARCHAR(48) NOT NULL, "EXPIRED" TIMESTAMP NOT NULL, "USERAGENT" VARCHAR(50) NOT NULL);

CREATE TABLE "DB"."USERS" ("ID" VARCHAR(48) NOT NULL, "USERNAME" VARCHAR(100), "PASSWORD" VARCHAR(60) NOT NULL);

-- ----------------------------------------------
-- DDL Statements for indexes
-- ----------------------------------------------

CREATE INDEX "DB"."USERS_PASSWORD_IDX" ON "DB"."USERS" ("PASSWORD");

CREATE INDEX "DB"."USERS_USERNAME_IDX" ON "DB"."USERS" ("USERNAME");

CREATE INDEX "DB"."TOKENS_EXPIRED_IDX" ON "DB"."TOKENS" ("EXPIRED");

CREATE INDEX "DB"."TOKENS_USERID_IDX" ON "DB"."TOKENS" ("USERID");

-- ----------------------------------------------
-- DDL Statements for keys
-- ----------------------------------------------

-- PRIMARY/UNIQUE
ALTER TABLE "DB"."USERS" ADD CONSTRAINT "UNIQ_USERS" UNIQUE ("USERNAME");

ALTER TABLE "DB"."USERS" ADD CONSTRAINT "SQL150427134419860" PRIMARY KEY ("ID");

ALTER TABLE "DB"."TOKENS" ADD CONSTRAINT "SQL150427134916520" PRIMARY KEY ("ID");

-- FOREIGN
ALTER TABLE "DB"."TOKENS" ADD CONSTRAINT "SQL150427135345680" FOREIGN KEY ("USERID") REFERENCES "DB"."USERS" ("ID") ON DELETE NO ACTION ON UPDATE NO ACTION;
