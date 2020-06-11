SELECT
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
