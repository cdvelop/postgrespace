-- Función que devuelve un número
CREATE OR REPLACE FUNCTION costo_total_tutor(p_tutor_id INT)
RETURNS DECIMAL AS $$
    SELECT COALESCE(SUM(costo), 0)
    FROM consultas_veterinarias
    WHERE tutor_id = p_tutor_id;
$$ LANGUAGE sql;

-- Ver los 4 select 
SELECT costo_total_tutor(id) FROM (VALUES (1), (2), (3), (4)) AS t(id);

-- Función que devuelve una tabla,  mascotas_sin_consulta()
CREATE OR REPLACE FUNCTION mascotas_sin_consulta()
RETURNS TABLE (mascota VARCHAR, especie VARCHAR) AS $$
    SELECT m.nombre, m.especie
    FROM mascotas m
    LEFT JOIN consultas_veterinarias cv ON cv.mascota_id = m.id_mascota
    WHERE cv.id_consulta IS NULL;
$$ LANGUAGE sql;

-- Llámala:
SELECT * FROM mascotas_sin_consulta();
