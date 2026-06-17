# Ejercicio 3 — JOINs avanzados y preguntas reales

> 🎯 **Qué vas a aprender:** a combinar lo de los pasos anteriores (filtrar + agrupar) con
> `JOIN` para responder preguntas de negocio, a usar `LEFT JOIN` para encontrar lo que
> **falta**, y a escribir tus primeras **subconsultas**.

En el Set 01 ya hiciste un `INNER JOIN`. Aquí lo llevamos más lejos: combinamos JOIN con
`GROUP BY`, descubrimos lo que **no** tiene pareja y anidamos consultas dentro de consultas.

> 💡 ¿Datos pobres o la base se reinició? Ejecuta de nuevo [`setup.sql`](setup.sql) y vuelves al
> punto de partida en segundos.

---

## Paso 3.1 — Repaso: `INNER JOIN` con nombres reales

`INNER JOIN` une filas que **coinciden** en ambas tablas. Veamos cada consulta con el nombre
del tutor y de la mascota (en vez de sus `id`):

```sql
SELECT
    c.fecha_consulta AS "Fecha",
    t.nombre         AS "Tutor",
    m.nombre         AS "Mascota",
    c.motivo         AS "Motivo",
    c.costo          AS "Costo"
FROM consultas_veterinarias c
INNER JOIN tutores  t ON c.tutor_id   = t.id_tutor
INNER JOIN mascotas m ON c.mascota_id = m.id_mascota
ORDER BY c.costo DESC;
```

> 💡 `INNER JOIN` solo muestra filas con pareja en **ambos** lados. Una mascota que nunca tuvo
> una consulta **no aparece** aquí. Eso lo resolvemos en el siguiente paso.

---

## Paso 3.2 — `LEFT JOIN`: encuentra lo que falta

Un `LEFT JOIN` trae **todas** las filas de la tabla izquierda, **aunque no tengan pareja** en
la derecha (en ese caso, las columnas de la derecha salen como `NULL`). Perfecto para detectar
huecos. ¿Qué mascotas **nunca** han tenido una consulta?

```sql
SELECT m.nombre AS mascota, m.especie, c.id_consulta
FROM mascotas m
LEFT JOIN consultas_veterinarias c ON m.id_mascota = c.mascota_id
WHERE c.id_consulta IS NULL;
```

> 🔎 El truco: con `LEFT JOIN` las mascotas sin consulta tienen `c.id_consulta` en `NULL`.
> Al filtrar `WHERE c.id_consulta IS NULL` te quedas **justo con las que faltan**. (Para
> comparar con vacío se usa `IS NULL`, nunca `= NULL`.)

> 💡 ¿Todas tus mascotas tienen consulta y no sale ninguna? Inserta una mascota nueva (sin
> consultas) con un `INSERT` y vuelve a correr la consulta para verla aparecer.

---

## Paso 3.3 — `JOIN` + `GROUP BY`: el reporte completo

Ahora combinamos JOIN con lo del Ejercicio 2. ¿Cuánto ha gastado cada tutor, **mostrando su
nombre** y cuántas consultas hizo?

```sql
SELECT
    t.nombre              AS tutor,
    COUNT(c.id_consulta)  AS num_consultas,
    SUM(c.costo)          AS total_gastado
FROM tutores t
INNER JOIN consultas_veterinarias c ON t.id_tutor = c.tutor_id
GROUP BY t.nombre
ORDER BY total_gastado DESC;
```

Esto sí es un reporte de verdad: nombre legible, número de visitas y total facturado. 📊

**Tú haz esto:** muestra, por **especie**, cuánto se ha facturado en total (une `mascotas` con
`consultas_veterinarias` y agrupa por `especie`).

<details>
<summary>👀 Ver la solución</summary>

```sql
SELECT
    m.especie         AS especie,
    SUM(c.costo)      AS total_facturado
FROM mascotas m
INNER JOIN consultas_veterinarias c ON m.id_mascota = c.mascota_id
GROUP BY m.especie
ORDER BY total_facturado DESC;
```

</details>

---

## Paso 3.4 — Subconsultas: una consulta dentro de otra

Una **subconsulta** es un `SELECT` metido dentro de otro. Sirve cuando necesitas un valor
calculado para poder filtrar. ¿Qué consultas costaron **más que el promedio**?

```sql
SELECT motivo, costo
FROM consultas_veterinarias
WHERE costo > (SELECT AVG(costo) FROM consultas_veterinarias)
ORDER BY costo DESC;
```

> 🔎 Primero PostgreSQL resuelve el paréntesis (`SELECT AVG(costo) ...` → un número), y luego
> lo usa en el `WHERE`. Es como hacer dos consultas en una.

**Tú haz esto:** muestra el nombre del/los tutor(es) que tienen la mascota **más vieja**.

<details>
<summary>👀 Ver la solución</summary>

```sql
SELECT t.nombre, m.nombre AS mascota, m.edad_meses
FROM tutores t
INNER JOIN mascotas m ON t.id_tutor = m.tutor_id
WHERE m.edad_meses = (SELECT MAX(edad_meses) FROM mascotas);
```

</details>

---

## 💡 Conceptos clave

* **`INNER JOIN`** → solo filas con pareja en ambas tablas.
* **`LEFT JOIN` + `IS NULL`** → encontrar lo que **no** tiene pareja (huecos, faltantes).
* **`JOIN` + `GROUP BY`** → reportes legibles con nombres y totales.
* **Subconsulta** → un `SELECT` dentro de otro para usar un valor calculado (un promedio, un
  máximo) como condición.

---

## ✅ Lo que lograste

Pasaste de *guardar* datos a *interrogarlos* como un analista:

```
filtrar → ordenar → resumir → agrupar → unir tablas → subconsultar
```

Con esto puedes responder casi cualquier pregunta sobre la veterinaria. 🎉

> 📤 **Entrega:** guarda en `paso3.sql` tus consultas, incluyendo **obligatoriamente** una con
> `LEFT JOIN`, una con `JOIN` + `GROUP BY` y una con **subconsulta**. Adjunta una captura del
> resultado del **reporte de gasto por tutor** (paso 3.3). Dónde ubicar los archivos:
> [Entrega](ENTREGA.md).

➡️ **Próximo reto:** ya sabes construir **y** consultar una base de datos relacional. El
siguiente paso natural es **mejorar el modelo** (nuevas columnas, restricciones `CHECK`/`UNIQUE`,
vistas) o **diseñar tu propia base de datos** desde cero. ¡Eso vendrá en el siguiente set!
