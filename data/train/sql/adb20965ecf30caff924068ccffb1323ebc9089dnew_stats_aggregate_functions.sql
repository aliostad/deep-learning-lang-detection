--by Scott Bailey 'Artacus' in postgresql wiki
CREATE OR REPLACE FUNCTION _final_median(numeric[])
   RETURNS numeric AS
$$
   SELECT AVG(val)
   FROM (
     SELECT val
     FROM unnest($1) val
     ORDER BY 1
     LIMIT  2 - MOD(array_upper($1, 1), 2)
     OFFSET CEIL(array_upper($1, 1) / 2.0) - 1
   ) sub;
$$
LANGUAGE 'sql' IMMUTABLE;
 
CREATE AGGREGATE median(numeric) (
  SFUNC=array_append,
  STYPE=numeric[],
  FINALFUNC=_final_median,
  INITCOND='{}'
);

--by Scott Bailey 'Artacus' in postgresql wiki
CREATE OR REPLACE FUNCTION _final_mode(anyarray)
  RETURNS anyelement AS
$BODY$
    SELECT a
    FROM unnest($1) a
    GROUP BY 1 
    ORDER BY COUNT(1) DESC, 1
    LIMIT 1;
$BODY$
LANGUAGE 'sql' IMMUTABLE;
 
-- Tell Postgres how to use our aggregate
CREATE AGGREGATE mode(anyelement) (
  SFUNC=array_append, --Function to call for each row. Just builds the array
  STYPE=anyarray,
  FINALFUNC=_final_mode, --Function to call after everything has been added to array
  INITCOND='{}' --Initialize an empty array when starting
);

--by Scott Bailey 'Artacus' in postgresql wiki
CREATE OR REPLACE FUNCTION _final_range(numeric[])
   RETURNS numeric AS
$$
   SELECT MAX(val) - MIN(val)
   FROM unnest($1) val;
$$
LANGUAGE 'sql' IMMUTABLE;
 
-- Add aggregate
CREATE AGGREGATE range(numeric) (
  SFUNC=array_append, --Function to call for each row. Just builds the array
  STYPE=numeric[],
  FINALFUNC=_final_range, --Function to call after everything has been added to array
  INITCOND='{}' --Initialize an empty array when starting
);