
--
-- PostgreSQL port of the MySQL "World" database.
--
-- The sample data used in the world database is Copyright Statistics 
-- Finland, http://www.stat.fi/worldinfigures.
--

SET client_encoding = 'LATIN1';

DROP TABLE IF EXISTS city;
CREATE TABLE city (
    id integer NOT NULL,
    name text NOT NULL,
    countrycode character(3) NOT NULL,
    district text NOT NULL,
    population integer NOT NULL
);

SELECT master_create_distributed_table('city', 'countrycode', 'append');

GRANT SELECT on city to ro;
GRANT SELECT, INSERT, UPDATE, DELETE on city to rw;

CREATE TABLE country (
    code character(3) NOT NULL,
    name text NOT NULL,
    continent text NOT NULL,
    region text NOT NULL,
    surfacearea real NOT NULL,
    indepyear smallint,
    population integer NOT NULL,
    lifeexpectancy real,
    gnp numeric(10,2),
    gnpold numeric(10,2),
    localname text NOT NULL,
    governmentform text NOT NULL,
    headofstate text,
    capital integer,
    code2 character(2) NOT NULL,
    CONSTRAINT country_continent_check CHECK ((((((((continent = 'Asia'::text) OR (continent = 'Europe'::text)) OR (continent = 'North America'::text)) OR (continent = 'Africa'::text)) OR (continent = 'Oceania'::text)) OR (continent = 'Antarctica'::text)) OR (continent = 'South America'::text)))
);

SELECT master_create_distributed_table('country', 'code', 'append');

GRANT SELECT on country to ro;
GRANT SELECT, INSERT, UPDATE, DELETE on country to rw;


CREATE TABLE countrylanguage (
    countrycode character(3) NOT NULL,
    "language" text NOT NULL,
    isofficial boolean NOT NULL,
    percentage real NOT NULL
);

SELECT master_create_distributed_table('countrylanguage', 'countrycode', 'append');

GRANT SELECT on countrylanguage to ro;
GRANT SELECT, INSERT, UPDATE, DELETE on countrylanguage to rw;



