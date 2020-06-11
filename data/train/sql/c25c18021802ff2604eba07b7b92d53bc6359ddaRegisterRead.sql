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
-- Name: RegisterRead; Type: TABLE; Schema: public; Owner: sepgroup; Tablespace: 
--

CREATE TABLE "RegisterRead" (
    register_data_id bigint NOT NULL,
    register_read_id bigint NOT NULL,
    gateway_collected_time timestamp without time zone NOT NULL,
    read_time timestamp without time zone NOT NULL,
    register_read_source character varying NOT NULL,
    season smallint NOT NULL
);


ALTER TABLE public."RegisterRead" OWNER TO sepgroup;

--
-- Name: registerread_id_seq; Type: SEQUENCE; Schema: public; Owner: sepgroup
--

CREATE SEQUENCE registerread_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.registerread_id_seq OWNER TO sepgroup;

--
-- Name: registerread_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sepgroup
--

ALTER SEQUENCE registerread_id_seq OWNED BY "RegisterRead".register_read_id;


--
-- Name: register_read_id; Type: DEFAULT; Schema: public; Owner: sepgroup
--

ALTER TABLE ONLY "RegisterRead" ALTER COLUMN register_read_id SET DEFAULT nextval('registerread_id_seq'::regclass);


--
-- Name: RegisterRead_pkey; Type: CONSTRAINT; Schema: public; Owner: sepgroup; Tablespace: 
--

ALTER TABLE ONLY "RegisterRead"
    ADD CONSTRAINT "RegisterRead_pkey" PRIMARY KEY (register_read_id);


--
-- Name: RegisterRead_register_data_id_idx; Type: INDEX; Schema: public; Owner: sepgroup; Tablespace: 
--

CREATE INDEX "RegisterRead_register_data_id_idx" ON "RegisterRead" USING btree (register_data_id);


--
-- Name: RegisterRead_register_read_id_key; Type: INDEX; Schema: public; Owner: sepgroup; Tablespace: 
--

CREATE UNIQUE INDEX "RegisterRead_register_read_id_key" ON "RegisterRead" USING btree (register_read_id);


--
-- Name: RegisterRead_register_data_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sepgroup
--

ALTER TABLE ONLY "RegisterRead"
    ADD CONSTRAINT "RegisterRead_register_data_id_fkey" FOREIGN KEY (register_data_id) REFERENCES "RegisterData"(register_data_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: RegisterRead; Type: ACL; Schema: public; Owner: sepgroup
--

REVOKE ALL ON TABLE "RegisterRead" FROM PUBLIC;
REVOKE ALL ON TABLE "RegisterRead" FROM sepgroup;
GRANT ALL ON TABLE "RegisterRead" TO sepgroup;


--
-- Name: registerread_id_seq; Type: ACL; Schema: public; Owner: sepgroup
--

REVOKE ALL ON SEQUENCE registerread_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE registerread_id_seq FROM sepgroup;
GRANT ALL ON SEQUENCE registerread_id_seq TO sepgroup;


--
-- PostgreSQL database dump complete
--

