-- Función 1: costo total por tutor
DROP FUNCTION IF EXISTS costo_total_tutor(INT);

CREATE FUNCTION costo_total_tutor(p_tutor_id INT)
RETURNS DECIMAL AS $$
    SELECT COALESCE(SUM(costo), 0)
    FROM consultas_veterinarias cv
    WHERE cv.tutor_id = p_tutor_id;
$$ LANGUAGE sql;

-- Función 2: mascotas sin consulta
CREATE OR REPLACE FUNCTION mascotas_sin_consulta()
RETURNS TABLE(nombre TEXT, especie TEXT) AS $$
    SELECT m.nombre, m.especie
    FROM mascotas m
    LEFT JOIN consultas_veterinarias cv ON cv.mascota_id = m.id_mascota
    WHERE cv.id_consulta IS NULL;
$$ LANGUAGE sql;
