
SET client_encoding = 'UTF8';
SET check_function_bodies = false;
SET client_min_messages = warning;


SET search_path = public, pg_catalog;

CREATE AGGREGATE array_accum (
    BASETYPE = anyelement,
    SFUNC = array_append,
    STYPE = anyarray,
    INITCOND = '{}'
);

SET default_tablespace = '';

SET default_with_oids = false;

CREATE TABLE error (
    error_time integer NOT NULL,
    jobid bigint NOT NULL,
    message varchar(255) NOT NULL,
    funcid integer DEFAULT 0 NOT NULL
);

CREATE TABLE exitstatus (
    jobid bigint NOT NULL,
    funcid integer DEFAULT 0 NOT NULL,
    status smallint,
    completion_time integer,
    delete_after integer
);

CREATE TABLE funcmap (
    funcid serial NOT NULL,
    funcname varchar(255) NOT NULL
);

CREATE TABLE job (
    jobid serial NOT NULL,
    funcid integer NOT NULL,
    arg bytea,
    uniqkey varchar(255),
    insert_time integer,
    run_after integer NOT NULL,
    grabbed_until integer NOT NULL,
    priority smallint,
    "coalesce" varchar(255)
);

CREATE TABLE note (
    jobid bigint NOT NULL,
    notekey varchar(255) NOT NULL,
    value bytea
);

ALTER TABLE ONLY exitstatus
    ADD CONSTRAINT exitstatus_pkey
            PRIMARY KEY (jobid);

ALTER TABLE ONLY funcmap
    ADD CONSTRAINT funcmap_funcname_key
            UNIQUE (funcname);

ALTER TABLE ONLY funcmap
    ADD CONSTRAINT funcmap_pkey
            PRIMARY KEY (funcid);

ALTER TABLE ONLY job
    ADD CONSTRAINT job_funcid_key
            UNIQUE (funcid, uniqkey);

ALTER TABLE ONLY job
    ADD CONSTRAINT job_pkey
            PRIMARY KEY (jobid);

ALTER TABLE ONLY note
    ADD CONSTRAINT note_pkey
            PRIMARY KEY (jobid, notekey);

CREATE INDEX error_funcid_errortime
	    ON error (funcid, error_time);

CREATE INDEX error_jobid
	    ON error (jobid);

CREATE INDEX error_time
	    ON error (error_time);

CREATE INDEX exitstatus_deleteafter
	    ON exitstatus (delete_after);

CREATE INDEX exitstatus_funcid
	    ON exitstatus (funcid);

CREATE INDEX ix_job_piro_non_null
	    ON job ((COALESCE((priority)::integer, 0)));

CREATE INDEX job_coalesce
	    ON job ("coalesce" text_pattern_ops);

CREATE INDEX job_funcid_coalesce
	    ON job (funcid, "coalesce" text_pattern_ops);

CREATE INDEX job_funcid_runafter
	    ON job (funcid, run_after);
