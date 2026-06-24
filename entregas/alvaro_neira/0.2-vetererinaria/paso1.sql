

SELECT * FROM mascotas;
SELECT * FROM consultas_veterinarias;

SELECT * FROM mascotas WHERE especie = 'Perro';

SELECT nombre, especie, edad_meses FROM mascotas WHERE edad_meses > 24;

SELECT * FROM mascotas WHERE especie = 'Perro' AND edad_meses > 24;

SELECT * FROM mascotas WHERE especie = 'Gato' OR especie = 'Ave';

-- Mascotas con edad entre 12 y 36 meses (incluye los extremos)
SELECT nombre, edad_meses FROM mascotas WHERE edad_meses BETWEEN 12 AND 36;

-- Mascotas que sean perro, gato o ave (igual que varios OR, pero más corto)
SELECT nombre, especie FROM mascotas WHERE especie IN ('Perro', 'Gato', 'Ave');

-- Consultas cuyo motivo contiene la palabra "Vacuna"
SELECT fecha_consulta, motivo, costo
FROM consultas_veterinarias
WHERE motivo LIKE '%Vacuna%';

-- Mascotas de la más vieja a la más joven
SELECT nombre, edad_meses FROM mascotas ORDER BY edad_meses DESC;

-- Mascotas de la más vieja a la más joven
SELECT nombre, edad_meses FROM mascotas ORDER BY edad_meses ASC;

SELECT motivo, costo
FROM consultas_veterinarias
ORDER BY costo DESC
LIMIT;

SELECT nombre, edad_meses
FROM mascotas
ORDER BY edad_meses ASC LIMIT 2;

SELECT DISTINCT especie FROM mascotas;

-- 1) Insertamos una mascota temporal (de Carlos, id 1)
INSERT INTO mascotas (nombre, especie, edad_meses, tutor_id)
VALUES ('Temporal', 'Perro', 1, 1);

-- 2) La borramos por su nombre
DELETE FROM mascotas WHERE nombre = 'Temporal';

SELECT nombre, edad_meses FROM mascotas WHERE nombre = 'Temporal';
