commands run inside PSQL shell:

-- list databases
\l
\list

-- list db roles
\du

-- connect to db_name
\connect db_name

-- close connections on db_name
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'db_name'
  AND pid <> pg_backend_pid();

-- droping db_name
DROP DATABASE db_name;

-- create db_name with db_role
CREATE DATABASE db_name with owner db_role ENCODING 'UTF-8';

-- create db_role
CREATE ROLE db_role LOGIN PASSWORD 'some_password';

-- create db_name_new based on db_name with user_role
CREATE DATABASE db_name_new WITH TEMPLATE db_name OWNER user_role;

-- add PostGIT extensions:

-- Enable PostGIS (includes raster)
CREATE EXTENSION postgis;
-- Enable Topology
CREATE EXTENSION postgis_topology;
-- fuzzy matching needed for Tiger
CREATE EXTENSION fuzzystrmatch;
-- Enable US Tiger Geocoder
CREATE EXTENSION postgis_tiger_geocoder;


-- enable HSTORE
create extension hstore;


commands run outside PSQL shell

-- give the path to current db
which psql

-- create database foo with role bar
createdb -O bar foo

-- Backup database called db_name to file called dump_backup.sql for user_role
pg_dump -U user_role db_name -f dump_backup.sql

-- Restore database called db_name to file called dump_backup.sql for user_role
psql -U user_role -d db_name -f dump_backup.sql

-- backup all the databases to all.sql
pg_dumpall > all.sql


-- get dump from server calling it remotly [sshpass,ssh, pg_dump property of return to stdout]
sshpass  -p "FuckinHardPass" ssh  andi@1.2.3.4 "pg_dump -U andi andi_some_db" > andi_some_db.sql

-- get dump from server calling it remotly and restoring in <some_existing_db>
sshpass  -p "FuckinHardPass" ssh  andi@1.2.3.4 "pg_dump -U andi andi_some_db" | pg_restore =dbname=<some_exisiting_db>
