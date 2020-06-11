\echo Use "ALTER EXTENSION jsonb_opx UPDATE TO '1.1'" to load this file. \quit

--

CREATE OR REPLACE FUNCTION jsonb_delete_path(jsonb, text[])
RETURNS jsonb
    AS 'MODULE_PATHNAME', 'jsonb_delete_path'
LANGUAGE C IMMUTABLE STRICT;
COMMENT ON FUNCTION jsonb_delete_path(jsonb, text[]) IS 'follow path of keys in order supplied in array and delete end-point key value pair from jsonb';

DROP OPERATOR IF EXISTS #- (jsonb, text[]);
CREATE OPERATOR #- ( PROCEDURE = jsonb_delete_path, LEFTARG = jsonb, RIGHTARG = text[]);
COMMENT ON OPERATOR #- (jsonb, text[]) IS 'delete key path from left operand';

--

CREATE OR REPLACE FUNCTION jsonb_replace_path(jsonb, text[], jsonb)
RETURNS jsonb
    AS 'MODULE_PATHNAME', 'jsonb_replace_path'
LANGUAGE C IMMUTABLE STRICT;
COMMENT ON FUNCTION jsonb_replace_path(jsonb, text[], jsonb) IS 'follow path of keys in order supplied in array and replace end-point key value pair with supplied jsonb';

--

CREATE OR REPLACE FUNCTION jsonb_append_path(jsonb, text[], jsonb)
RETURNS jsonb
    AS 'MODULE_PATHNAME', 'jsonb_append_path'
LANGUAGE C IMMUTABLE STRICT;
COMMENT ON FUNCTION jsonb_append_path(jsonb, text[], jsonb) IS 'follow path of keys in order supplied in array and append to end-point key value pair with supplied jsonb';
