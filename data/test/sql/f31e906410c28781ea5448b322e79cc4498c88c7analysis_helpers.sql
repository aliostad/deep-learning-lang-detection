-- Creates a view on top of the results of running a CrowdFlower job by adding a few columns that
-- highlight issues. These include:
--
-- number_inconsistent : the "highest" house number is the same or lower than the "lowest",
--                       ignoring the respective letters
-- letter_inconsistent : the number part of the house numbers is the same but the letter part of \
--                       the"highest" is the same or lower than the "lowest"

-- thanks to https://wiki.postgresql.org/wiki/Aggregate_Median
CREATE OR REPLACE FUNCTION _final_median(NUMERIC[])
   RETURNS NUMERIC AS
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

DROP AGGREGATE IF EXISTS median(NUMERIC) CASCADE;
CREATE AGGREGATE median(NUMERIC) (
  SFUNC=array_append,
  STYPE=NUMERIC[],
  FINALFUNC=_final_median,
  INITCOND='{}'
);

DROP VIEW IF EXISTS r2 CASCADE;
CREATE VIEW r2 AS
	WITH temp2 AS (
		WITH temp AS
		(
			SELECT
				r.*,
				CAST(substring(r.lowest_house_number from '^(\d+)') AS NUMERIC) AS lowest_house_number_without_letters,
				CAST(substring(r.highest_house_number from '^(\d+)') AS NUMERIC) AS highest_house_number_without_letters,
				UPPER(substring(r.lowest_house_number from '([A-Z]+)$')) AS lowest_house_number_letter,
				UPPER(substring(r.highest_house_number from '([A-Z]+)$')) AS highest_house_number_letter
			FROM r
		)
		SELECT
			temp.*,
			(
				(lowest_house_number_without_letters = 0) OR
				(highest_house_number_without_letters = 0)
			) AS zero_inconsistent,
			(
				(house_numbers_found = 'yes') AND
				(lowest_house_number_without_letters >= highest_house_number_without_letters)
			) AS number_inconsistent,
			(
				(house_numbers_found = 'yes') AND
				(lowest_house_number_without_letters = highest_house_number_without_letters) AND
				(lowest_house_number_letter >= highest_house_number_letter)
			) AS letter_inconsistent
		FROM temp
	)
	SELECT
		temp2.*,
		(zero_inconsistent OR number_inconsistent OR letter_inconsistent) AS inconsistent
	FROM temp2;
