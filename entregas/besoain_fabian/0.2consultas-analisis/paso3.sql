SELECT
    c.fecha_consulta AS "Fecha",
    t.nombre         AS "Tutor",
    m.nombre         AS "Mascota",
    c.motivo         AS "Motivo",
    c.costo          AS "Costo"
FROM consultas_veterinarias c
INNER JOIN tutores  t ON c.tutor_id   = t.id_tutor
INNER JOIN mascotas m ON c.mascota_id = m.id_mascota
ORDER BY c.costo DESC;

SELECT m.nombre AS mascota, m.especie, c.id_consulta
FROM mascotas m
LEFT JOIN consultas_veterinarias c ON m.id_mascota = c.mascota_id
WHERE c.id_consulta IS NULL;

SELECT
    t.nombre              AS tutor,
    COUNT(c.id_consulta)  AS num_consultas,
    SUM(c.costo)          AS total_gastado
FROM tutores t
INNER JOIN consultas_veterinarias c ON t.id_tutor = c.tutor_id
GROUP BY t.nombre
ORDER BY total_gastado DESC;

SELECT
    m.especie         AS especie,
    SUM(c.costo)      AS total_facturado
FROM mascotas m
INNER JOIN consultas_veterinarias c ON m.id_mascota = c.mascota_id
GROUP BY m.especie
ORDER BY total_facturado DESC;

SELECT motivo, costo
FROM consultas_veterinarias
WHERE costo > (SELECT AVG(costo) FROM consultas_veterinarias)
ORDER BY costo DESC;

SELECT t.nombre, m.nombre AS mascota, m.edad_meses
FROM tutores t
INNER JOIN mascotas m ON t.id_tutor = m.tutor_id
WHERE m.edad_meses = (SELECT MAX(edad_meses) FROM mascotas);
