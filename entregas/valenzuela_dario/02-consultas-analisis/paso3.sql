-- LEFT JOIN ¿Qué mascotas nunca han tenido una consulta?
SELECT m.nombre AS mascota, m.especie, c.id_consulta
FROM mascotas m
LEFT JOIN consultas_veterinarias c ON m.id_mascota = c.mascota_id
WHERE c.id_consulta IS NULL;

-- JOIN + GROUP BY ¿Cuánto ha gastado cada tutor, mostrando su nombre y cuántas consultas hizo?
SELECT
    t.nombre              AS tutor,
    COUNT(c.id_consulta)  AS num_consultas,
    SUM(c.costo)          AS total_gastado
FROM tutores t
INNER JOIN consultas_veterinarias c ON t.id_tutor = c.tutor_id
GROUP BY t.nombre
ORDER BY total_gastado DESC;


-- Subconsulta ¿Qué consultas costaron más que el promedio?
SELECT motivo, costo
FROM consultas_veterinarias
WHERE costo > (SELECT AVG(costo) FROM consultas_veterinarias)
ORDER BY costo DESC;
