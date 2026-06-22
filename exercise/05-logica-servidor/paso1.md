# Ejercicio 1 — Vistas

> 🎯 **Qué vas a aprender:** qué es una vista (`VIEW`) y cómo usarla para guardar
> una consulta con nombre y reutilizarla como si fuera una tabla.

---

## Paso 1.0 — ¿Qué es una vista?

Una **vista** es una consulta guardada en el servidor con un nombre. Una vez creada,
puedes usarla exactamente igual que una tabla: con `SELECT`, con `WHERE`, con `JOIN`.

```
Sin vista:                          Con vista:
SELECT m.nombre, t.nombre           SELECT * FROM mascotas_con_tutor;
FROM mascotas m
JOIN tutores t ON ...               ← misma consulta, pero con nombre
WHERE ...                              y disponible para siempre
```

Las vistas no duplican datos — cada vez que las consultas, ejecutan el `SELECT`
original en ese momento.

---

## Paso 1.1 — Crea tu primera vista

En pgAdmin, ejecuta esto sobre `veterinariadb`:

```sql
CREATE VIEW mascotas_con_tutor AS
SELECT
    m.nombre        AS mascota,
    m.especie,
    t.nombre        AS tutor,
    t.telefono
FROM mascotas m
JOIN tutores t ON t.id_tutor = m.tutor_id;
```

Ahora consulta la vista como si fuera una tabla:

```sql
SELECT * FROM mascotas_con_tutor;
```

Verás las 8 mascotas con el nombre y teléfono de su tutor, sin escribir el JOIN.

Filtra sobre ella igual que con una tabla:

```sql
SELECT * FROM mascotas_con_tutor WHERE especie = 'Perro';
```

---

## Paso 1.2 — Lista las vistas disponibles

En psql:

```bash
psql -U postgres -d veterinariadb
```

```
\dv
```

Verás `mascotas_con_tutor` en la lista. Sal con `\q`.

> 💡 `\dv` es el equivalente de `\dt` pero para vistas (*views*).

---

## Paso 1.3 — Reemplaza una vista con `CREATE OR REPLACE`

Si necesitas modificar la vista, usa `CREATE OR REPLACE` — no hace falta borrarla primero:

```sql
CREATE OR REPLACE VIEW mascotas_con_tutor AS
SELECT
    m.nombre        AS mascota,
    m.especie,
    m.raza,
    t.nombre        AS tutor,
    t.telefono
FROM mascotas m
JOIN tutores t ON t.id_tutor = m.tutor_id
ORDER BY t.nombre, m.nombre;
```

Ahora incluye la raza y está ordenada. Consulta de nuevo:

```sql
SELECT * FROM mascotas_con_tutor;
```

---

## Paso 1.4 — 🧪 Tu turno: vista de historial de consultas

Crea una vista llamada `historial_consultas` que muestre para cada consulta:
el nombre de la mascota, el nombre del tutor, la fecha, el motivo, el costo
y el nombre del veterinario.

<details>
<summary>👀 Ver solución</summary>

```sql
CREATE VIEW historial_consultas AS
SELECT
    m.nombre        AS mascota,
    t.nombre        AS tutor,
    cv.fecha_consulta,
    cv.motivo,
    cv.costo,
    v.nombre        AS veterinario
FROM consultas_veterinarias cv
JOIN mascotas    m ON m.id_mascota     = cv.mascota_id
JOIN tutores     t ON t.id_tutor       = cv.tutor_id
JOIN veterinarios v ON v.id_veterinario = cv.veterinario_id
ORDER BY cv.fecha_consulta DESC;
```

Prueba:

```sql
SELECT * FROM historial_consultas;
SELECT * FROM historial_consultas WHERE tutor = 'Carlos Mendoza';
```

</details>

---

## ✅ Lo que lograste

* **`CREATE VIEW`** → guardar una consulta con nombre en el servidor.
* **`CREATE OR REPLACE VIEW`** → actualizar una vista sin borrarla.
* Consultar una vista con `SELECT`, `WHERE` y `JOIN` igual que una tabla.
* **`\dv`** en psql → listar las vistas del servidor.

> 📤 **Entrega:** guarda en `paso1.sql` la creación de las dos vistas
> (`mascotas_con_tutor` y `historial_consultas`). Adjunta `paso1.png` con
> captura del resultado de `SELECT * FROM historial_consultas;`.
> Dónde ubicar los archivos: [Entrega](ENTREGA.md).

➡️ **Siguiente:** en el [Ejercicio 2](paso2.md) crearás tu primera **función**
para encapsular lógica con parámetros.
