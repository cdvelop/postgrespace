SELECT COUNT(*) AS total_mascotas FROM mascotas;

SELECT COUNT(*) AS total_perros FROM mascotas WHERE especie = 'Perro';

SELECT
    SUM(costo) AS total_facturado,
    AVG(costo) AS costo_promedio,
    MIN(costo) AS mas_barata,
    MAX(costo) AS mas_cara
FROM consultas_veterinarias;

SELECT especie, COUNT(*) AS cantidad
FROM mascotas
GROUP BY especie
ORDER BY cantidad DESC;

SELECT tutor_id, SUM(costo) AS total_gastado
FROM consultas_veterinarias
GROUP BY tutor_id
ORDER BY total_gastado DESC;

SELECT mascota_id, SUM(costo) AS total_gastado
FROM consultas_veterinarias
GROUP BY mascota_id
ORDER BY total_gastado DESC;

SELECT mascota_id, ROUND(AVG(costo), 2) AS promedio
FROM consultas_veterinarias
GROUP BY mascota_id
ORDER BY promedio DESC;

SELECT tutor_id, SUM(costo) AS total_gastado
FROM consultas_veterinarias
GROUP BY tutor_id
HAVING SUM(costo) > 100
ORDER BY total_gastado DESC;

SELECT especie, COUNT(*) AS cantidad
FROM mascotas
GROUP BY especie
HAVING COUNT(*) >=2; 

