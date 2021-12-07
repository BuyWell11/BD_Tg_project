--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 14.1

-- Started on 2021-12-07 19:43:16

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
-- TOC entry 214 (class 1259 OID 16854)
-- Name: all_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.all_users (
    user_id integer NOT NULL,
    is_admin boolean DEFAULT false
);


ALTER TABLE public.all_users OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 16824)
-- Name: client; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client (
    client_id integer NOT NULL,
    client_name character(100) NOT NULL,
    client_email character(100) NOT NULL
);


ALTER TABLE public.client OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16901)
-- Name: contracts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contracts (
    contract_id integer NOT NULL,
    sklad_id integer NOT NULL,
    client_id integer NOT NULL,
    rent_duration integer NOT NULL,
    total_price integer
);


ALTER TABLE public.contracts OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 16844)
-- Name: items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.items (
    item_id integer NOT NULL,
    item_name character(100) NOT NULL,
    item_space smallint NOT NULL,
    owner integer NOT NULL
);


ALTER TABLE public.items OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 16809)
-- Name: sklad_owner; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sklad_owner (
    owner_id integer NOT NULL,
    owner_name character(100) NOT NULL,
    owner_email character(100) NOT NULL
);


ALTER TABLE public.sklad_owner OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 16814)
-- Name: skladi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.skladi (
    sklad_id integer NOT NULL,
    owner_id integer NOT NULL,
    free_space smallint,
    total_space smallint NOT NULL,
    price_for_one_month integer DEFAULT 0
);


ALTER TABLE public.skladi OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 16829)
-- Name: skladi_client; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.skladi_client (
    sklad_id integer NOT NULL,
    client_id integer NOT NULL
);


ALTER TABLE public.skladi_client OWNER TO postgres;

--
-- TOC entry 3354 (class 0 OID 16854)
-- Dependencies: 214
-- Data for Name: all_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.all_users (user_id, is_admin) FROM stdin;
345	f
\.


--
-- TOC entry 3351 (class 0 OID 16824)
-- Dependencies: 211
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client (client_id, client_name, client_email) FROM stdin;
123	Alex                                                                                                	algentok@gmail.com                                                                                  
\.


--
-- TOC entry 3355 (class 0 OID 16901)
-- Dependencies: 215
-- Data for Name: contracts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contracts (contract_id, sklad_id, client_id, rent_duration, total_price) FROM stdin;
1	5	5667	10	\N
\.


--
-- TOC entry 3353 (class 0 OID 16844)
-- Dependencies: 213
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.items (item_id, item_name, item_space, owner) FROM stdin;
2134	fgfdsg                                                                                              	500	123
213546	fgfdsgdfgfdg                                                                                        	600	123
21800	fgfdsgdsczxc                                                                                        	870	123
\.


--
-- TOC entry 3349 (class 0 OID 16809)
-- Dependencies: 209
-- Data for Name: sklad_owner; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sklad_owner (owner_id, owner_name, owner_email) FROM stdin;
123	dafdsf                                                                                              	fsgfsg                                                                                              
124	dafdsfretre                                                                                         	fsgfsgfsdf                                                                                          
\.


--
-- TOC entry 3350 (class 0 OID 16814)
-- Dependencies: 210
-- Data for Name: skladi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.skladi (sklad_id, owner_id, free_space, total_space, price_for_one_month) FROM stdin;
1	123	1500	1500	0
2	123	100	1500	0
3	124	2000	6000	0
4	124	5000	6000	0
5	123	4000	7000	6750
\.


--
-- TOC entry 3352 (class 0 OID 16829)
-- Dependencies: 212
-- Data for Name: skladi_client; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.skladi_client (sklad_id, client_id) FROM stdin;
\.


--
-- TOC entry 3202 (class 2606 OID 16859)
-- Name: all_users all_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.all_users
    ADD CONSTRAINT all_users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 3196 (class 2606 OID 16828)
-- Name: client client_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (client_id);


--
-- TOC entry 3204 (class 2606 OID 16905)
-- Name: contracts contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_pkey PRIMARY KEY (contract_id);


--
-- TOC entry 3200 (class 2606 OID 16848)
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (item_id);


--
-- TOC entry 3191 (class 2606 OID 16813)
-- Name: sklad_owner sklad_owner_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sklad_owner
    ADD CONSTRAINT sklad_owner_pkey PRIMARY KEY (owner_id);


--
-- TOC entry 3198 (class 2606 OID 16833)
-- Name: skladi_client skladi_client_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skladi_client
    ADD CONSTRAINT skladi_client_pkey PRIMARY KEY (sklad_id, client_id);


--
-- TOC entry 3193 (class 2606 OID 16818)
-- Name: skladi skladi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skladi
    ADD CONSTRAINT skladi_pkey PRIMARY KEY (sklad_id);


--
-- TOC entry 3194 (class 1259 OID 16890)
-- Name: client_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX client_name ON public.client USING btree (client_name);


--
-- TOC entry 3189 (class 1259 OID 16891)
-- Name: owner_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX owner_name ON public.sklad_owner USING btree (owner_name);


--
-- TOC entry 3209 (class 2606 OID 16906)
-- Name: contracts contracts_sklad_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_sklad_id_fkey FOREIGN KEY (sklad_id) REFERENCES public.skladi(sklad_id) ON DELETE CASCADE;


--
-- TOC entry 3208 (class 2606 OID 16849)
-- Name: items items_owner_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_owner_fkey FOREIGN KEY (owner) REFERENCES public.client(client_id) ON DELETE CASCADE;


--
-- TOC entry 3207 (class 2606 OID 16839)
-- Name: skladi_client skladi_client_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skladi_client
    ADD CONSTRAINT skladi_client_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.client(client_id) ON DELETE CASCADE;


--
-- TOC entry 3206 (class 2606 OID 16834)
-- Name: skladi_client skladi_client_sklad_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skladi_client
    ADD CONSTRAINT skladi_client_sklad_id_fkey FOREIGN KEY (sklad_id) REFERENCES public.skladi(sklad_id) ON DELETE CASCADE;


--
-- TOC entry 3205 (class 2606 OID 16819)
-- Name: skladi skladi_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skladi
    ADD CONSTRAINT skladi_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.sklad_owner(owner_id) ON DELETE CASCADE;


-- Completed on 2021-12-07 19:43:17

--
-- PostgreSQL database dump complete
--

