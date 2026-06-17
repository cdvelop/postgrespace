# Ejercicio 2 — Contar, sumar y agrupar

> 🎯 **Qué vas a aprender:** a **resumir** muchos datos en un solo número (`COUNT`, `SUM`,
> `AVG`, `MIN`, `MAX`) y a calcular esos resúmenes **por grupos** (`GROUP BY`), filtrando
> grupos con `HAVING`. Esto es la base de cualquier *reporte*.

Hasta ahora cada consulta devolvía **filas**. Ahora queremos **conclusiones**:
*"¿cuántas mascotas hay?"*, *"¿cuánto facturamos?"*, *"¿qué especie es la más común?"*.

> 💡 ¿No ves datos o salen pocos? Ejecuta el script [`setup.sql`](setup.sql) (ver
> [paso 1.0](paso1.md#paso-10--prepara-tu-punto-de-partida-no-te-lo-saltes)). Deja la base con
> 8 mascotas y 9 consultas, justo lo que estos resúmenes necesitan.

---

## Paso 2.1 — Cuenta filas con `COUNT`

`COUNT(*)` cuenta cuántas filas hay. ¿Cuántas mascotas tienes en total?

```sql
SELECT COUNT(*) AS total_mascotas FROM mascotas;
```

Y combínalo con `WHERE` para contar solo un grupo. ¿Cuántos perros hay?

```sql
SELECT COUNT(*) AS total_perros FROM mascotas WHERE especie = 'Perro';
```

> 💡 `AS total_mascotas` le pone nombre al resultado para que se lea claro.

---

## Paso 2.2 — Suma, promedio, mínimo y máximo

Estas funciones trabajan sobre una columna **numérica**:

```sql
SELECT
    SUM(costo) AS total_facturado,
    AVG(costo) AS costo_promedio,
    MIN(costo) AS mas_barata,
    MAX(costo) AS mas_cara
FROM consultas_veterinarias;
```

En una sola consulta obtienes el total del negocio, el ticket promedio y los extremos. 💰

> 💡 `AVG` suele dar muchos decimales. Puedes redondear con `ROUND(AVG(costo), 2)`.

---

## Paso 2.3 — Resúmenes por grupo con `GROUP BY`

Aquí está la magia. `GROUP BY` **agrupa** las filas que comparten un valor y aplica la función
a **cada grupo** por separado. ¿Cuántas mascotas hay **de cada especie**?

```sql
SELECT especie, COUNT(*) AS cantidad
FROM mascotas
GROUP BY especie
ORDER BY cantidad DESC;
```

Resultado: una fila por especie con su conteo (Perro 3, Gato 2, …). 🎯

Otro clásico: **cuánto ha facturado cada tutor** (por su `id`):

```sql
SELECT tutor_id, SUM(costo) AS total_gastado
FROM consultas_veterinarias
GROUP BY tutor_id
ORDER BY total_gastado DESC;
```

> 🔑 **Regla de oro:** toda columna del `SELECT` que **no** esté dentro de una función
> (`COUNT`, `SUM`…) **debe** aparecer en el `GROUP BY`. Aquí `tutor_id` no está en una función,
> por eso va en el `GROUP BY`.

**Tú haz esto:** calcula el **costo promedio de consulta por cada mascota** (`mascota_id`).

<details>
<summary>👀 Ver la solución</summary>

```sql
SELECT mascota_id, ROUND(AVG(costo), 2) AS promedio
FROM consultas_veterinarias
GROUP BY mascota_id
ORDER BY promedio DESC;
```

</details>

---

## Paso 2.4 — Filtra grupos con `HAVING`

¿Y si solo quieres los grupos que cumplen una condición? Ojo: **`WHERE` filtra filas; `HAVING`
filtra grupos** (resultados de la agrupación). Tutores que han gastado **más de 100** en total:

```sql
SELECT tutor_id, SUM(costo) AS total_gastado
FROM consultas_veterinarias
GROUP BY tutor_id
HAVING SUM(costo) > 100
ORDER BY total_gastado DESC;
```

> 💡 No puedes usar `WHERE SUM(costo) > 100`: cuando se evalúa `WHERE` los grupos **aún no
> existen**. Para filtrar por el resultado de un `SUM`/`COUNT`/`AVG` se usa `HAVING`.

**Tú haz esto:** muestra las especies que tengan **2 o más** mascotas.

<details>
<summary>👀 Ver la solución</summary>

```sql
SELECT especie, COUNT(*) AS cantidad
FROM mascotas
GROUP BY especie
HAVING COUNT(*) >= 2;
```

</details>

---

## ✅ Lo que lograste

* **`COUNT/SUM/AVG/MIN/MAX`** → convertir muchas filas en un número resumen.
* **`GROUP BY`** → calcular ese resumen **por grupo** (por especie, por tutor…).
* **`HAVING`** → filtrar **grupos**, no filas (la diferencia clave con `WHERE`).
* La regla: lo que no esté en una función de agregación va en el `GROUP BY`.

> 📤 **Entrega:** guarda en `paso2.sql` tus consultas de resumen, incluyendo **obligatoriamente**
> una con `GROUP BY` y una con `HAVING`. Adjunta una captura del resultado de
> **cuánto ha facturado cada tutor** (paso 2.3). Dónde ubicar los archivos: [Entrega](ENTREGA.md).

➡️ **Siguiente:** en el [Ejercicio 3](paso3.md) verás los nombres reales (no los `id`) uniendo
tablas con `JOIN`, descubrirás qué mascotas **nunca** han venido con `LEFT JOIN` y harás tus
primeras **subconsultas**.
