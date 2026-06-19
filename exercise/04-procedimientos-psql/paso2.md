# Ejercicio 2 — Tu primera función almacenada

> 🎯 **Qué vas a aprender:** a crear **funciones** en PostgreSQL con `CREATE FUNCTION`.
> Una función encapsula una consulta o cálculo que vas a repetir: la escribes una vez y la
> llamas con un nombre, igual que una función en cualquier lenguaje de programación.

---

## Paso 2.0 — ¿Qué problema resuelve una función?

Imagina que el recepcionista de la veterinaria pregunta todos los días: *"¿Cuánto ha gastado
Carlos Mendoza en total?"*. Sin funciones, escribirías esto cada vez:

```sql
SELECT SUM(costo)
FROM consultas_veterinarias
WHERE tutor_id = 1;
```

Con una función, bastará con:

```sql
SELECT costo_total_tutor(1);
```

> 💡 La lógica queda guardada en la base de datos, disponible para pgAdmin, psql o cualquier
> aplicación que se conecte. No está en tu script suelto: **vive en el servidor**.

---

## Paso 2.1 — Función que devuelve un número

```sql
CREATE OR REPLACE FUNCTION costo_total_tutor(p_tutor_id INT)
RETURNS DECIMAL AS $$
    SELECT COALESCE(SUM(costo), 0)
    FROM consultas_veterinarias
    WHERE tutor_id = p_tutor_id;
$$ LANGUAGE sql;
```

| Parte | Qué significa |
|---|---|
| `CREATE OR REPLACE` | crea la función o la reemplaza si ya existe |
| `p_tutor_id INT` | parámetro de entrada (el prefijo `p_` es convención) |
| `RETURNS DECIMAL` | tipo del valor que devuelve |
| `$$ ... $$` | delimitadores del cuerpo de la función |
| `COALESCE(SUM(...), 0)` | si no hay consultas, devuelve 0 en lugar de NULL |
| `LANGUAGE sql` | el cuerpo está escrito en SQL plano |

Pruébala con cada tutor:

```sql
SELECT costo_total_tutor(1) AS gasto_carlos;
SELECT costo_total_tutor(2) AS gasto_ana;
SELECT costo_total_tutor(3) AS gasto_luis;
SELECT costo_total_tutor(4) AS gasto_sofia;
```

> 🔎 Sofía (id 4) devuelve **0**: tiene mascota pero ninguna consulta registrada.
> `COALESCE` convierte el `NULL` en un cero legible.

---

## Paso 2.2 — Función que devuelve una tabla

Una función también puede devolver **filas**, no solo un número. Esto es más potente:
equivale a tener una vista personalizada con parámetros.

```sql
CREATE OR REPLACE FUNCTION resumen_tutor(p_tutor_id INT)
RETURNS TABLE (
    mascota      VARCHAR,
    fecha        DATE,
    motivo       VARCHAR,
    costo        DECIMAL,
    veterinario  VARCHAR
) AS $$
    SELECT
        m.nombre       AS mascota,
        cv.fecha_consulta,
        cv.motivo,
        cv.costo,
        v.nombre       AS veterinario
    FROM consultas_veterinarias cv
    JOIN mascotas    m ON m.id_mascota    = cv.mascota_id
    JOIN veterinarios v ON v.id_veterinario = cv.veterinario_id
    WHERE cv.tutor_id = p_tutor_id
    ORDER BY cv.fecha_consulta;
$$ LANGUAGE sql;
```

Llámala como si fuera una tabla:

```sql
SELECT * FROM resumen_tutor(1);
```

Verás todas las consultas de Carlos con su mascota, fecha, motivo, costo y veterinario
en una sola consulta limpia.

<details>
<summary>👀 Ver qué pasa con un tutor sin consultas</summary>

```sql
SELECT * FROM resumen_tutor(4);
```

Devuelve **0 filas** (Sofía no tiene consultas). No da error: la función simplemente
retorna un resultado vacío. Así se comporta una función bien hecha.
</details>

---

## Paso 2.3 — Lista tus funciones con `\df`

Conéctate a psql desde la terminal y lista las funciones que acabas de crear:

```bash
psql -U postgres -d veterinariadb
```

Dentro del prompt de psql:

```
\df
```

Verás `costo_total_tutor` y `resumen_tutor` en la lista con sus tipos. Sal con `\q`.

> 💡 `\df` es el equivalente de `\dt` para funciones. Es cómo verificas en psql que tu
> función quedó guardada en el servidor.

---

## Paso 2.4 — 🧪 Tu turno

Crea una función llamada `mascotas_sin_consulta()` (sin parámetros) que devuelva una tabla
con el **nombre** y la **especie** de las mascotas que nunca han tenido una consulta.

> 💡 Pista: en el Set 02 resolviste esto con un `LEFT JOIN` e `IS NULL`. Esa misma
> consulta es el cuerpo de tu función.

<details>
<summary>👀 Ver solución</summary>

```sql
CREATE OR REPLACE FUNCTION mascotas_sin_consulta()
RETURNS TABLE (mascota VARCHAR, especie VARCHAR) AS $$
    SELECT m.nombre, m.especie
    FROM mascotas m
    LEFT JOIN consultas_veterinarias cv ON cv.mascota_id = m.id_mascota
    WHERE cv.id_consulta IS NULL;
$$ LANGUAGE sql;

-- Llámala:
SELECT * FROM mascotas_sin_consulta();
```

Debe devolver **Kira (Gato)**: la única mascota sin ninguna consulta registrada.
</details>

---

## ✅ Lo que lograste

* **`CREATE OR REPLACE FUNCTION`** → encapsular una consulta con nombre y parámetros.
* **`RETURNS DECIMAL`** → función que devuelve un valor escalar.
* **`RETURNS TABLE`** → función que devuelve filas (más poderoso que una vista fija).
* **`LANGUAGE sql`** → funciones escritas en SQL puro, sin aprender otro lenguaje.
* **`\df` en psql** → listar las funciones guardadas en el servidor.

> 📤 **Entrega:** guarda en `paso2.sql` la creación de las dos funciones del profesor
> (`costo_total_tutor` y `resumen_tutor`) **más** la función `mascotas_sin_consulta` que
> tú escribiste. Adjunta una captura de `SELECT * FROM resumen_tutor(1);` mostrando el
> historial completo de Carlos.
> Dónde ubicar los archivos: [Entrega](ENTREGA.md).

➡️ **Siguiente:** en el [Ejercicio 3](paso3.md) darás el siguiente paso: un
**procedimiento almacenado** que no solo consulta, sino que **modifica** la base de datos
con lógica de negocio completa.
