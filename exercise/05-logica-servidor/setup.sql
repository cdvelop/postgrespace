-- =============================================================
-- Set 04 — Punto de partida (estado "Set 03 terminado")
--
-- Ejecuta este script UNA VEZ al empezar el Set 04, en el Query Tool
-- de pgAdmin conectado a la base "veterinariadb".
--
-- Deja la base con las 6 tablas del Set 03 ya completas (tutores,
-- mascotas, veterinarios, consultas_veterinarias con CHECK/DEFAULT,
-- servicios y consulta_servicios). Sobre ESE punto de partida
-- crearás funciones y procedimientos almacenados.
--
-- Es SEGURO volver a ejecutarlo: borra y recrea todo, dejando siempre
-- el mismo punto de partida.
--
-- ⚠️ OJO: reemplaza el contenido de las tablas. Si tienes datos que
-- quieras conservar, sácales un backup antes (ver docs/BACKUPS.md).
-- =============================================================

DROP TABLE IF EXISTS consulta_servicios     CASCADE;
DROP TABLE IF EXISTS servicios              CASCADE;
DROP TABLE IF EXISTS consultas_veterinarias CASCADE;
DROP TABLE IF EXISTS mascotas               CASCADE;
DROP TABLE IF EXISTS veterinarios           CASCADE;
DROP TABLE IF EXISTS tutores                CASCADE;

-- Limpia funciones y procedimientos de intentos anteriores
DROP FUNCTION  IF EXISTS costo_total_tutor(INT)          CASCADE;
DROP FUNCTION  IF EXISTS resumen_tutor(INT)              CASCADE;
DROP PROCEDURE IF EXISTS registrar_consulta(INT, INT, INT, VARCHAR, DECIMAL) CASCADE;

-- -------------------------------------------------------------
-- Tabla 1: tutores
-- -------------------------------------------------------------
CREATE TABLE tutores (
    id_tutor SERIAL PRIMARY KEY,
    nombre   VARCHAR(50) NOT NULL,
    telefono VARCHAR(15)
);

INSERT INTO tutores (nombre, telefono) VALUES
('Carlos Mendoza', '555-1234'),
('Ana Gómez',      '555-5678'),
('Luis Martínez',  '555-9012'),
('Sofía Rojas',    '555-3456');

-- -------------------------------------------------------------
-- Tabla 2: mascotas
-- -------------------------------------------------------------
CREATE TABLE mascotas (
    id_mascota SERIAL PRIMARY KEY,
    nombre     VARCHAR(50) NOT NULL,
    especie    VARCHAR(30),
    edad_meses INT,
    tutor_id   INT,
    CONSTRAINT fk_tutor
        FOREIGN KEY (tutor_id)
        REFERENCES tutores(id_tutor)
        ON DELETE CASCADE
);

INSERT INTO mascotas (nombre, especie, edad_meses, tutor_id) VALUES
('Firulais', 'Perro', 24, 1),
('Rocky',    'Perro', 60, 1),
('Luna',     'Gato',   8, 1),
('Michi',    'Gato',  12, 2),
('Pepe',     'Ave',   18, 2),
('Nemo',     'Pez',    6, 2),
('Toby',     'Perro', 36, 3),
('Kira',     'Gato',  30, 4);

-- -------------------------------------------------------------
-- Tabla 3: veterinarios
-- -------------------------------------------------------------
CREATE TABLE veterinarios (
    id_veterinario SERIAL PRIMARY KEY,
    nombre         VARCHAR(50) NOT NULL,
    especialidad   VARCHAR(50)
);

INSERT INTO veterinarios (nombre, especialidad) VALUES
('Dra. Paula Ríos',  'Medicina general'),
('Dr. Hugo Salas',   'Cirugía'),
('Dra. Elena Costa', 'Dermatología');

-- -------------------------------------------------------------
-- Tabla 4: consultas_veterinarias (con CHECK y DEFAULT del Set 03)
-- -------------------------------------------------------------
CREATE TABLE consultas_veterinarias (
    id_consulta    SERIAL PRIMARY KEY,
    fecha_consulta DATE    NOT NULL,
    motivo         VARCHAR(255) NOT NULL,
    costo          DECIMAL(6,2),
    pagada         BOOLEAN DEFAULT false,
    tutor_id       INT,
    mascota_id     INT,
    veterinario_id INT,
    CONSTRAINT fk_consulta_tutor
        FOREIGN KEY (tutor_id)
        REFERENCES tutores(id_tutor)
        ON DELETE CASCADE,
    CONSTRAINT fk_consulta_mascota
        FOREIGN KEY (mascota_id)
        REFERENCES mascotas(id_mascota)
        ON DELETE CASCADE,
    CONSTRAINT fk_consulta_veterinario
        FOREIGN KEY (veterinario_id)
        REFERENCES veterinarios(id_veterinario),
    CONSTRAINT chk_costo_positivo CHECK (costo >= 0)
);

INSERT INTO consultas_veterinarias (fecha_consulta, motivo, costo, pagada, tutor_id, mascota_id, veterinario_id) VALUES
('2026-01-10', 'Vacuna anual',       30.00, true,  1, 1, 1),
('2026-02-05', 'Control de peso',    18.50, true,  1, 2, 1),
('2026-03-01', 'Cirugía menor',     150.00, true,  1, 2, 2),
('2026-02-20', 'Desparasitación',    22.00, false, 1, 3, 1),
('2026-05-09', 'Esterilización',    120.00, true,  2, 4, 2),
('2026-03-12', 'Revisión de alas',   15.00, false, 2, 5, 3),
('2026-04-02', 'Limpieza de pecera', 12.00, true,  2, 6, 1),
('2026-01-25', 'Vacuna anual',       30.00, true,  3, 7, 1),
('2026-04-18', 'Radiografía',        45.00, false, 3, 7, 2);

-- -------------------------------------------------------------
-- Tabla 5: servicios
-- -------------------------------------------------------------
CREATE TABLE servicios (
    id_servicio SERIAL PRIMARY KEY,
    nombre      VARCHAR(60)   NOT NULL,
    precio_base DECIMAL(6,2)  NOT NULL,
    CONSTRAINT chk_precio_positivo CHECK (precio_base > 0)
);

INSERT INTO servicios (nombre, precio_base) VALUES
('Consulta general',   15.00),
('Vacunación',         12.00),
('Desparasitación',    10.00),
('Cirugía menor',     130.00),
('Radiografía',        40.00),
('Baño y peluquería',  20.00);

-- -------------------------------------------------------------
-- Tabla 6: consulta_servicios (tabla puente N:M)
-- -------------------------------------------------------------
CREATE TABLE consulta_servicios (
    consulta_id INT NOT NULL,
    servicio_id INT NOT NULL,
    CONSTRAINT pk_consulta_servicio
        PRIMARY KEY (consulta_id, servicio_id),
    CONSTRAINT fk_cs_consulta
        FOREIGN KEY (consulta_id)
        REFERENCES consultas_veterinarias(id_consulta)
        ON DELETE CASCADE,
    CONSTRAINT fk_cs_servicio
        FOREIGN KEY (servicio_id)
        REFERENCES servicios(id_servicio)
);

INSERT INTO consulta_servicios (consulta_id, servicio_id) VALUES
(1, 1), (1, 2),
(2, 1),
(3, 1), (3, 4),
(4, 1), (4, 3),
(5, 1), (5, 4),
(6, 1),
(7, 1),
(8, 1), (8, 2),
(9, 1), (9, 5);

-- Listo. Ahora sigue el paso 1 del Set 04.
