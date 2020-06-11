CREATE OR REPLACE FUNCTION application._final_mode(anyarray)
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
CREATE AGGREGATE application.mode(anyelement) (
  SFUNC=array_append, --Function to call for each row. Just builds the array
  STYPE=anyarray,
  FINALFUNC=application._final_mode, --Function to call after everything has been added to array
  INITCOND='{}' --Initialize an empty array when starting
);