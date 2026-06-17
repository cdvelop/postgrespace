-- =============================================================
-- Set 02 — Punto de partida ("Ejercicio 1 ya terminado" + datos)
--
-- Ejecuta este script UNA VEZ al empezar el Set 02, en el Query Tool
-- de pgAdmin conectado a la base "veterinariadb".
--
-- ¿Para qué sirve? Deja la base exactamente en el estado que tendrías
-- al terminar el Set 01 (las 3 tablas creadas) y le agrega datos de
-- práctica variados para que las consultas del Set 02 sean interesantes.
--
-- Es SEGURO volver a ejecutarlo: borra y recrea todo, dejando siempre
-- el mismo punto de partida. Úsalo también si tu base se reinició al
-- reconstruir el codespace o si quieres empezar limpio.
--
-- ⚠️ OJO: reemplaza el contenido de las 3 tablas. Si tienes datos del
-- Set 01 que quieras conservar, sácales un backup antes (ver docs/BACKUPS.md).
-- =============================================================

-- Borramos en orden inverso a las dependencias (CASCADE por si acaso).
DROP TABLE IF EXISTS consultas_veterinarias CASCADE;
DROP TABLE IF EXISTS mascotas             CASCADE;
DROP TABLE IF EXISTS tutores              CASCADE;

-- -------------------------------------------------------------
-- Tabla 1: tutores
-- -------------------------------------------------------------
CREATE TABLE tutores (
    id_tutor SERIAL PRIMARY KEY,
    nombre   VARCHAR(50) NOT NULL,
    telefono VARCHAR(15)
);

INSERT INTO tutores (nombre, telefono) VALUES
('Carlos Mendoza', '555-1234'),   -- id 1
('Ana Gómez',      '555-5678'),   -- id 2
('Luis Martínez',  '555-9012'),   -- id 3
('Sofía Rojas',    '555-3456');   -- id 4

-- -------------------------------------------------------------
-- Tabla 2: mascotas  (relación 1:N con tutores)
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
('Firulais', 'Perro', 24, 1),   -- id 1
('Rocky',    'Perro', 60, 1),   -- id 2
('Luna',     'Gato',   8, 1),   -- id 3
('Michi',    'Gato',  12, 2),   -- id 4
('Pepe',     'Ave',   18, 2),   -- id 5
('Nemo',     'Pez',    6, 2),   -- id 6
('Toby',     'Perro', 36, 3),   -- id 7
('Kira',     'Gato',  30, 4);   -- id 8  (de Sofía: a propósito SIN consultas)

-- -------------------------------------------------------------
-- Tabla 3: consultas_veterinarias  (2 FK: a tutores y a mascotas)
-- -------------------------------------------------------------
CREATE TABLE consultas_veterinarias (
    id_consulta    SERIAL PRIMARY KEY,
    fecha_consulta DATE NOT NULL,
    motivo         VARCHAR(255) NOT NULL,
    costo          DECIMAL(6,2),
    tutor_id       INT,
    mascota_id     INT,
    CONSTRAINT fk_consulta_tutor
        FOREIGN KEY (tutor_id)
        REFERENCES tutores(id_tutor)
        ON DELETE CASCADE,
    CONSTRAINT fk_consulta_mascota
        FOREIGN KEY (mascota_id)
        REFERENCES mascotas(id_mascota)
        ON DELETE CASCADE
);

INSERT INTO consultas_veterinarias (fecha_consulta, motivo, costo, tutor_id, mascota_id) VALUES
('2026-01-10', 'Vacuna anual',      30.00, 1, 1),   -- Firulais
('2026-02-05', 'Control de peso',   18.50, 1, 2),   -- Rocky
('2026-03-01', 'Cirugía menor',    150.00, 1, 2),   -- Rocky
('2026-02-20', 'Desparasitación',   22.00, 1, 3),   -- Luna
('2026-05-09', 'Esterilización',   120.00, 2, 4),   -- Michi
('2026-03-12', 'Revisión de alas',  15.00, 2, 5),   -- Pepe
('2026-04-02', 'Limpieza de pecera',12.00, 2, 6),   -- Nemo
('2026-01-25', 'Vacuna anual',      30.00, 3, 7),   -- Toby
('2026-04-18', 'Radiografía',       45.00, 3, 7);   -- Toby

-- Listo. Comprueba con:
--   SELECT * FROM tutores;
--   SELECT * FROM mascotas;
--   SELECT * FROM consultas_veterinarias;
