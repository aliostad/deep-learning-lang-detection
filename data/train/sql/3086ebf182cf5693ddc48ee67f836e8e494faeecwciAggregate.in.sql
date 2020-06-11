-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
-- wdb - weather and water data storage
--
-- Copyright (C) 2011 met.no
--
--  Contact information:
--  Norwegian Meteorological Institute
--  Box 43 Blindern
--  0313 OSLO
--  NORWAY
--  E-mail: wdb@met.no
--
--  This is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- Implement the statistical function median in WDB.
-- Based on code from http://wiki.postgresql.org/wiki/Aggregate_Median
CREATE OR REPLACE FUNCTION __WDB_SCHEMA__.final_median(float[])
	RETURNS float AS
$$
	SELECT AVG(val)
	FROM (
			SELECT val
			FROM unnest($1) as val
			ORDER BY 1
			LIMIT  2 - MOD(array_upper($1, 1), 2)
			OFFSET CEIL(array_upper($1, 1) / 2.0) - 1
	) as sub;
$$
LANGUAGE 'sql' IMMUTABLE strict;

DROP AGGREGATE IF EXISTS wci.median(float) CASCADE;
CREATE AGGREGATE wci.median( float ) (
	SFUNC=array_append,
	STYPE=float[],
	FINALFUNC=__WDB_SCHEMA__.final_median,
	INITCOND='{}'
);          				 