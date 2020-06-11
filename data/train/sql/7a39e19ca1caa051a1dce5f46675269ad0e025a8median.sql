-- borrowed from: http://wiki.postgresql.org/wiki/Aggregate_Median
-- insert as "tm_cz"?

CREATE OR REPLACE FUNCTION tm_cz._final_median(anyarray)
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
 
CREATE AGGREGATE tm_cz.median(anyelement) (
  SFUNC=array_append,
  STYPE=anyarray,
  FINALFUNC=tm_cz._final_median,
  INITCOND='{}'
);
