-- Vista 1: mascotas con tutor
DROP VIEW IF EXISTS mascotas_con_tutor;

CREATE VIEW mascotas_con_tutor AS
SELECT
    m.nombre        AS mascota,
    m.especie,
    m.edad_meses,
    t.nombre        AS tutor,
    t.telefono
FROM mascotas m
JOIN tutores t ON t.id_tutor = m.tutor_id
ORDER BY t.nombre, m.nombre;

-- Vista 2: historial de consultas
CREATE VIEW historial_consultas AS
SELECT
    m.nombre        AS mascota,
    t.nombre        AS tutor,
    cv.fecha_consulta,
    cv.motivo,
    cv.costo,
    v.nombre        AS veterinario
FROM consultas_veterinarias cv
JOIN mascotas     m ON m.id_mascota      = cv.mascota_id
JOIN tutores      t ON t.id_tutor        = cv.tutor_id
JOIN veterinarios v ON v.id_veterinario  = cv.veterinario_id
ORDER BY cv.fecha_consulta DESC;
