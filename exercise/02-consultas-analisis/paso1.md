# Ejercicio 1 — Filtrar y ordenar resultados

> 🎯 **Qué vas a aprender:** a pedirle a la base **solo las filas que te interesan**
> (`WHERE` con varias condiciones), a **ordenarlas** (`ORDER BY`), a quedarte con el **top N**
> (`LIMIT`), a evitar repetidos (`DISTINCT`) y a **borrar** filas con cuidado (`DELETE`).

Hasta ahora usabas `SELECT *` para ver **todo**. En la vida real casi nunca quieres todo:
quieres *"los perros mayores de 2 años"* o *"las consultas más caras"*. Eso se hace **filtrando**.

---

## Paso 1.0 — Prepara tu punto de partida (¡no te lo saltes!)

Este set necesita las **3 tablas del Set 01 ya creadas y con datos**. Para que todos arranquen
desde el mismo punto —y por si tu base se reinició al reconstruir el codespace— usaremos un
script que deja todo listo: **[`setup.sql`](setup.sql)**.

1. En pgAdmin, abre el **Query Tool** sobre la base `veterinariadb`.
2. Abre el archivo `setup.sql` (menú **File → Open**, o copia su contenido) y ejecútalo (`F5`).
3. Comprueba que cargó bien:

```sql
SELECT * FROM mascotas;
SELECT * FROM consultas_veterinarias;
```

Deberías ver **8 mascotas** y **9 consultas**. ✅

> 💡 ¿Por qué un script? Porque tu trabajo del Set 01 quedó guardado como archivos `.sql`, pero
> la base de datos **puede volver a su estado inicial** cuando se reconstruye el entorno. Este
> script reconstruye todo en segundos, así que **nunca te quedas atascado**. Es seguro
> ejecutarlo de nuevo cuando quieras volver a empezar limpio.
>
> ⚠️ `setup.sql` **reemplaza** el contenido de las 3 tablas. Si tenías datos propios del Set 01
> que quieras conservar, sácales un backup antes (ver [docs/BACKUPS.md](../../docs/BACKUPS.md)).

---

## Paso 1.1 — Filtra con `WHERE`

`WHERE` es un filtro: solo trae las filas que cumplen la condición. Trae solo los perros:

```sql
SELECT * FROM mascotas WHERE especie = 'Perro';
```

Ahora prueba con un **comparador** (`>`, `<`, `>=`, `<=`, `<>`). Mascotas de más de 24 meses:

```sql
SELECT nombre, especie, edad_meses FROM mascotas WHERE edad_meses > 24;
```

> 💡 El texto va entre comillas simples (`'Perro'`); los números **no** (`24`).

---

## Paso 1.2 — Combina condiciones con `AND` / `OR`

* `AND` → se deben cumplir **las dos** condiciones.
* `OR` → basta con que se cumpla **una**.

Perros que además tengan más de 2 años (24 meses):

```sql
SELECT * FROM mascotas WHERE especie = 'Perro' AND edad_meses > 24;
```

**Tú haz esto:** trae las mascotas que sean `Gato` **o** `Ave`.

<details>
<summary>👀 Ver la solución</summary>

```sql
SELECT * FROM mascotas WHERE especie = 'Gato' OR especie = 'Ave';
```

</details>

---

## Paso 1.3 — Rangos (`BETWEEN`) y listas (`IN`)

En vez de encadenar muchos `AND`/`OR`, hay atajos más legibles:

```sql
-- Mascotas con edad entre 12 y 36 meses (incluye los extremos)
SELECT nombre, edad_meses FROM mascotas WHERE edad_meses BETWEEN 12 AND 36;

-- Mascotas que sean perro, gato o ave (igual que varios OR, pero más corto)
SELECT nombre, especie FROM mascotas WHERE especie IN ('Perro', 'Gato', 'Ave');
```

> 💡 `BETWEEN a AND b` es lo mismo que `>= a AND <= b`. `IN (...)` es lo mismo que varios
> `OR` seguidos.

---

## Paso 1.4 — Busca texto con `LIKE`

`LIKE` busca **coincidencias parciales** en texto. El comodín `%` significa "cualquier cosa":

```sql
-- Consultas cuyo motivo contiene la palabra "Vacuna"
SELECT fecha_consulta, motivo, costo
FROM consultas_veterinarias
WHERE motivo LIKE '%Vacuna%';
```

> 💡 `'Vacuna%'` = empieza por "Vacuna". `'%anual'` = termina en "anual". `'%una%'` = la
> contiene en cualquier parte. `LIKE` distingue mayúsculas; usa `ILIKE` si no quieres que las
> distinga.

---

## Paso 1.5 — Ordena con `ORDER BY` y limita con `LIMIT`

`ORDER BY` ordena el resultado; `ASC` = de menor a mayor (por defecto), `DESC` = al revés.

```sql
-- Mascotas de la más vieja a la más joven
SELECT nombre, edad_meses FROM mascotas ORDER BY edad_meses DESC;
```

Combínalo con `LIMIT` para quedarte con el **top N**. Las 3 consultas más caras:

```sql
SELECT motivo, costo
FROM consultas_veterinarias
ORDER BY costo DESC
LIMIT 3;
```

**Tú haz esto:** muestra las **2 mascotas más jóvenes**.

<details>
<summary>👀 Ver la solución</summary>

```sql
SELECT nombre, edad_meses FROM mascotas ORDER BY edad_meses ASC LIMIT 2;
```

</details>

---

## Paso 1.6 — Sin repetidos con `DISTINCT`

`DISTINCT` elimina los valores duplicados. ¿Qué especies **distintas** atiende la veterinaria?

```sql
SELECT DISTINCT especie FROM mascotas;
```

Aunque tengas 3 perros, "Perro" aparece **una sola vez**. 👍

---

## Paso 1.7 — Borra con cuidado (`DELETE ... WHERE`)

`DELETE` elimina filas. Igual que en `UPDATE`, el `WHERE` es **vital**: sin él borrarías
**toda** la tabla. Para practicar sin riesgo, primero inserta una mascota de prueba y luego
bórrala:

```sql
-- 1) Insertamos una mascota temporal (de Carlos, id 1)
INSERT INTO mascotas (nombre, especie, edad_meses, tutor_id)
VALUES ('Temporal', 'Perro', 1, 1);

-- 2) La borramos por su nombre
DELETE FROM mascotas WHERE nombre = 'Temporal';
```

> ⚠️ **Nunca** ejecutes `DELETE FROM mascotas;` sin `WHERE`: borraría TODAS las mascotas.
> Truco de seguridad: escribe primero el `SELECT` con tu `WHERE`, comprueba qué filas salen,
> y recién entonces cámbialo por `DELETE`.

---

## ✅ Lo que lograste

* **`WHERE`** con comparadores, `AND`/`OR`, `BETWEEN`, `IN` y `LIKE` para filtrar.
* **`ORDER BY`** para ordenar y **`LIMIT`** para el top N.
* **`DISTINCT`** para quitar repetidos.
* **`DELETE ... WHERE`** para borrar filas concretas sin tocar las demás.

> 📤 **Entrega:** en `paso1.sql` guarda **tus** consultas (no hace falta incluir `setup.sql`):
> **al menos 4** que combinen lo aprendido —una con `AND`/`OR`, una con `BETWEEN` o `IN`, una con
> `LIKE`, y una con `ORDER BY ... LIMIT`. Adjunta una captura del resultado de la consulta del
> **top 3 de consultas más caras** (paso 1.5). Dónde ubicar los archivos: [Entrega](ENTREGA.md).

➡️ **Siguiente:** en el [Ejercicio 2](paso2.md) dejarás de ver fila por fila y aprenderás a
**resumir** los datos: contar, sumar y agrupar para obtener totales por especie y por tutor.
