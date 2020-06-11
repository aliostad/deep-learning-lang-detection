--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: IntervalReadData; Type: TABLE; Schema: public; Owner: sepgroup; Tablespace: 
--

CREATE TABLE "IntervalReadData" (
    interval_read_data_id bigint NOT NULL,
    meter_data_id bigint NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    interval_length smallint NOT NULL,
    number_intervals integer NOT NULL
);


ALTER TABLE public."IntervalReadData" OWNER TO sepgroup;

--
-- Name: intervalreaddata_id_seq; Type: SEQUENCE; Schema: public; Owner: sepgroup
--

CREATE SEQUENCE intervalreaddata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.intervalreaddata_id_seq OWNER TO sepgroup;

--
-- Name: intervalreaddata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sepgroup
--

ALTER SEQUENCE intervalreaddata_id_seq OWNED BY "IntervalReadData".interval_read_data_id;


--
-- Name: interval_read_data_id; Type: DEFAULT; Schema: public; Owner: sepgroup
--

ALTER TABLE ONLY "IntervalReadData" ALTER COLUMN interval_read_data_id SET DEFAULT nextval('intervalreaddata_id_seq'::regclass);


--
-- Name: IntervalReadData_pkey; Type: CONSTRAINT; Schema: public; Owner: sepgroup; Tablespace: 
--

ALTER TABLE ONLY "IntervalReadData"
    ADD CONSTRAINT "IntervalReadData_pkey" PRIMARY KEY (interval_read_data_id);


--
-- Name: IntervalReadData_interval_read_data_id_key; Type: INDEX; Schema: public; Owner: sepgroup; Tablespace: 
--

CREATE UNIQUE INDEX "IntervalReadData_interval_read_data_id_key" ON "IntervalReadData" USING btree (interval_read_data_id);


--
-- Name: meter_data_id_idx; Type: INDEX; Schema: public; Owner: sepgroup; Tablespace: 
--

CREATE INDEX meter_data_id_idx ON "IntervalReadData" USING btree (meter_data_id);


--
-- Name: IntervalReadData_meter_data_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sepgroup
--

ALTER TABLE ONLY "IntervalReadData"
    ADD CONSTRAINT "IntervalReadData_meter_data_id_fkey" FOREIGN KEY (meter_data_id) REFERENCES "MeterData"(meter_data_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: IntervalReadData; Type: ACL; Schema: public; Owner: sepgroup
--

REVOKE ALL ON TABLE "IntervalReadData" FROM PUBLIC;
REVOKE ALL ON TABLE "IntervalReadData" FROM sepgroup;
GRANT ALL ON TABLE "IntervalReadData" TO sepgroup;


--
-- Name: intervalreaddata_id_seq; Type: ACL; Schema: public; Owner: sepgroup
--

REVOKE ALL ON SEQUENCE intervalreaddata_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE intervalreaddata_id_seq FROM sepgroup;
GRANT ALL ON SEQUENCE intervalreaddata_id_seq TO sepgroup;


--
-- PostgreSQL database dump complete
--

