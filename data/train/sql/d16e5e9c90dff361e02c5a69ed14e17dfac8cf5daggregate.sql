CREATE OR REPLACE FUNCTION first_element_state(anyarray, anyelement)
  RETURNS anyarray AS
$$
    SELECT CASE WHEN array_upper($1,1) IS NULL THEN array_append($1,$2) ELSE $1 END;
$$
  LANGUAGE 'sql' IMMUTABLE;

CREATE OR REPLACE FUNCTION first_element(anyarray)
  RETURNS anyelement AS
$$
    SELECT ($1)[1] ;
$$
  LANGUAGE 'sql' IMMUTABLE;

CREATE OR REPLACE FUNCTION last_element(anyelement, anyelement)
  RETURNS anyelement AS
$$
    SELECT $2;
$$
  LANGUAGE 'sql' IMMUTABLE;
  
CREATE AGGREGATE first(anyelement) (
  SFUNC=first_element_state,
  STYPE=anyarray,
  FINALFUNC=first_element
  )
;

CREATE AGGREGATE last(anyelement) (
  SFUNC=last_element,
  STYPE=anyelement
);