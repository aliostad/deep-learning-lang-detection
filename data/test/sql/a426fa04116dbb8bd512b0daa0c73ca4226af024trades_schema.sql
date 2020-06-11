--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.0
-- Dumped by pg_dump version 9.5.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: trades; Type: SCHEMA; Schema: -; Owner: traders
--

CREATE SCHEMA trades;


SET default_with_oids = false;

--
-- Name: d_hld_svxy; Type: TABLE; Schema: trades; Owner: traders
--

CREATE TABLE d_hld_svxy (
    date date,
    security text,
    typeid integer,
    shares double precision,
    exposure double precision,
    marketvalue double precision,
    UNIQUE(date, typeid)
);


--
-- Name: d_hld_uvxy; Type: TABLE; Schema: trades; Owner: traders
--

CREATE TABLE d_hld_uvxy (
    date date,
    security text,
    typeid integer,
    shares double precision,
    exposure double precision,
    marketvalue double precision,
    UNIQUE (date, typeid)
);


--
-- Name: d_nav_svxy; Type: TABLE; Schema: trades; Owner: traders
--

CREATE TABLE d_nav_svxy (
    date date,
    nav double precision,
    priornav double precision,
    navchangepct double precision,
    navchange double precision,
    shares double precision,
    assets double precision
);


--
-- Name: d_nav_uvxy; Type: TABLE; Schema: trades; Owner: traders
--

CREATE TABLE d_nav_uvxy (
    date date,
    nav double precision,
    priornav double precision,
    navchangepct double precision,
    navchange double precision,
    shares double precision,
    assets double precision
);


--
-- Name: d_q_spy; Type: TABLE; Schema: trades; Owner: traders
--

CREATE TABLE d_q_spy (
    date date,
    close double precision,
    volume double precision,
    open double precision,
    high double precision,
    low double precision
);


--
-- Name: d_q_svxy; Type: TABLE; Schema: trades; Owner: traders
--

CREATE TABLE d_q_svxy (
    date date,
    close double precision,
    volume double precision,
    open double precision,
    high double precision,
    low double precision
);


--
-- Name: d_q_uvxy; Type: TABLE; Schema: trades; Owner: traders
--

CREATE TABLE d_q_uvxy (
    date date,
    close double precision,
    volume double precision,
    open double precision,
    high double precision,
    low double precision
);


--
-- Name: d_q_vix; Type: TABLE; Schema: trades; Owner: traders
--

CREATE TABLE d_q_vix (
    date date,
    close double precision,
    volume double precision,
    open double precision,
    high double precision,
    low double precision
);


--
-- Name: f_d_q_vx; Type: TABLE; Schema: trades; Owner: traders
--

CREATE TABLE f_d_q_vx (
    date date,
    future text,
    open double precision,
    high double precision,
    low double precision,
    close double precision,
    settle double precision,
    change double precision,
    volume double precision,
    efp double precision,
    openinterest double precision
);


--
-- PostgreSQL database dump complete
--

