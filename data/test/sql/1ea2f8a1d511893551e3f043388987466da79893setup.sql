CREATE EXTENSION postgis;
CREATE EXTENSION btree_gist;

CREATE OR REPLACE FUNCTION _final_median(float[])
   RETURNS float AS
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
 
CREATE AGGREGATE median(float) (
  SFUNC=array_append,
  STYPE=float[],
  FINALFUNC=_final_median,
  INITCOND='{}'
);

CREATE AGGREGATE median(float[]) (
    SFUNC=array_cat,
    STYPE=float[],
    FINALFUNC=_final_median,
    INITCOND='{}'
);

CREATE TABLE maxmind (
    ip_range int8range,
    ip_low bigint,
    ip_high bigint,
    label varchar);
CREATE INDEX maxmind_ip_range_idx ON maxmind USING GIST (ip_range);

COPY maxmind (ip_low, ip_high, label) FROM '/opt/telescope/resources/GeoIPASNum2-20140804.csv' WITH (FORMAT csv, HEADER false, encoding 'latin1');
UPDATE maxmind SET ip_range = int8range(ip_low, ip_high);
