# Ejercicio 3 — Procedimiento almacenado y psql en práctica

> 🎯 **Qué vas a aprender:** la diferencia entre una función y un **procedimiento**,
> cuándo usar cada uno, y cómo invocar todo lo que creaste desde **psql** en la terminal,
> tal como se hace en un servidor real.

---

## Paso 3.0 — Función vs Procedimiento: ¿cuál usar?

| | `FUNCTION` | `PROCEDURE` |
|---|---|---|
| **Retorna** | Siempre un valor o tabla | Nada (o parámetros OUT) |
| **Se llama con** | `SELECT nombre()` | `CALL nombre()` |
| **Modifica datos** | Puede, pero no es su propósito | Su propósito principal |
| **Transacciones** | No puede controlar `COMMIT`/`ROLLBACK` | Puede hacer `COMMIT` interno |
| **Cuándo usarlo** | Cálculos, consultas reutilizables | Operaciones que escriben/modifican datos |

> 💡 Regla simple: si **lees** datos → `FUNCTION`. Si **escribes o modificas** datos → `PROCEDURE`.

---

## Paso 3.1 — El problema que vamos a resolver

Cada vez que llega un paciente nuevo, el recepcionista debe:

1. Insertar una fila en `consultas_veterinarias`
2. Insertar una o más filas en `consulta_servicios` (los servicios de esa visita)

Son dos tablas, dos `INSERT`, y si algo falla a mitad del proceso los datos quedan
inconsistentes. Un procedimiento los agrupa en **una sola operación atómica**.

---

## Paso 3.2 — Crea el procedimiento `registrar_consulta`

```sql
CREATE OR REPLACE PROCEDURE registrar_consulta(
    p_tutor_id     INT,
    p_mascota_id   INT,
    p_veterinario_id INT,
    p_motivo       VARCHAR,
    p_costo        DECIMAL
)
LANGUAGE plpgsql AS $$
DECLARE
    v_consulta_id INT;
BEGIN
    -- 1. Inserta la consulta y captura el id generado
    INSERT INTO consultas_veterinarias
        (fecha_consulta, motivo, costo, tutor_id, mascota_id, veterinario_id)
    VALUES
        (CURRENT_DATE, p_motivo, p_costo, p_tutor_id, p_mascota_id, p_veterinario_id)
    RETURNING id_consulta INTO v_consulta_id;

    -- 2. Registra automáticamente el servicio "Consulta general" (id 1)
    INSERT INTO consulta_servicios (consulta_id, servicio_id)
    VALUES (v_consulta_id, 1);

    RAISE NOTICE 'Consulta registrada con id: %', v_consulta_id;
END;
$$;
```

Novedades respecto a las funciones del paso anterior:

| Parte | Qué significa |
|---|---|
| `LANGUAGE plpgsql` | PL/pgSQL: SQL procedural con variables, condicionales y bloques |
| `DECLARE` | sección donde declaras variables locales |
| `v_consulta_id INT` | variable que guarda el id recién insertado (prefijo `v_` = variable) |
| `RETURNING id INTO v_consulta_id` | captura el `SERIAL` generado y lo guarda en la variable |
| `RAISE NOTICE` | imprime un mensaje informativo (visible en pgAdmin y psql) |

---

## Paso 3.3 — Llama el procedimiento desde pgAdmin

```sql
CALL registrar_consulta(
    1,              -- tutor_id: Carlos Mendoza
    1,              -- mascota_id: Firulais
    1,              -- veterinario_id: Dra. Paula Ríos
    'Revisión post-cirugía',
    25.00
);
```

En el panel de mensajes de pgAdmin verás:
```
NOTICE:  Consulta registrada con id: 10
```

Verifica que los datos quedaron bien en las dos tablas:

```sql
-- La consulta nueva
SELECT * FROM consultas_veterinarias WHERE id_consulta = 10;

-- El servicio asociado automáticamente
SELECT * FROM consulta_servicios WHERE consulta_id = 10;
```

> 🔎 Con un solo `CALL` se crearon filas en **dos tablas** de forma consistente.
> Si el segundo `INSERT` fallara (por ejemplo, `servicio_id` inválido), la consulta
> tampoco quedaría registrada: PL/pgSQL deshace todo en caso de error.

---

## Paso 3.4 — Invoca todo desde psql (la terminal)

Ahora repites las mismas operaciones pero **sin pgAdmin**, solo con la terminal.
Esto simula trabajar en un servidor remoto.

Abre psql:

```bash
psql -U postgres -d veterinariadb
```

**Lista las funciones y procedimientos disponibles:**

```
\df
```

**Llama la función de resumen:**

```sql
SELECT * FROM resumen_tutor(1);
```

**Llama el procedimiento para registrar otra consulta:**

```sql
CALL registrar_consulta(2, 4, 3, 'Control post-esterilización', 20.00);
```

**Verifica el resultado:**

```sql
SELECT id_consulta, motivo, costo FROM consultas_veterinarias ORDER BY id_consulta DESC LIMIT 3;
```

**Ejecuta un archivo SQL con `\i`** (útil para scripts largos):

```bash
-- Primero sal de psql
\q
```

```bash
-- Ejecuta setup.sql directamente desde la terminal
psql -U postgres -d veterinariadb -f /workspaces/postgrespace/exercise/04-procedimientos-psql/setup.sql
```

> 💡 `-f archivo.sql` es el equivalente desde fuera del prompt de lo que hace `\i archivo.sql`
> dentro. Ambos ejecutan un script completo. En producción se usa así para deploys y migraciones.

---

## Paso 3.5 — 🧪 Tu turno: amplía el procedimiento

Modifica `registrar_consulta` para que reciba un **cuarto parámetro** opcional:
`p_servicio_id INT DEFAULT NULL`. Si se pasa un valor, además del servicio 1 (consulta
general) también registra ese servicio adicional en `consulta_servicios`.

<details>
<summary>👀 Ver solución</summary>

```sql
CREATE OR REPLACE PROCEDURE registrar_consulta(
    p_tutor_id       INT,
    p_mascota_id     INT,
    p_veterinario_id INT,
    p_motivo         VARCHAR,
    p_costo          DECIMAL,
    p_servicio_id    INT DEFAULT NULL
)
LANGUAGE plpgsql AS $$
DECLARE
    v_consulta_id INT;
BEGIN
    INSERT INTO consultas_veterinarias
        (fecha_consulta, motivo, costo, tutor_id, mascota_id, veterinario_id)
    VALUES
        (CURRENT_DATE, p_motivo, p_costo, p_tutor_id, p_mascota_id, p_veterinario_id)
    RETURNING id_consulta INTO v_consulta_id;

    INSERT INTO consulta_servicios (consulta_id, servicio_id)
    VALUES (v_consulta_id, 1);

    IF p_servicio_id IS NOT NULL THEN
        INSERT INTO consulta_servicios (consulta_id, servicio_id)
        VALUES (v_consulta_id, p_servicio_id);
    END IF;

    RAISE NOTICE 'Consulta % registrada con % servicio(s)',
        v_consulta_id,
        CASE WHEN p_servicio_id IS NOT NULL THEN 2 ELSE 1 END;
END;
$$;

-- Prueba: registra una vacuna (servicio 2) además de la consulta general
CALL registrar_consulta(3, 7, 1, 'Vacuna rabia', 30.00, 2);
```

</details>

---

## ✅ Lo que lograste

* **`CREATE PROCEDURE` + `LANGUAGE plpgsql`** → lógica procedural con variables y bloques.
* **`RETURNING ... INTO`** → capturar el id generado por un `INSERT` en una variable.
* **`RAISE NOTICE`** → mensajes informativos durante la ejecución.
* **`CALL`** → invocar un procedimiento desde pgAdmin o psql.
* **`psql -f archivo.sql`** → ejecutar scripts desde la terminal sin entrar al prompt.
* **`\df`** → inspeccionar las funciones y procedimientos del servidor desde psql.

> 📤 **Entrega:** guarda en `paso3.sql` la creación del procedimiento `registrar_consulta`
> (con la ampliación del paso 3.5 incluida) y las llamadas de prueba. Guarda en `paso3.txt`
> el output de la terminal de los comandos psql del paso 3.4.
> Adjunta una captura de pgAdmin mostrando las dos tablas (`consultas_veterinarias` y
> `consulta_servicios`) con las filas insertadas por el procedimiento.
> Dónde ubicar los archivos: [Entrega](ENTREGA.md).
