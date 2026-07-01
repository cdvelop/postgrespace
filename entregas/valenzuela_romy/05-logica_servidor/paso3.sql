## Paso 3.1
CREATE OR REPLACE PROCEDURE marcar_pagada(p_consulta_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE consultas_veterinarias
    SET pagada = TRUE
    WHERE id_consulta = p_consulta_id;
END;
$$;

## Paso 3.2
SELECT id_consulta, motivo, pagada
FROM consultas_veterinarias
WHERE id_consulta = 1;

CALL marcar_pagada(1);

SELECT id_consulta, motivo, pagada
FROM consultas_veterinarias
WHERE id_consulta = 1;

## Paso 3.3
CREATE OR REPLACE PROCEDURE marcar_pagada(p_consulta_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE consultas_veterinarias
    SET pagada = TRUE
    WHERE id_consulta = p_consulta_id;

    RAISE NOTICE 'Consulta % marcada como pagada', p_consulta_id;
END;
$$;

CALL marcar_pagada(2);

-- Paso 3.4
CREATE OR REPLACE PROCEDURE aplicar_descuento(
    p_consulta_id  INT,
    p_porcentaje   DECIMAL
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE consultas_veterinarias
    SET costo = costo * (1 - p_porcentaje / 100)
    WHERE id_consulta = p_consulta_id;

    RAISE NOTICE 'Descuento de % aplicado a consulta %', p_porcentaje, p_consulta_id;
END;
$$;

** Aplica 10% de descuento a la consulta 3:
CALL aplicar_descuento(3, 10);

** Verifica:
SELECT id_consulta, costo FROM consultas_veterinarias WHERE id_consulta = 3;