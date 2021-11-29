--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 14.1

-- Started on 2021-11-29 23:29:39

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
-- TOC entry 215 (class 1255 OID 16876)
-- Name: calc_price(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.calc_price() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
	total money;
	price money;
	rent_dur smallint;
	id_ int;
begin
	id_ = new.sklad_id;
	rent_dur = new.rent_duration;
	price = new.price_for_one_month;
	total = rent_dur * price;
	update skladi set total_price = total
	where sklad_id = id_;
	return new;
end;
$$;


ALTER FUNCTION public.calc_price() OWNER TO postgres;

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
    price_for_one_month money NOT NULL,
    rent_duration smallint NOT NULL,
    total_price money
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
-- TOC entry 3346 (class 0 OID 16854)
-- Dependencies: 214
-- Data for Name: all_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.all_users (user_id, is_admin) FROM stdin;
\.


--
-- TOC entry 3343 (class 0 OID 16824)
-- Dependencies: 211
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client (client_id, client_name, client_email) FROM stdin;
\.


--
-- TOC entry 3345 (class 0 OID 16844)
-- Dependencies: 213
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.items (item_id, item_name, item_space, owner) FROM stdin;
\.


--
-- TOC entry 3341 (class 0 OID 16809)
-- Dependencies: 209
-- Data for Name: sklad_owner; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sklad_owner (owner_id, owner_name, owner_email) FROM stdin;
\.


--
-- TOC entry 3342 (class 0 OID 16814)
-- Dependencies: 210
-- Data for Name: skladi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.skladi (sklad_id, owner_id, free_space, total_space, price_for_one_month, rent_duration, total_price) FROM stdin;
\.


--
-- TOC entry 3344 (class 0 OID 16829)
-- Dependencies: 212
-- Data for Name: skladi_client; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.skladi_client (sklad_id, client_id) FROM stdin;
\.


--
-- TOC entry 3196 (class 2606 OID 16859)
-- Name: all_users all_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.all_users
    ADD CONSTRAINT all_users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 3190 (class 2606 OID 16828)
-- Name: client client_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (client_id);


--
-- TOC entry 3194 (class 2606 OID 16848)
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (item_id);


--
-- TOC entry 3186 (class 2606 OID 16813)
-- Name: sklad_owner sklad_owner_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sklad_owner
    ADD CONSTRAINT sklad_owner_pkey PRIMARY KEY (owner_id);


--
-- TOC entry 3192 (class 2606 OID 16833)
-- Name: skladi_client skladi_client_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skladi_client
    ADD CONSTRAINT skladi_client_pkey PRIMARY KEY (sklad_id, client_id);


--
-- TOC entry 3188 (class 2606 OID 16818)
-- Name: skladi skladi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skladi
    ADD CONSTRAINT skladi_pkey PRIMARY KEY (sklad_id);


--
-- TOC entry 3201 (class 2620 OID 16879)
-- Name: skladi calc_price; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER calc_price AFTER INSERT ON public.skladi FOR EACH ROW EXECUTE FUNCTION public.calc_price();


--
-- TOC entry 3200 (class 2606 OID 16849)
-- Name: items items_owner_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_owner_fkey FOREIGN KEY (owner) REFERENCES public.client(client_id) ON DELETE CASCADE;


--
-- TOC entry 3199 (class 2606 OID 16839)
-- Name: skladi_client skladi_client_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skladi_client
    ADD CONSTRAINT skladi_client_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.client(client_id) ON DELETE CASCADE;


--
-- TOC entry 3198 (class 2606 OID 16834)
-- Name: skladi_client skladi_client_sklad_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skladi_client
    ADD CONSTRAINT skladi_client_sklad_id_fkey FOREIGN KEY (sklad_id) REFERENCES public.skladi(sklad_id) ON DELETE CASCADE;


--
-- TOC entry 3197 (class 2606 OID 16819)
-- Name: skladi skladi_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skladi
    ADD CONSTRAINT skladi_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.sklad_owner(owner_id) ON DELETE CASCADE;


-- Completed on 2021-11-29 23:29:40

--
-- PostgreSQL database dump complete
--

