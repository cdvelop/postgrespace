# Ejercicio 2 — Funciones

> 🎯 **Qué vas a aprender:** a crear una **función** que recibe parámetros, ejecuta
> una consulta y devuelve un resultado. La escribes una vez y la llamas por su nombre.

---

## Paso 2.0 — Vista vs Función

| | Vista | Función |
|---|---|---|
| **Parámetros** | No | Sí |
| **Devuelve** | Siempre las mismas filas | Lo que calcula con los parámetros |
| **Ejemplo** | `SELECT * FROM historial_consultas` | `SELECT costo_total_tutor(1)` |

Usa una **vista** cuando la consulta es fija. Usa una **función** cuando necesitas
pasar un valor para filtrar o calcular.

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
| `p_tutor_id INT` | parámetro de entrada (prefijo `p_` = parámetro) |
| `RETURNS DECIMAL` | tipo del valor que devuelve |
| `$$ ... $$` | delimitadores del cuerpo |
| `COALESCE(SUM(...), 0)` | devuelve 0 si no hay consultas en lugar de NULL |
| `LANGUAGE sql` | el cuerpo está escrito en SQL puro |

Pruébala con cada tutor:

```sql
SELECT costo_total_tutor(1);   -- Carlos
SELECT costo_total_tutor(2);   -- Ana
SELECT costo_total_tutor(4);   -- Sofía (devuelve 0: no tiene consultas)
```

---

## Paso 2.2 — Lista tus funciones

En psql:

```bash
psql -U postgres -d veterinariadb
```

```
\df
```

Verás `costo_total_tutor` en la lista. Sal con `\q`.

---

## Paso 2.3 — 🧪 Tu turno: función que devuelve una tabla

Crea una función `mascotas_sin_consulta()` (sin parámetros) que devuelva el
**nombre** y la **especie** de las mascotas que nunca han tenido una consulta.

> 💡 Pista: usa `LEFT JOIN` entre `mascotas` y `consultas_veterinarias` y filtra
> donde `id_consulta IS NULL`. Ya lo resolviste en el Set 02 como consulta suelta.

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

Debe devolver **Kira (Gato)**: la única mascota sin ninguna consulta.

</details>

---

## ✅ Lo que lograste

* **`CREATE OR REPLACE FUNCTION`** → encapsular una consulta con nombre y parámetros.
* **`RETURNS DECIMAL`** → función que devuelve un valor.
* **`RETURNS TABLE`** → función que devuelve filas.
* **`LANGUAGE sql`** → funciones escritas en SQL puro.
* **`\df`** en psql → listar las funciones del servidor.

> 📤 **Entrega:** guarda en `paso2.sql` las dos funciones (`costo_total_tutor` y
> `mascotas_sin_consulta`). Adjunta `paso2.png` con captura de los 4 `SELECT`
> de `costo_total_tutor`.
> Dónde ubicar los archivos: [Entrega](ENTREGA.md).

➡️ **Siguiente:** en el [Ejercicio 3](paso3.md) crearás un **procedimiento** que
modifica datos en la base.
