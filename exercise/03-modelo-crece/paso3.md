# Ejercicio 3 — El reporte completo (unir hasta 5 tablas)

> 🎯 **Qué vas a aprender:** a **consultar** un modelo muchos-a-muchos uniendo varias tablas a
> la vez (incluida la tabla puente) y a sacar **reportes de negocio** combinando `JOIN` con el
> `GROUP BY` que ya conoces del Set 02.

Ya tienes todo el modelo crecido: `tutores`, `mascotas`, `consultas_veterinarias`,
`veterinarios`, `servicios` y la puente `consulta_servicios`. Ahora le sacamos respuestas.

> 💡 ¿Tu base se reinició? Ejecuta de nuevo [`setup.sql`](setup.sql) y rehaz los ejercicios 1
> y 2 (o pídele a tu instructor el script con el modelo completo).

---

## Paso 3.1 — ¿Qué servicios tuvo cada consulta?

Para leer una relación N:M se **pasa por la tabla puente**. Aquí unimos 4 tablas: consultas,
mascotas, la puente y servicios.

```sql
SELECT
    c.id_consulta      AS "N°",
    m.nombre           AS "Mascota",
    c.motivo           AS "Motivo",
    s.nombre           AS "Servicio",
    s.precio           AS "Precio"
FROM consultas_veterinarias c
INNER JOIN mascotas           m  ON c.mascota_id  = m.id_mascota
INNER JOIN consulta_servicios cs ON c.id_consulta = cs.consulta_id
INNER JOIN servicios          s  ON cs.servicio_id = s.id_servicio
ORDER BY c.id_consulta;
```

> 🔎 Una consulta con 2 servicios aparece en **2 filas** (una por servicio). Así funciona el
> "desarmado" de una relación muchos-a-muchos: la tabla puente multiplica las filas según las
> parejas.

---

## Paso 3.2 — ¿Cuánto ingresó cada servicio? (JOIN + GROUP BY)

Combinamos la puente con `servicios` y agrupamos. `COUNT` cuenta cuántas veces se usó cada
servicio; `SUM(precio)` calcula el ingreso total que generó.

```sql
SELECT
    s.nombre              AS servicio,
    COUNT(*)              AS veces_usado,
    SUM(s.precio)         AS ingreso_total
FROM servicios s
INNER JOIN consulta_servicios cs ON s.id_servicio = cs.servicio_id
GROUP BY s.nombre
ORDER BY ingreso_total DESC;
```

> 💡 Esto es un reporte real: te dice qué servicios generan más dinero a la clínica. 💰

**Tú haz esto:** muestra, para **cada consulta**, **cuántos servicios** incluyó y el **total**
de esos servicios.

<details>
<summary>👀 Ver la solución</summary>

```sql
SELECT
    cs.consulta_id        AS consulta,
    COUNT(*)              AS num_servicios,
    SUM(s.precio)         AS total_servicios
FROM consulta_servicios cs
INNER JOIN servicios s ON cs.servicio_id = s.id_servicio
GROUP BY cs.consulta_id
ORDER BY cs.consulta_id;
```

</details>

---

## Paso 3.3 — ¿Cuántas consultas atiende cada veterinario?

Usamos la FK que agregaste en el Ejercicio 1.

```sql
SELECT
    v.nombre              AS veterinario,
    v.especialidad,
    COUNT(c.id_consulta)  AS consultas_atendidas
FROM veterinarios v
INNER JOIN consultas_veterinarias c ON v.id_veterinario = c.veterinario_id
GROUP BY v.nombre, v.especialidad
ORDER BY consultas_atendidas DESC;
```

---

## Paso 3.4 — El reporte estrella: unir las 5 tablas

Una sola consulta que junta **todo**: tutor, mascota, veterinario y los servicios de cada
consulta. Es el "panel completo" de la clínica.

```sql
SELECT
    c.fecha_consulta AS "Fecha",
    t.nombre         AS "Tutor",
    m.nombre         AS "Mascota",
    v.nombre         AS "Veterinario",
    s.nombre         AS "Servicio",
    s.precio         AS "Precio"
FROM consultas_veterinarias c
INNER JOIN tutores            t  ON c.tutor_id      = t.id_tutor
INNER JOIN mascotas           m  ON c.mascota_id    = m.id_mascota
INNER JOIN veterinarios       v  ON c.veterinario_id = v.id_veterinario
INNER JOIN consulta_servicios cs ON c.id_consulta   = cs.consulta_id
INNER JOIN servicios          s  ON cs.servicio_id  = s.id_servicio
ORDER BY c.fecha_consulta, m.nombre;
```

> 🎉 Acabas de unir **cinco** tablas en una sola consulta legible. Eso es exactamente lo que
> hace un sistema real por dentro cada vez que ves una "ficha" completa en pantalla.

---

## 💡 Conceptos clave

* Para consultar una relación **N:M** se **pasa por la tabla puente** con `JOIN`.
* La tabla puente **multiplica filas**: una consulta con N servicios sale en N filas.
* **`JOIN` + `GROUP BY`** convierte esas filas en reportes (ingresos por servicio, servicios por
  consulta, consultas por veterinario).
* Puedes encadenar **muchos** `JOIN` para unir tantas tablas como necesites.

---

## ✅ Lo que lograste

Hiciste crecer la veterinaria a un modelo realista de **6 tablas** —incluyendo una relación
muchos-a-muchos— y aprendiste a consultarlo:

```
tutores ─< consultas >─ mascotas
              │  │
   veterinarios  └─< consulta_servicios >─ servicios
```

> 📤 **Entrega:** guarda en `paso3.sql` tus consultas, incluyendo **obligatoriamente** la de
> **ingresos por servicio** (3.2) y la de **las 5 tablas** (3.4). Adjunta una captura del
> resultado del reporte de las 5 tablas. Dónde ubicar los archivos: [Entrega](ENTREGA.md).

➡️ **Próximo reto:** ya sabes crear, consultar **y** hacer crecer una base de datos relacional
completa. El siguiente paso natural es **diseñar tu propia base de datos desde cero** (elegir
entidades, relaciones y reglas) para un caso distinto a la veterinaria. ¡Ese será el capstone!
