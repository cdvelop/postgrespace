-- GROUP BY ¿Cuántas mascotas hay de cada especie?

SELECT especie, COUNT(*) AS cantidad
FROM mascotas
GROUP BY especie
ORDER BY cantidad DESC;

-- Cuánto ha facturado cada tutor (por su id):
SELECT tutor_id, SUM(costo) AS total_gastado
FROM consultas_veterinarias
GROUP BY tutor_id
ORDER BY total_gastado DESC;

-- costo promedio de consulta por cada mascota (mascota_id).
SELECT mascota_id, ROUND(AVG(costo), 2) AS promedio
FROM consultas_veterinarias
GROUP BY mascota_id
ORDER BY promedio DESC;


-- HAVING Tutores que han gastado más de 100 en total:
SELECT tutor_id, SUM(costo) AS total_gastado
FROM consultas_veterinarias
GROUP BY tutor_id
HAVING SUM(costo) > 100
ORDER BY total_gastado DESC;

-- especies que tengan 2 o más mascotas.
SELECT especie, COUNT(*) AS cantidad
FROM mascotas
GROUP BY especie
HAVING COUNT(*) >= 2;
