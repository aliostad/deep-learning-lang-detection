-- Timestamp: 2014-05-03 16:14:03.193
-- Source database is: db
-- Connection URL is: jdbc:derby:db
-- appendLogs: false

-- ----------------------------------------------
-- DDL Statements for tables
-- ----------------------------------------------

CREATE TABLE "APP"."SINGLE" ("BOOL" BOOLEAN, "PKINT" INTEGER NOT NULL, "BLOB" BLOB(2147483647), "CLOB" CLOB(2147483647), "decimal" NUMERIC(10,5), "VARCHAR100" VARCHAR(100), "DATE" DATE, "int" INTEGER);

-- ----------------------------------------------
-- DDL Statements for keys
-- ----------------------------------------------

-- PRIMARY/UNIQUE
ALTER TABLE "APP"."SINGLE" ADD CONSTRAINT "SQL140503160330990" PRIMARY KEY ("PKINT");

CREATE TABLE "APP"."MAIN" ("BOOL" BOOLEAN,
                           "PKINT" INTEGER NOT NULL,
                           "BLOB" BLOB(2147483647),
                           "CLOB" CLOB(2147483647),
                           "decimal" NUMERIC(10,5),
                           "VARCHAR100" VARCHAR(100),
                           "DATE" DATE,
                           "int" INTEGER);

ALTER TABLE "APP"."MAIN" ADD CONSTRAINT "MAIN_PKINT" PRIMARY KEY ("PKINT");

CREATE TABLE "APP"."DETAIL" ("PKVARCHAR" VARCHAR(30) NOT NULL,
                           "decimal" NUMERIC(10,0),
                           "main_pk" INTEGER);
ALTER TABLE "APP"."DETAIL" ADD FOREIGN KEY ("main_pk") REFERENCES "APP"."MAIN"("PKINT");