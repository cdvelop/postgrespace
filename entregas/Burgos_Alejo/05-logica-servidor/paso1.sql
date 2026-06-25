-- Paso 1.1

CREATE VIEW mascotas_con_tutor AS
SELECT
    m.nombre        AS mascota,
    m.especie,
    t.nombre        AS tutor,
    t.telefono
FROM mascotas m
JOIN tutores t ON t.id_tutor = m.tutor_id;

SELECT * FROM mascotas_con_tutor;

SELECT * FROM mascotas_con_tutor WHERE especie = 'Perro';

-- Paso 1.3

CREATE OR REPLACE VIEW mascotas_con_tutor AS
SELECT
    m.nombre        AS mascota,
    m.especie,
    m.raza,
    t.nombre        AS tutor,
    t.telefono
FROM mascotas m
JOIN tutores t ON t.id_tutor = m.tutor_id
ORDER BY t.nombre, m.nombre;

SELECT * FROM mascotas_con_tutor;

-- Paso 1.4

CREATE VIEW historial_consultas AS
SELECT
    m.nombre        AS mascota,
    t.nombre        AS tutor,
    cv.fecha_consulta,
    cv.motivo,
    cv.costo,
    v.nombre        AS veterinario
FROM consultas_veterinarias cv
JOIN mascotas    m ON m.id_mascota     = cv.mascota_id
JOIN tutores     t ON t.id_tutor       = cv.tutor_id
JOIN veterinarios v ON v.id_veterinario = cv.veterinario_id
ORDER BY cv.fecha_consulta DESC;

SELECT * FROM historial_consultas;
SELECT * FROM historial_consultas WHERE tutor = 'Carlos Mendoza';