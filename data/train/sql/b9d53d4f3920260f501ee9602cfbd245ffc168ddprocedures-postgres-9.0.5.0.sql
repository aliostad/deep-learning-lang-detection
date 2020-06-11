-- create functions

-- create array accumulate function
create aggregate array_accumulate(basetype = int,
                          sfunc = array_append,
                          stype = int[],
                          initcond = '{}'
                         );
/
                         
-- create format ip address function
--CREATE OR REPLACE FUNCTION format_ip_address(int8)
--  RETURNS text AS
--$BODY$
--    select to_char(($1 >> 24) & 255, 'FM999') || '.' ||
--           to_char(($1 >> 16) & 255, 'FM999') || '.' ||
--           to_char(($1 >> 8)  & 255, 'FM999') || '.' ||
--           to_char($1         & 255, 'FM999')
--$BODY$
--  LANGUAGE 'sql' IMMUTABLE STRICT;
