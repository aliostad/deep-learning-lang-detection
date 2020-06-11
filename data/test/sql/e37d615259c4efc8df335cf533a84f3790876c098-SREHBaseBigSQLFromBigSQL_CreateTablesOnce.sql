-- drop table alex_sr.sre_trip_info1_hbase;
-- Create Once
CREATE HBASE TABLE alex_sr.sre_trip_info1_hbase (
        trip_vin string
        , trip_number string
        , trip_start_timestamp string
        , trip_end_timestamp string
        , trip_start_day string
        , trip_start_hr string
        , trip_start_min string
        , trip_end_day string
        , trip_end_hr string
        , trip_end_min string
        , trip_duration bigint
        , trip_length_miles double
        , trip_length_kms double
        , trip_hard_break_count bigint
        , trip_fast_accel_count bigint
        , trip_night_time_drive_min double
        , trip_minute_details string)
COLUMN MAPPING (
        KEY MAPPED BY (trip_vin, trip_number)
        , trip_summary:trip_start_timestamp MAPPED BY (trip_start_timestamp) ENCODING STRING
        , trip_summary:trip_end_timestamp MAPPED BY (trip_end_timestamp) ENCODING STRING
        , trip_summary:trip_start_day MAPPED BY (trip_start_day) ENCODING STRING
        , trip_summary:trip_start_hr MAPPED BY (trip_start_hr) ENCODING STRING
        , trip_summary:trip_start_min MAPPED BY (trip_start_min) ENCODING STRING
        , trip_summary:trip_end_day MAPPED BY (trip_end_day) ENCODING STRING
        , trip_summary:trip_end_hr MAPPED BY (trip_end_hr) ENCODING STRING
        , trip_summary:trip_end_min MAPPED BY (trip_end_min) ENCODING STRING
        , trip_summary:trip_duration MAPPED BY (trip_duration) ENCODING STRING
        , trip_summary:trip_length_miles MAPPED BY (trip_length_miles) ENCODING STRING
        , trip_summary:trip_length_kms MAPPED BY (trip_length_kms) ENCODING STRING
        , trip_summary:trip_hard_break_count MAPPED BY (trip_hard_break_count) ENCODING STRING
        , trip_summary:trip_fast_accel_count MAPPED BY (trip_fast_accel_count) ENCODING STRING
        , trip_summary:trip_night_time_drive_min MAPPED BY (trip_night_time_drive_min) ENCODING STRING
        , trip_summary:trip_minute_details MAPPED BY (trip_minute_details)  ENCODING STRING)
DEFAULT ENCODING STRING; 
 
 -- Load Always
 
LOAD USING FILE URL
  "/biginsights/hive/warehouse/alex_sr.db/sr_trip_info/sr_trip_info"
INTO HBASE TABLE alex_sr.sre_trip_info1_hbase APPEND
;

--select * from alex_sr.sre_trip_info1_hbase;


--drop table alex_sr.sre_vin_summary_hbase;


CREATE HBASE TABLE alex_sr.sre_vin_summary1_hbase
(vin_number string, 
 period_flg string, 
 period string, 
 miles double, 
 miles_delta double, 
 night_time double, 
 night_time_delta double, 
 accel_count integer, 
 accel_count_delta integer, 
 hard_break_count integer, 
 hard_break_count_delta integer
 )
 COLUMN MAPPING
 (KEY   MAPPED BY (vin_number, period_flg, period),
 trip_summary:miles MAPPED BY (miles) ENCODING STRING,
 trip_summary:miles_delta MAPPED BY (miles_delta) ENCODING STRING,
 trip_summary:night_time MAPPED BY (night_time) ENCODING STRING,
 trip_summary:night_time_delta MAPPED BY (night_time_delta) ENCODING STRING, 
 trip_summary:accel_count MAPPED BY (accel_count) ENCODING STRING,
 trip_summary:accel_count_delta MAPPED BY (accel_count_delta) ENCODING STRING,
 trip_summary:hard_break_count MAPPED BY (hard_break_count) ENCODING STRING,
 trip_summary:hard_break_count_delta MAPPED BY (hard_break_count_delta) ENCODING STRING
 )
 DEFAULT ENCODING STRING; 



--- Load Always 
LOAD USING FILE URL
  "/biginsights/hive/warehouse/alex_sr.db/sr_vin_summary"
INTO HBASE TABLE alex_sr.sre_vin_summary1_hbase APPEND
;

--select * from alex_sr.sre_vin_summary1_hbase;