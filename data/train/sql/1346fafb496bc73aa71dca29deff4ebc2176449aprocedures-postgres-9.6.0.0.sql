-- create functions

-- accumulate is done now using builtin array_agg
-- so removing the custome array_accumulate written using
-- array_append

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
