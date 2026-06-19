-- COUNT (*) AS  FROM    (*) ---> CONTAR TODOS 
SELECT COUNT(*) AS total_mascotas FROM mascotas;
-- COUNT (*) AS FROM WHERE
SELECT COUNT(*) AS total_perros FROM mascotas WHERE especie = 'Perro';
-- SUM --> SUMA TODOS LOS VALORES
-- AVG --> HACE UN PROMEDIO
-- MIN --> EL MAS BARATO 
-- MAX --> MAS CARO
SELECT
    SUM(costo) AS total_facturado,
    AVG(costo) AS costo_promedio,
    MIN(costo) AS mas_barata,
    MAX(costo) AS mas_cara
FROM consultas_veterinarias;
-- COUNT (*) AS  FROM   GROUP BY  ORDEN BY  ---> AGRUPA POR ESPECIE Y ORDENA DE MAYOR A MENOR 
SELECT especie, COUNT(*) AS cantidad
FROM mascotas
GROUP BY especie
ORDER BY cantidad DESC;
-- SELECT (AVG(COSTO), 2) AS FROM GROUP BY  ORDER BY DESC  --- CALCULA EL COSTO PROMEDIO POR CADA MASCOTA  (mascota_id)
SELECT mascota_id, ROUND(AVG(costo), 2) AS promedio
FROM consultas_veterinarias
GROUP BY mascota_id
ORDER BY promedio DESC;
-- SELECT AS FROM GROUP BY HAVING    ORDER BY   DESC  --- HAVING filtra grupos (resultados de la agrupación). Tutores que han gastado más de 100 en total:
SELECT tutor_id, SUM(costo) AS total_gastado
FROM consultas_veterinarias
GROUP BY tutor_id
HAVING SUM(costo) > 100
ORDER BY total_gastado DESC;
-- SELECT COUNT(*) AS FROM GROUP BY HAVING COUNT --- muestra las especies que tengan 2 o más mascotas.
SELECT especie, COUNT(*) AS cantidad
FROM mascotas
GROUP BY especie
HAVING COUNT(*) >= 2;
