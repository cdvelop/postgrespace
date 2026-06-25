--
-- PostgreSQL database dump
--

\restrict 48pyPiSXkpB2FapqDfdqw8Ef4A5pwZ5EJKqrkfyuZAgEkoJI1T9O4OgESFmsFC4

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- Name: consulta_servicios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.consulta_servicios (
    consulta_id integer NOT NULL,
    servicio_id integer NOT NULL
);


ALTER TABLE public.consulta_servicios OWNER TO postgres;

--
-- Name: consultas_veterinarias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.consultas_veterinarias (
    id_consulta integer NOT NULL,
    fecha_consulta date NOT NULL,
    motivo character varying(255) NOT NULL,
    costo numeric(6,2),
    pagada boolean DEFAULT false,
    tutor_id integer,
    mascota_id integer,
    veterinario_id integer,
    CONSTRAINT chk_costo_positivo CHECK ((costo >= (0)::numeric))
);


ALTER TABLE public.consultas_veterinarias OWNER TO postgres;

--
-- Name: consultas_veterinarias_id_consulta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.consultas_veterinarias_id_consulta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.consultas_veterinarias_id_consulta_seq OWNER TO postgres;

--
-- Name: consultas_veterinarias_id_consulta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.consultas_veterinarias_id_consulta_seq OWNED BY public.consultas_veterinarias.id_consulta;


--
-- Name: mascotas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mascotas (
    id_mascota integer NOT NULL,
    nombre character varying(50) NOT NULL,
    especie character varying(30),
    edad_meses integer,
    tutor_id integer
);


ALTER TABLE public.mascotas OWNER TO postgres;

--
-- Name: mascotas_id_mascota_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mascotas_id_mascota_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mascotas_id_mascota_seq OWNER TO postgres;

--
-- Name: mascotas_id_mascota_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mascotas_id_mascota_seq OWNED BY public.mascotas.id_mascota;


--
-- Name: servicios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.servicios (
    id_servicio integer NOT NULL,
    nombre character varying(60) NOT NULL,
    precio_base numeric(6,2) NOT NULL,
    CONSTRAINT chk_precio_positivo CHECK ((precio_base > (0)::numeric))
);


ALTER TABLE public.servicios OWNER TO postgres;

--
-- Name: servicios_id_servicio_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.servicios_id_servicio_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.servicios_id_servicio_seq OWNER TO postgres;

--
-- Name: servicios_id_servicio_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.servicios_id_servicio_seq OWNED BY public.servicios.id_servicio;


--
-- Name: tutores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tutores (
    id_tutor integer NOT NULL,
    nombre character varying(50) NOT NULL,
    telefono character varying(15)
);


ALTER TABLE public.tutores OWNER TO postgres;

--
-- Name: tutores_id_tutor_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tutores_id_tutor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tutores_id_tutor_seq OWNER TO postgres;

--
-- Name: tutores_id_tutor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tutores_id_tutor_seq OWNED BY public.tutores.id_tutor;


--
-- Name: veterinarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.veterinarios (
    id_veterinario integer NOT NULL,
    nombre character varying(50) NOT NULL,
    especialidad character varying(50)
);


ALTER TABLE public.veterinarios OWNER TO postgres;

--
-- Name: veterinarios_id_veterinario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.veterinarios_id_veterinario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.veterinarios_id_veterinario_seq OWNER TO postgres;

--
-- Name: veterinarios_id_veterinario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.veterinarios_id_veterinario_seq OWNED BY public.veterinarios.id_veterinario;


--
-- Name: consultas_veterinarias id_consulta; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consultas_veterinarias ALTER COLUMN id_consulta SET DEFAULT nextval('public.consultas_veterinarias_id_consulta_seq'::regclass);


--
-- Name: mascotas id_mascota; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mascotas ALTER COLUMN id_mascota SET DEFAULT nextval('public.mascotas_id_mascota_seq'::regclass);


--
-- Name: servicios id_servicio; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicios ALTER COLUMN id_servicio SET DEFAULT nextval('public.servicios_id_servicio_seq'::regclass);


--
-- Name: tutores id_tutor; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutores ALTER COLUMN id_tutor SET DEFAULT nextval('public.tutores_id_tutor_seq'::regclass);


--
-- Name: veterinarios id_veterinario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.veterinarios ALTER COLUMN id_veterinario SET DEFAULT nextval('public.veterinarios_id_veterinario_seq'::regclass);


--
-- Data for Name: consulta_servicios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.consulta_servicios (consulta_id, servicio_id) FROM stdin;
1	1
1	2
2	1
3	1
3	4
4	1
4	3
5	1
5	4
6	1
7	1
8	1
8	2
9	1
9	5
\.


--
-- Data for Name: consultas_veterinarias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.consultas_veterinarias (id_consulta, fecha_consulta, motivo, costo, pagada, tutor_id, mascota_id, veterinario_id) FROM stdin;
1	2026-01-10	Vacuna anual	30.00	t	1	1	1
2	2026-02-05	Control de peso	18.50	t	1	2	1
3	2026-03-01	Cirugía menor	150.00	t	1	2	2
4	2026-02-20	Desparasitación	22.00	f	1	3	1
5	2026-05-09	Esterilización	120.00	t	2	4	2
6	2026-03-12	Revisión de alas	15.00	f	2	5	3
7	2026-04-02	Limpieza de pecera	12.00	t	2	6	1
8	2026-01-25	Vacuna anual	30.00	t	3	7	1
9	2026-04-18	Radiografía	45.00	f	3	7	2
\.


--
-- Data for Name: mascotas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mascotas (id_mascota, nombre, especie, edad_meses, tutor_id) FROM stdin;
1	Firulais	Perro	24	1
2	Rocky	Perro	60	1
3	Luna	Gato	8	1
4	Michi	Gato	12	2
5	Pepe	Ave	18	2
6	Nemo	Pez	6	2
7	Toby	Perro	36	3
8	Kira	Gato	30	4
\.


--
-- Data for Name: servicios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.servicios (id_servicio, nombre, precio_base) FROM stdin;
1	Consulta general	15.00
2	Vacunación	12.00
3	Desparasitación	10.00
4	Cirugía menor	130.00
5	Radiografía	40.00
6	Baño y peluquería	20.00
\.


--
-- Data for Name: tutores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tutores (id_tutor, nombre, telefono) FROM stdin;
1	Carlos Mendoza	555-1234
2	Ana Gómez	555-5678
3	Luis Martínez	555-9012
4	Sofía Rojas	555-3456
\.


--
-- Data for Name: veterinarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.veterinarios (id_veterinario, nombre, especialidad) FROM stdin;
1	Dra. Paula Ríos	Medicina general
2	Dr. Hugo Salas	Cirugía
3	Dra. Elena Costa	Dermatología
\.


--
-- Name: consultas_veterinarias_id_consulta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.consultas_veterinarias_id_consulta_seq', 9, true);


--
-- Name: mascotas_id_mascota_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mascotas_id_mascota_seq', 9, true);


--
-- Name: servicios_id_servicio_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.servicios_id_servicio_seq', 6, true);


--
-- Name: tutores_id_tutor_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tutores_id_tutor_seq', 4, true);


--
-- Name: veterinarios_id_veterinario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.veterinarios_id_veterinario_seq', 3, true);


--
-- Name: consultas_veterinarias consultas_veterinarias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consultas_veterinarias
    ADD CONSTRAINT consultas_veterinarias_pkey PRIMARY KEY (id_consulta);


--
-- Name: mascotas mascotas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mascotas
    ADD CONSTRAINT mascotas_pkey PRIMARY KEY (id_mascota);


--
-- Name: consulta_servicios pk_consulta_servicio; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consulta_servicios
    ADD CONSTRAINT pk_consulta_servicio PRIMARY KEY (consulta_id, servicio_id);


--
-- Name: servicios servicios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicios
    ADD CONSTRAINT servicios_pkey PRIMARY KEY (id_servicio);


--
-- Name: tutores tutores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutores
    ADD CONSTRAINT tutores_pkey PRIMARY KEY (id_tutor);


--
-- Name: veterinarios veterinarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.veterinarios
    ADD CONSTRAINT veterinarios_pkey PRIMARY KEY (id_veterinario);


--
-- Name: consultas_veterinarias fk_consulta_mascota; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consultas_veterinarias
    ADD CONSTRAINT fk_consulta_mascota FOREIGN KEY (mascota_id) REFERENCES public.mascotas(id_mascota) ON DELETE CASCADE;


--
-- Name: consultas_veterinarias fk_consulta_tutor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consultas_veterinarias
    ADD CONSTRAINT fk_consulta_tutor FOREIGN KEY (tutor_id) REFERENCES public.tutores(id_tutor) ON DELETE CASCADE;


--
-- Name: consultas_veterinarias fk_consulta_veterinario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consultas_veterinarias
    ADD CONSTRAINT fk_consulta_veterinario FOREIGN KEY (veterinario_id) REFERENCES public.veterinarios(id_veterinario);


--
-- Name: consulta_servicios fk_cs_consulta; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consulta_servicios
    ADD CONSTRAINT fk_cs_consulta FOREIGN KEY (consulta_id) REFERENCES public.consultas_veterinarias(id_consulta) ON DELETE CASCADE;


--
-- Name: consulta_servicios fk_cs_servicio; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consulta_servicios
    ADD CONSTRAINT fk_cs_servicio FOREIGN KEY (servicio_id) REFERENCES public.servicios(id_servicio);


--
-- Name: mascotas fk_tutor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mascotas
    ADD CONSTRAINT fk_tutor FOREIGN KEY (tutor_id) REFERENCES public.tutores(id_tutor) ON DELETE CASCADE;


--
-- Name: TABLE consulta_servicios; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.consulta_servicios TO recepcionista;


--
-- Name: TABLE consultas_veterinarias; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.consultas_veterinarias TO recepcionista;


--
-- Name: TABLE mascotas; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.mascotas TO recepcionista;


--
-- Name: TABLE servicios; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.servicios TO recepcionista;


--
-- Name: TABLE tutores; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.tutores TO recepcionista;


--
-- Name: TABLE veterinarios; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.veterinarios TO recepcionista;


--
-- PostgreSQL database dump complete
--

\unrestrict 48pyPiSXkpB2FapqDfdqw8Ef4A5pwZ5EJKqrkfyuZAgEkoJI1T9O4OgESFmsFC4

