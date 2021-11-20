--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 14.1

-- Started on 2021-11-21 00:54:29

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3338 (class 1262 OID 16777)
-- Name: project; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE project WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Russian_Russia.1251';


ALTER DATABASE project OWNER TO postgres;

\connect project

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 210 (class 1259 OID 16783)
-- Name: client; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client (
    client_id integer NOT NULL,
    reserved_sklad integer NOT NULL,
    total_amount money
);


ALTER TABLE public.client OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 16788)
-- Name: items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.items (
    item_id integer NOT NULL,
    name character(30) NOT NULL,
    space integer NOT NULL
);


ALTER TABLE public.items OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 16803)
-- Name: sklad_owner; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sklad_owner (
    owner_id integer NOT NULL,
    price_for_month_for_one_space money,
    item integer NOT NULL
);


ALTER TABLE public.sklad_owner OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 16778)
-- Name: skladi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.skladi (
    sklad_id smallint NOT NULL,
    client_id integer NOT NULL,
    owner_id integer NOT NULL,
    item_id integer NOT NULL,
    free_space integer,
    space integer
);


ALTER TABLE public.skladi OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 16793)
-- Name: staff; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staff (
    stuff_id integer NOT NULL,
    full_name character(1) NOT NULL,
    "position" character(1) NOT NULL,
    sklad_id integer NOT NULL
);


ALTER TABLE public.staff OWNER TO postgres;

--
-- TOC entry 3329 (class 0 OID 16783)
-- Dependencies: 210
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3330 (class 0 OID 16788)
-- Dependencies: 211
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3332 (class 0 OID 16803)
-- Dependencies: 213
-- Data for Name: sklad_owner; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3328 (class 0 OID 16778)
-- Dependencies: 209
-- Data for Name: skladi; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3331 (class 0 OID 16793)
-- Dependencies: 212
-- Data for Name: staff; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3182 (class 2606 OID 16787)
-- Name: client client_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (client_id);


--
-- TOC entry 3184 (class 2606 OID 16792)
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (item_id);


--
-- TOC entry 3188 (class 2606 OID 16807)
-- Name: sklad_owner sklad_owner_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sklad_owner
    ADD CONSTRAINT sklad_owner_pkey PRIMARY KEY (owner_id);


--
-- TOC entry 3180 (class 2606 OID 16782)
-- Name: skladi skladi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skladi
    ADD CONSTRAINT skladi_pkey PRIMARY KEY (sklad_id);


--
-- TOC entry 3186 (class 2606 OID 16797)
-- Name: staff staff_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_pkey PRIMARY KEY (stuff_id);


-- Completed on 2021-11-21 00:54:29

--
-- PostgreSQL database dump complete
--

