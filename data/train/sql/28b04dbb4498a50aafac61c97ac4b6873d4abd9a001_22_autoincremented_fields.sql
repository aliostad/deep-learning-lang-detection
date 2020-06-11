SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

CREATE SEQUENCE org_vacancy_read_id_seq;
ALTER TABLE "org_vacancies" ADD COLUMN "read_id" bigint NOT NULL default nextval('org_vacancy_read_id_seq');
ALTER SEQUENCE org_vacancy_read_id_seq owned by org_vacancies.read_id;

CREATE SEQUENCE res_vacancyapplications_read_id_seq;
ALTER TABLE "res_vacancyapplications" ADD COLUMN "read_id" bigint NOT NULL default nextval('res_vacancyapplications_read_id_seq');
ALTER SEQUENCE res_vacancyapplications_read_id_seq owned by res_vacancyapplications.read_id;