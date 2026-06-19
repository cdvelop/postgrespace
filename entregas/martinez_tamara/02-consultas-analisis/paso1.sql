
-- AND
SELECT * FROM mascotas WHERE especie = 'Perro' AND edad_meses > 24;
-- OR
SELECT * FROM mascotas WHERE especie = 'Gato' OR especie = 'Ave';
-- BETWEEN  AND
SELECT nombre, edad_meses FROM mascotas WHERE edad_meses BETWEEN 12 AND 36;
-- WHERE  IN
SELECT nombre, especie FROM mascotas WHERE especie IN ('Perro', 'Gato', 'Ave');
-- WHERE  LIKE
SELECT fecha_consulta, motivo, costo
FROM consultas_veterinarias
WHERE motivo LIKE '%Vacuna%';
-- ORDER BY  DESC
SELECT nombre, edad_meses FROM mascotas ORDER BY edad_meses DESC;
-- ORDEN BY  DESC  LIMIT 
SELECT motivo, costo
FROM consultas_veterinarias
ORDER BY costo DESC
LIMIT 3;
-- ORDEN BY  ASC LIMIT 
SELECT nombre, edad_meses FROM mascotas ORDER BY edad_meses ASC LIMIT 2;
-- DISTINCT  FROM
SELECT DISTINCT especie FROM mascotas;
-- DELETE FROM WHERE
DELETE FROM mascotas WHERE nombre = 'Temporal';

