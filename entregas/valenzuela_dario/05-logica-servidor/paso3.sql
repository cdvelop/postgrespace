-- PROCEDIMIENTO marcar pagada
Vamos a crear marcar_pagada: recibe el id de una consulta y la marca como pagada. Una sola tabla, una sola operación — lo más simple posible.

CREATE OR REPLACE PROCEDURE marcar_pagada(p_consulta_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE consultas_veterinarias
    SET pagada = TRUE
    WHERE id_consulta = p_consulta_id;
END;
$$;

--Llamarlo con CALL
--Primero verifica el estado actual de la consulta 1:

SELECT id_consulta, motivo, pagada
FROM consultas_veterinarias
WHERE id_consulta = 1;

--Llama el procedimiento:
CALL marcar_pagada(1);

--Verifica que cambió:
SELECT id_consulta, motivo, pagada
FROM consultas_veterinarias
WHERE id_consulta = 1;
--El campo pagada ahora es true. ✅


--Agrega un mensaje con RAISE NOTICE
--RAISE NOTICE imprime un mensaje informativo durante la ejecución. Útil para confirmar qué hizo el procedimiento:

CREATE OR REPLACE PROCEDURE marcar_pagada(p_consulta_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE consultas_veterinarias
    SET pagada = TRUE
    WHERE id_consulta = p_consulta_id;

    RAISE NOTICE 'Consulta % marcada como pagada', p_consulta_id;
END;
$$;

--Llámalo de nuevo:
CALL marcar_pagada(2);

--En el panel de mensajes de pgAdmin verás:
NOTICE:  Consulta 2 marcada como pagada


-- Crear un procedimiento aplicar_descuento(p_consulta_id INT, p_porcentaje DECIMAL) que reduzca el costo de una consulta en el porcentaje indicado.

CREATE OR REPLACE PROCEDURE aplicar_descuento(
    p_consulta_id  INT,
    p_porcentaje   DECIMAL
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE consultas_veterinarias
    SET costo = costo * (1 - p_porcentaje / 100)
    WHERE id_consulta = p_consulta_id;

    RAISE NOTICE 'Descuento de %% aplicado a consulta %', p_porcentaje, p_consulta_id;
END;
$$;

-- Aplica 10% de descuento a la consulta 3:
CALL aplicar_descuento(3, 10);

-- Verifica:
SELECT id_consulta, costo FROM consultas_veterinarias WHERE id_consulta = 3;
