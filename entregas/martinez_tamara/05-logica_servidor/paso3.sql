-- Procedimiento 1: marcar consulta como pagada
CREATE OR REPLACE PROCEDURE marcar_pagada(p_consulta_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE consultas_veterinarias
    SET pagada = TRUE
    WHERE id_consulta = p_consulta_id;
    RAISE NOTICE 'Consulta % marcada como pagada', p_consulta_id;
END;
$$;

-- Llamada de prueba
CALL marcar_pagada(6);

-- Verificación
SELECT id_consulta, motivo, pagada
FROM consultas_veterinarias
WHERE id_consulta = 6;

-- Procedimiento 2: aplicar descuento
CREATE OR REPLACE PROCEDURE aplicar_descuento(p_consulta_id INT, p_porcentaje DECIMAL)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE consultas_veterinarias
    SET costo = costo - (costo * p_porcentaje / 100)
    WHERE id_consulta = p_consulta_id;
    RAISE NOTICE 'Descuento de % por ciento aplicado a consulta %', p_porcentaje, p_consulta_id;
END;
$$;

-- Llamada de prueba
CALL aplicar_descuento(9, 10);

-- Verificación
SELECT id_consulta, motivo, costo
FROM consultas_veterinarias
WHERE id_consulta = 9;
