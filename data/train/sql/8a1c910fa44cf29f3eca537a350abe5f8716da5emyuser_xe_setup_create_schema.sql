spool local_schema_setup.log append
set echo on

REMARK	Creating tablespaces as setup on production database

create tablespace MYTIME_DATA datafile '%ORACLE_BASE%\oradata\XE\myuser_data.dbf' size 10240K  REUSE AUTOEXTEND ON NEXT 10240K MAXSIZE UNLIMITED;

create tablespace MYTIME_IDX datafile '%ORACLE_BASE%\oradata\XE\myuser_idx.dbf' size 10240K  REUSE AUTOEXTEND ON NEXT 10240K MAXSIZE UNLIMITED;

REMARK	Creating user or schema with right tablespaces and quota

CREATE USER myuser IDENTIFIED BY myuser
DEFAULT TABLESPACE MYUSER_DATA
quota unlimited on MYUSER_DATA;



grant connect, resource to myuser;
grant create database link to myuser;
grant create synonym to myuser;
grant create type to myuser;
grant create materialized view to myuser;
grant create table to myuser;
grant create view to myuser;
grant create procedure to myuser;
grant create sequence to myuser;
grant create trigger to myuser;
grant create role to myuser;
grant create cluster to myuser;
grant create operator to myuser;
grant create indextype to myuser;

spool off
exit;
