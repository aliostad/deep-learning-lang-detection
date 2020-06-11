-- describe table with column details
-- http://stackoverflow.com/questions/109325/postgresql-describe-table
\d+ tablename

-- help
\?

-- use database
\c database_name

-- list tables
\dt

-- http://www.postgresql.org/docs/8.1/static/backup.html#BACKUP-DUMP
-- DB Dump
shell> pg_dump dbname > outfile
shell> psql dbname < outfile


-- drop all tables of a database
-- http://stackoverflow.com/questions/3327312/drop-all-tables-in-postgresql
drop schema public cascade;
create schema public;

-- drop database
drop database qxt_dev;
-- DROP DATABASE

-- create database and grant privileges on database
create database qxt_dev;
-- CREATE DATABASE
grant all privileges on database qxt_dev to qxt;
-- GRANT
