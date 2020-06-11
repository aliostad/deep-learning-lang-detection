-- borrowed from: http://wiki.postgresql.org/wiki/Aggregate_Median

CREATE OR REPLACE FUNCTION _final_median(anyarray)
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
LANGUAGE 'sql'
SET search_path FROM CURRENT
IMMUTABLE;

DROP AGGREGATE IF EXISTS median(anyelement);
CREATE AGGREGATE median(anyelement) (
  SFUNC=array_append,
  STYPE=anyarray,
  FINALFUNC=_final_median,
  INITCOND='{}'
);

CREATE OR REPLACE FUNCTION _final_median(double precision[])
  RETURNS double precision AS
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
LANGUAGE 'sql'
SET search_path FROM CURRENT
IMMUTABLE;

DO $$
BEGIN
  CREATE AGGREGATE median(double precision) (
    SFUNC=array_append,
    STYPE=double precision[],
    FINALFUNC=_final_median,
    INITCOND='{}'
  );
EXCEPTION
  WHEN duplicate_function THEN RAISE NOTICE 'Aggregate median is already exists';
END;
$$