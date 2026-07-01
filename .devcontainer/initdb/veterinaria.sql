-- =============================================================
-- Script de inicialización automática.
-- Se ejecuta UNA SOLA VEZ, la primera vez que el data directory
-- de PostgreSQL está vacío (mecanismo docker-entrypoint-initdb.d).
--
-- Crea la base de datos de ejemplo "veterinariadb" con la PRIMERA
-- tabla (tutores) ya creada y con 2 registros de ejemplo.
-- Las demás tablas (mascotas, consultas_veterinarias) las crean
-- los alumnos durante los ejercicios (ver carpeta exercise/).
-- =============================================================

CREATE DATABASE veterinariadb;

\connect veterinariadb

-- -------------------------------------------------------------
-- Tabla 1: Tutores  (ya creada para el alumno)
-- -------------------------------------------------------------
CREATE TABLE tutores (
    id_tutor SERIAL PRIMARY KEY,
    nombre   VARCHAR(50) NOT NULL,
    telefono VARCHAR(15)
);

-- 2 registros de ejemplo. El alumno agregará más en el Ejercicio 1.
INSERT INTO tutores (nombre, telefono) VALUES
('Carlos Mendoza', '555-1234'),
('Ana Gómez',      '555-5678');
