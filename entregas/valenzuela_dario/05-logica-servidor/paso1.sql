-- CREACIÓN MASCOTAS CON TUTOR
En pgAdmin, ejecuta esto sobre veterinariadb:

CREATE VIEW mascotas_con_tutor AS
SELECT
    m.nombre        AS mascota,
    m.especie,
    t.nombre        AS tutor,
    t.telefono
FROM mascotas m
JOIN tutores t ON t.id_tutor = m.tutor_id;
Ahora consulta la vista como si fuera una tabla:

SELECT * FROM mascotas_con_tutor;
Verás las 8 mascotas con el nombre y teléfono de su tutor, sin escribir el JOIN.

Filtra sobre ella igual que con una tabla:

SELECT * FROM mascotas_con_tutor WHERE especie = 'Perro';


--CREACIÓN HISTORIAL CONSULTAS
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
Prueba:

SELECT * FROM historial_consultas;
SELECT * FROM historial_consultas WHERE tutor = 'Carlos Mendoza';
