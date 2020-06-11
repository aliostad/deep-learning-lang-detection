-- Get all distinct energy readings where distinct is defined
-- as a unique tuple of ("MeterData".meter_name, "Interval".end_time, "Reading".channel)
--
-- This query eliminates duplicate reading data, if present.
-- meco_v2 will be built to prevent duplicate reading data.
--
-- @author Daniel Zhang (張道博)

SELECT

DISTINCT ON ("Interval".end_time,"MeterData".meter_name,"Reading".channel)

	"Interval".end_time,
    "MeterData".meter_name,
    "Reading".channel,
    "Reading".raw_value,
    "Reading".value,
    "Reading".uom,
    "IntervalReadData".start_time,
    "IntervalReadData".end_time AS ird_end_time
FROM
    (
        (
            (
                "MeterData"
                JOIN "IntervalReadData" ON (
                    (
                        "MeterData".meter_data_id = "IntervalReadData".meter_data_id
                    )
                )
            )
            JOIN "Interval" ON (
                (
                    "IntervalReadData".interval_read_data_id = "Interval".interval_read_data_id
                )
            )
        )
        JOIN "Reading" ON (
            (
                "Interval".interval_id = "Reading".interval_id
            )
        )
    )
ORDER BY
    "Interval".end_time,
    "MeterData".meter_name,
    "Reading".channel
