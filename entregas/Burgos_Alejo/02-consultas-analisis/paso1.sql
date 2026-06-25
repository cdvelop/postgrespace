-- ## Ejercicio 2 ## --

-- Paso 1.0
-- Se usó el script setup.sql para este ejercicio
SELECT * FROM TUTORES;
SELECT * FROM mascotas;
SELECT * FROM consultas_veterinarias;

-- Paso 1.1
SELECT * FROM mascotas WHERE especie = 'Perro';
SELECT nombre, especie, edad_meses FROM mascotas WHERE edad_meses > 24;

-- Paso 1.2
SELECT * FROM mascotas WHERE especie = 'Perro' AND edad_meses > 24;
--
SELECT * FROM mascotas WHERE especie = 'Gato' OR especie = 'Ave';

-- Paso 1.3
SELECT nombre, edad_meses FROM mascotas WHERE edad_meses BETWEEN 12 AND 36;
SELECT nombre, especie FROM mascotas WHERE especie IN ('Perro', 'Gato', 'Ave');

-- Paso 1.4
-- Consultas cuyo motivo contiene la palabra "Vacuna"
SELECT fecha_consulta, motivo, costo
FROM consultas_veterinarias
WHERE motivo LIKE '%Vacuna%';

-- Paso 1.5
-- Mascotas de la más vieja a la más joven
SELECT nombre, edad_meses FROM mascotas ORDER BY edad_meses DESC;

SELECT motivo, costo
FROM consultas_veterinarias	
ORDER BY costo DESC
LIMIT 3;

--
SELECT nombre, edad_meses FROM mascotas ORDER BY edad_meses ASC LIMIT 2;

-- Paso 1.6
SELECT DISTINCT especie FROM mascotas;

-- Paso 1.7

-- 1) Insertamos una mascota temporal (de Carlos, id 1)
INSERT INTO mascotas (nombre, especie, edad_meses, tutor_id)
VALUES ('Temporal', 'Perro', 1, 1);

-- 2) La borramos por su nombre
DELETE FROM mascotas WHERE nombre = 'Temporal';