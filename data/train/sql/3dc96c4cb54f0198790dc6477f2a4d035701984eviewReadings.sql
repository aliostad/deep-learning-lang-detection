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
-- Name: viewReadings; Type: VIEW; Schema: public; Owner: daniel
--

CREATE VIEW "viewReadings" AS
    SELECT DISTINCT ON ("Interval".end_time, "MeterData".meter_name, "Reading".channel) "Interval".end_time, "MeterData".meter_name, "Reading".channel, "Reading".raw_value, "Reading".value, "Reading".uom, "IntervalReadData".start_time, "IntervalReadData".end_time AS ird_end_time FROM ((("MeterData" JOIN "IntervalReadData" ON (("MeterData".meter_data_id = "IntervalReadData".meter_data_id))) JOIN "Interval" ON (("IntervalReadData".interval_read_data_id = "Interval".interval_read_data_id))) JOIN "Reading" ON (("Interval".interval_id = "Reading".interval_id))) ORDER BY "Interval".end_time, "MeterData".meter_name, "Reading".channel;


ALTER TABLE public."viewReadings" OWNER TO daniel;

--
-- Name: viewReadings; Type: ACL; Schema: public; Owner: daniel
--

REVOKE ALL ON TABLE "viewReadings" FROM PUBLIC;
REVOKE ALL ON TABLE "viewReadings" FROM daniel;
GRANT ALL ON TABLE "viewReadings" TO daniel;
GRANT ALL ON TABLE "viewReadings" TO sepgroup;


--
-- PostgreSQL database dump complete
--

