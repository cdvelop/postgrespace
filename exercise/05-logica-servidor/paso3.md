# Ejercicio 3 — Procedimientos

> 🎯 **Qué vas a aprender:** a crear un **procedimiento** que recibe parámetros
> y modifica datos en la base. La diferencia clave con una función: el procedimiento
> actúa, no calcula.

---

## Paso 3.0 — Función vs Procedimiento

| | `FUNCTION` | `PROCEDURE` |
|---|---|---|
| **Propósito** | Calcular o consultar | Modificar datos |
| **Devuelve** | Un valor o tabla | Nada |
| **Se llama con** | `SELECT nombre()` | `CALL nombre()` |

Regla simple: si **lees** → `FUNCTION`. Si **escribes o modificas** → `PROCEDURE`.

---

## Paso 3.1 — Tu primer procedimiento

Vamos a crear `marcar_pagada`: recibe el id de una consulta y la marca como pagada.
Una sola tabla, una sola operación — lo más simple posible.

```sql
CREATE OR REPLACE PROCEDURE marcar_pagada(p_consulta_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE consultas_veterinarias
    SET pagada = TRUE
    WHERE id_consulta = p_consulta_id;
END;
$$;
```

| Parte | Qué significa |
|---|---|
| `LANGUAGE plpgsql` | PL/pgSQL: SQL con bloques, variables y condicionales |
| `BEGIN ... END` | el bloque que se ejecuta |
| `UPDATE ... SET pagada = TRUE` | la acción que realiza |

---

## Paso 3.2 — Llámalo con `CALL`

Primero verifica el estado actual de la consulta 1:

```sql
SELECT id_consulta, motivo, pagada
FROM consultas_veterinarias
WHERE id_consulta = 1;
```

Llama el procedimiento:

```sql
CALL marcar_pagada(1);
```

Verifica que cambió:

```sql
SELECT id_consulta, motivo, pagada
FROM consultas_veterinarias
WHERE id_consulta = 1;
```

El campo `pagada` ahora es `true`. ✅

---

## Paso 3.3 — Agrega un mensaje con `RAISE NOTICE`

`RAISE NOTICE` imprime un mensaje informativo durante la ejecución. Útil para
confirmar qué hizo el procedimiento:

```sql
CREATE OR REPLACE PROCEDURE marcar_pagada(p_consulta_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE consultas_veterinarias
    SET pagada = TRUE
    WHERE id_consulta = p_consulta_id;

    RAISE NOTICE 'Consulta % marcada como pagada', p_consulta_id;
END;
$$;
```

Llámalo de nuevo:

```sql
CALL marcar_pagada(2);
```

En el panel de mensajes de pgAdmin verás:

```
NOTICE:  Consulta 2 marcada como pagada
```

---

## Paso 3.4 — 🧪 Tu turno: procedimiento con lógica

Crea un procedimiento `aplicar_descuento(p_consulta_id INT, p_porcentaje DECIMAL)`
que reduzca el costo de una consulta en el porcentaje indicado.

<details>
<summary>👀 Ver solución</summary>

```sql
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
```

</details>

---

## ✅ Lo que lograste

* **`CREATE PROCEDURE`** → lógica que modifica datos, guardada en el servidor.
* **`LANGUAGE plpgsql`** → SQL procedural con bloques `BEGIN/END`.
* **`CALL`** → invocar un procedimiento desde pgAdmin o psql.
* **`RAISE NOTICE`** → mensajes informativos durante la ejecución.

> 📤 **Entrega:** guarda en `paso3.sql` los dos procedimientos (`marcar_pagada` con
> `RAISE NOTICE` y `aplicar_descuento`) más las llamadas de prueba y los `SELECT`
> de verificación. Adjunta `paso3.png` con captura mostrando el `NOTICE` en pgAdmin.
> Dónde ubicar los archivos: [Entrega](ENTREGA.md).

> 🎓 **Has completado el Set 05.** Ahora la base de datos no solo guarda datos —
> también tiene vistas, funciones y procedimientos que procesan información.
> En el [Set 06](../06-python-veterinaria/README.md) conectarás Python a todo esto.
