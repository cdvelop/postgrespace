## Paso 2.1
CREATE OR REPLACE FUNCTION costo_total_tutor(p_tutor_id INT)
RETURNS DECIMAL AS $$
    SELECT COALESCE(SUM(costo), 0)
    FROM consultas_veterinarias
    WHERE tutor_id = p_tutor_id;
$$ LANGUAGE sql;

SELECT costo_total_tutor(1);   -- Carlos
SELECT costo_total_tutor(2);   -- Ana
SELECT costo_total_tutor(4);   -- Sofía (devuelve 0: no tiene consultas)

## Paso 2.3
CREATE OR REPLACE FUNCTION mascotas_sin_consulta()
RETURNS TABLE (mascota VARCHAR, especie VARCHAR) AS $$
    SELECT m.nombre, m.especie
    FROM mascotas m
    LEFT JOIN consultas_veterinarias cv ON cv.mascota_id = m.id_mascota
    WHERE cv.id_consulta IS NULL;
$$ LANGUAGE sql;

SELECT * FROM mascotas_sin_consulta();