-- SELECT AS FROM INNER JOIN ON ORDER BY DESC ---INNER JOIN une filas que coinciden en ambas tablas. Veamos cada consulta con el nombre del tutor y de la mascota (en vez de sus id)
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
--- SELECT AS FROM LEFT JOIN ON WHERE IS NULL --- Un LEFT JOIN trae todas las filas de la tabla izquierda, aunque no tengan pareja en la derecha (en ese caso, las columnas de la derecha salen como NULL). Perfecto para detectar huecos.
SELECT m.nombre AS mascota, m.especie, c.id_consulta
FROM mascotas m
LEFT JOIN consultas_veterinarias c ON m.id_mascota = c.mascota_id
WHERE c.id_consulta IS NULL;
--- SELECT AS COUNT AS SUM FROM INNER JOIN ON GROUP BY ORDER BY DESC ---Ahora combinamos JOIN con lo del Ejercicio 2
SELECT
    t.nombre              AS tutor,
    COUNT(c.id_consulta)  AS num_consultas,
    SUM(c.costo)          AS total_gastado
FROM tutores t
INNER JOIN consultas_veterinarias c ON t.id_tutor = c.tutor_id
GROUP BY t.nombre
ORDER BY total_gastado DESC;
--- SELECT AS AS FROM INNER JOIN ON GROUP BY ORDER BY DESC ---muestra, por especie, cuánto se ha facturado en total (une mascotas con consultas_veterinarias y agrupa por especie).
SELECT 
    m.especie         AS especie,
    SUM(c.costo)      AS total_facturado
FROM mascotas m
INNER JOIN consultas_veterinarias c ON m.id_mascota = c.mascota_id
GROUP BY m.especie
ORDER BY total_facturado DESC;
--- SLECT FROM WHERE (SELECT AVG FROM ORDER BY DESC --- Una subconsulta es un SELECT metido dentro de otro. Sirve cuando necesitas un valor calculado para poder filtrar.
SELECT motivo, costo
FROM consultas_veterinarias
WHERE costo > (SELECT AVG(costo) FROM consultas_veterinarias)
ORDER BY costo DESC;
--- SELECT AS FROM INNER JOIN ON WHERE (SELECT FROM) ---muestra el nombre del/los tutor(es) que tienen la mascota más vieja.
SELECT t.nombre, m.nombre AS mascota, m.edad_meses
FROM tutores t
INNER JOIN mascotas m ON t.id_tutor = m.tutor_id
WHERE m.edad_meses = (SELECT MAX(edad_meses) FROM mascotas);
