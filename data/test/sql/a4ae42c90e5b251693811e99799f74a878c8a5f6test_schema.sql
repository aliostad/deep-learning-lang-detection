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
-- Name: world; Type: TABLE; Schema: public; Owner: pg_dump_test; Tablespace:
--

CREATE TABLE world (
    name character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    active boolean NOT NULL,
    uuid bytea,
    id integer NOT NULL
);


ALTER TABLE public.world OWNER TO pg_dump_test;

--
-- Name: world_id_seq; Type: SEQUENCE; Schema: public; Owner: pg_dump_test
--

CREATE SEQUENCE world_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.world_id_seq OWNER TO pg_dump_test;

--
-- Name: world_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pg_dump_test
--

ALTER SEQUENCE world_id_seq OWNED BY world.id;

--
-- Name: country; Type: TABLE; Schema: public; Owner: pg_dump_test; Tablespace:
--

CREATE TABLE country (
    name character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    active boolean NOT NULL,
    uuid bytea,
    id integer NOT NULL,
    world_id integer,
    bigness numeric(10,2)
);


ALTER TABLE public.country OWNER TO pg_dump_test;

--
-- Name: country_id_seq; Type: SEQUENCE; Schema: public; Owner: pg_dump_test
--

CREATE SEQUENCE country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.country_id_seq OWNER TO pg_dump_test;

--
-- Name: country_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pg_dump_test
--

ALTER SEQUENCE country_id_seq OWNED BY country.id;


--
-- Name: city; Type: TABLE; Schema: public; Owner: pg_dump_test; Tablespace:
--

CREATE TABLE city (
    name character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    active boolean NOT NULL,
    uuid bytea,
    id integer NOT NULL,
    country_id integer,
    weight integer,
    is_big boolean DEFAULT false NOT NULL,
    pseudonym character varying(255) DEFAULT ''::character varying NOT NULL,
    description text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.city OWNER TO pg_dump_test;

--
-- Name: city_id_seq; Type: SEQUENCE; Schema: public; Owner: pg_dump_test
--

CREATE SEQUENCE city_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.city_id_seq OWNER TO pg_dump_test;

--
-- Name: city_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pg_dump_test
--

ALTER SEQUENCE city_id_seq OWNED BY city.id;


--
-- Name: person; Type: TABLE; Schema: public; Owner: pg_dump_test; Tablespace:
--

CREATE TABLE person (
    name character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    active boolean NOT NULL,
    uuid bytea,
    id integer NOT NULL,
    city_id integer,
    person_type character varying(255) NOT NULL
);


ALTER TABLE public.person OWNER TO pg_dump_test;

--
-- Name: person_id_seq; Type: SEQUENCE; Schema: public; Owner: pg_dump_test
--

CREATE SEQUENCE person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.person_id_seq OWNER TO pg_dump_test;

--
-- Name: person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pg_dump_test
--

ALTER SEQUENCE person_id_seq OWNED BY person.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: pg_dump_test
--

ALTER TABLE ONLY world ALTER COLUMN id SET DEFAULT nextval('world_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: pg_dump_test
--

ALTER TABLE ONLY country ALTER COLUMN id SET DEFAULT nextval('country_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: pg_dump_test
--

ALTER TABLE ONLY city ALTER COLUMN id SET DEFAULT nextval('city_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: pg_dump_test
--

ALTER TABLE ONLY person ALTER COLUMN id SET DEFAULT nextval('person_id_seq'::regclass);


--
-- Name: _country_worldid_name_uc; Type: CONSTRAINT; Schema: public; Owner: pg_dump_test; Tablespace:
--

ALTER TABLE ONLY country
    ADD CONSTRAINT _country_worldid_name_uc UNIQUE (world_id, name);


--
-- Name: _city_countryid_name_uc; Type: CONSTRAINT; Schema: public; Owner: pg_dump_test; Tablespace:
--

ALTER TABLE ONLY city
    ADD CONSTRAINT _city_countryid_name_uc UNIQUE (country_id, name);




--
-- Name: world_pkey; Type: CONSTRAINT; Schema: public; Owner: pg_dump_test; Tablespace:
--

ALTER TABLE ONLY world
    ADD CONSTRAINT world_pkey PRIMARY KEY (id);


--
-- Name: person_pkey; Type: CONSTRAINT; Schema: public; Owner: pg_dump_test; Tablespace:
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_pkey PRIMARY KEY (id);


--
-- Name: country_pkey; Type: CONSTRAINT; Schema: public; Owner: pg_dump_test; Tablespace:
--

ALTER TABLE ONLY country
    ADD CONSTRAINT country_pkey PRIMARY KEY (id);


--
-- Name: city_pkey; Type: CONSTRAINT; Schema: public; Owner: pg_dump_test; Tablespace:
--

ALTER TABLE ONLY city
    ADD CONSTRAINT city_pkey PRIMARY KEY (id);


--
-- Name: _world_uuid_active_ix; Type: INDEX; Schema: public; Owner: pg_dump_test; Tablespace:
--

CREATE INDEX _world_uuid_active_ix ON world USING btree (uuid, active);


--
-- Name: _person_cityid_name_active_ix; Type: INDEX; Schema: public; Owner: pg_dump_test; Tablespace:
--

CREATE INDEX _person_cityid_name_active_ix ON person USING btree (city_id, name, active);


--
-- Name: _person_cityid_uuid_active_ix; Type: INDEX; Schema: public; Owner: pg_dump_test; Tablespace:
--

CREATE INDEX _person_cityid_uuid_active_ix ON person USING btree (city_id, uuid, active);


--
-- Name: _country_worldid_name_active_ix; Type: INDEX; Schema: public; Owner: pg_dump_test; Tablespace:
--

CREATE INDEX _country_worldid_name_active_ix ON country USING btree (world_id, name, active);


--
-- Name: _country_worldid_uuid_active_ix; Type: INDEX; Schema: public; Owner: pg_dump_test; Tablespace:
--

CREATE INDEX _country_worldid_uuid_active_ix ON country USING btree (world_id, uuid, active);


--
-- Name: _city_countryid_name_active_ix; Type: INDEX; Schema: public; Owner: pg_dump_test; Tablespace:
--

CREATE INDEX _city_countryid_name_active_ix ON city USING btree (country_id, name, active);


--
-- Name: _city_countryid_uuid_active_ix; Type: INDEX; Schema: public; Owner: pg_dump_test; Tablespace:
--

CREATE INDEX _city_countryid_uuid_active_ix ON city USING btree (country_id, uuid, active);



--
-- Name: person_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pg_dump_test
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_city_id_fkey FOREIGN KEY (city_id) REFERENCES city(id);


--
-- Name: country_world_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pg_dump_test
--

ALTER TABLE ONLY country
    ADD CONSTRAINT country_world_id_fkey FOREIGN KEY (world_id) REFERENCES world(id);


--
-- Name: city_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pg_dump_test
--

ALTER TABLE ONLY city
    ADD CONSTRAINT city_country_id_fkey FOREIGN KEY (country_id) REFERENCES country(id);


--
-- PostgreSQL database dump complete
--

