-- Database: yummlyapi

-- DROP DATABASE yummlyapi;

CREATE DATABASE yummlyapi
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'English_United States.1252'
       LC_CTYPE = 'English_United States.1252'
       CONNECTION LIMIT = -1;






-- Table: dump

-- DROP TABLE dump;

CREATE TABLE dump
(
  id serial NOT NULL,
  url text,
  value1 text,
  value2 text,
  CONSTRAINT dump_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE dump
  OWNER TO postgres;
