## Paso 2.1
SELECT COUNT(*) AS total_mascotas FROM mascotas;
SELECT COUNT(*) AS total_perros FROM mascotas WHERE especie = 'Perro';

## Paso 2.2
SELECT
    SUM(costo) AS total_facturado,
    AVG(costo) AS costo_promedio,
    MIN(costo) AS mas_barata,
    MAX(costo) AS mas_cara
FROM consultas_veterinarias;

## Redondeando
SELECT
    SUM(costo) AS total_facturado,
    ROUND(AVG(costo), 2) AS costo_promedio,
    MIN(costo) AS mas_barata,
    MAX(costo) AS mas_cara
FROM consultas_veterinarias;

## Paso 2.3
SELECT especie, COUNT(*) AS cantidad
FROM mascotas
GROUP BY especie
ORDER BY cantidad DESC;

SELECT tutor_id, SUM(costo) AS total_gastado
FROM consultas_veterinarias
GROUP BY tutor_id
ORDER BY total_gastado DESC;
**Costo calculado**
SELECT mascota_id, ROUND(AVG(costo), 2) AS promedio
FROM consultas_veterinarias
GROUP BY mascota_id
ORDER BY promedio DESC;

## Paso 2.4
SELECT tutor_id, SUM(costo) AS total_gastado
FROM consultas_veterinarias
GROUP BY tutor_id
HAVING SUM(costo) > 100
ORDER BY total_gastado DESC;
**Especies con 2 o más mascotas**
SELECT especie, COUNT(*) AS cantidad
FROM mascotas
GROUP BY especie
HAVING COUNT(*) >= 2;