--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: meter_V_readings_and_locations; Type: VIEW; Schema: public; Owner: eileen
--

CREATE VIEW "meter_V_readings_and_locations" AS
    SELECT "LocationRecords".service_pt_latitude, "LocationRecords".service_pt_longitude, "LocationRecords".service_pt_height, "LocationRecords".device_util_id, "LocationRecords".device_serial_no, "LocationRecords".device_status, "MeterData".util_device_id, "MeterData".meter_name, "IntervalReadData".start_time, "IntervalReadData".end_time, "Reading".channel, "Reading".uom, "Reading".value FROM (((("LocationRecords" JOIN "MeterData" ON (((("LocationRecords".device_util_id)::bpchar = "MeterData".util_device_id) AND (("LocationRecords".device_util_id)::bpchar = "MeterData".util_device_id)))) JOIN "IntervalReadData" ON (("MeterData".meter_data_id = "IntervalReadData".meter_data_id))) JOIN "Interval" ON (("IntervalReadData".interval_read_data_id = "Interval".interval_read_data_id))) JOIN "Reading" ON (("Interval".interval_id = "Reading".interval_id))) WHERE ("Reading".channel = 4);


ALTER TABLE public."meter_V_readings_and_locations" OWNER TO eileen;

--
-- Name: meter_V_readings_and_locations; Type: ACL; Schema: public; Owner: eileen
--

REVOKE ALL ON TABLE "meter_V_readings_and_locations" FROM PUBLIC;
REVOKE ALL ON TABLE "meter_V_readings_and_locations" FROM eileen;
GRANT ALL ON TABLE "meter_V_readings_and_locations" TO eileen;
GRANT ALL ON TABLE "meter_V_readings_and_locations" TO sepgroup;


--
-- PostgreSQL database dump complete
--

