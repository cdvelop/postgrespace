# Ejercicio 3 — Tres tablas y tu primer `JOIN`

> 🎯 **Qué vas a aprender:** a crear una tabla que se relaciona con **dos** tablas a la vez
> (con **dos** claves foráneas) y a **unir** la información de las tres con un `JOIN`.

Hasta ahora tienes `tutores` y `mascotas`. Vamos a registrar las **visitas al veterinario**
en una tabla nueva: **`consultas_veterinarias`**. Cada consulta necesita saber **qué mascota**
se atendió y **qué tutor** la llevó → por eso tendrá **dos** claves foráneas.

```
  tutores (1) ────< consultas_veterinarias >──── (1) mascotas
```

---

## Paso 3.1 — Crea la tabla `consultas_veterinarias` (CREAR)

**Pista** — estructura con las dos claves foráneas para completar:

```sql
CREATE TABLE consultas_veterinarias (
    id_consulta    SERIAL PRIMARY KEY,
    fecha_consulta DATE NOT NULL,
    motivo         VARCHAR(255) NOT NULL,  -- Ej: Vacunación, Revisión
    costo          DECIMAL(6,2),           -- dinero: hasta 9999.99
    tutor_id       INT,
    mascota_id     INT,

    -- 👇 Dos puentes: uno a tutores y otro a mascotas
    CONSTRAINT fk_consulta_tutor
        FOREIGN KEY (tutor_id)   REFERENCES -- complétalo,
    CONSTRAINT fk_consulta_mascota
        FOREIGN KEY (mascota_id) REFERENCES -- complétalo
);
```

<details>
<summary>👀 Ver la solución completa</summary>

```sql
CREATE TABLE consultas_veterinarias (
    id_consulta    SERIAL PRIMARY KEY,
    fecha_consulta DATE NOT NULL,
    motivo         VARCHAR(255) NOT NULL,
    costo          DECIMAL(6,2),
    tutor_id       INT,
    mascota_id     INT,
    CONSTRAINT fk_consulta_tutor
        FOREIGN KEY (tutor_id)
        REFERENCES tutores(id_tutor)
        ON DELETE CASCADE,
    CONSTRAINT fk_consulta_mascota
        FOREIGN KEY (mascota_id)
        REFERENCES mascotas(id_mascota)
        ON DELETE CASCADE
);
```

> 💡 **`DECIMAL(6,2)` se lee `DECIMAL(precisión, escala)`:** el **primer** número es la cantidad
> **total** de dígitos y el **segundo** es cuántos van **después** del punto decimal. Así
> `DECIMAL(6,2)` admite hasta 6 dígitos con 2 decimales → como máximo `9999.99` (4 enteros + 2
> decimales). Por eso es ideal para dinero: la cantidad de decimales es **fija y exacta** (a
> diferencia de los tipos con coma flotante, que redondean). Usa una escala mayor para más
> precisión, p. ej. `DECIMAL(10,4)`.

</details>

---

## Paso 3.2 — Agrega 2 consultas (INSERTAR)

Usa `id`s que **ya existen**. Confírmalos antes con:

```sql
SELECT id_tutor, nombre FROM tutores;
SELECT id_mascota, nombre, tutor_id FROM mascotas;
```

**Pista:**

```sql
INSERT INTO consultas_veterinarias (fecha_consulta, motivo, costo, tutor_id, mascota_id) VALUES
('2026-03-10', 'MOTIVO', 0.00, ID_TUTOR, ID_MASCOTA),
('2026-03-11', 'MOTIVO', 0.00, ID_TUTOR, ID_MASCOTA);
```

<details>
<summary>👀 Ver una solución de ejemplo</summary>

```sql
INSERT INTO consultas_veterinarias (fecha_consulta, motivo, costo, tutor_id, mascota_id) VALUES
('2026-03-10', 'Vacuna anual contra la rabia', 35.00, 1, 1),  -- Carlos lleva a Firulais
('2026-03-11', 'Esterilización y control',     120.50, 2, 2); -- Ana lleva a Michi
```

</details>

---

## Paso 3.3 — Une las 3 tablas con un `JOIN` (LA MAGIA)

Ahora juntamos todo: por cada consulta, traemos el **nombre del tutor** y el **nombre de la
mascota** desde sus tablas, usando las claves foráneas como "pegamento".

```sql
SELECT
    c.fecha_consulta AS "Fecha",
    t.nombre         AS "Tutor",
    m.nombre         AS "Mascota",
    m.especie        AS "Especie",
    c.motivo         AS "Motivo",
    c.costo          AS "Costo"
FROM consultas_veterinarias c
INNER JOIN tutores  t ON c.tutor_id   = t.id_tutor
INNER JOIN mascotas m ON c.mascota_id = m.id_mascota;
```

Resultado: una tabla legible con la información combinada de las **tres** tablas. 🎉

---

## 💡 Conceptos clave

* **Dos claves foráneas en una tabla**: una entidad (la consulta) puede relacionarse con
  varias tablas a la vez.
* **`INNER JOIN ... ON`**: une filas de dos tablas cuando una condición coincide
  (`c.tutor_id = t.id_tutor`). Encadenas varios `JOIN` para unir más de dos tablas.
* **Alias (`c`, `t`, `m`)**: la letra junto al nombre de la tabla acorta el código
  (`c.motivo` en vez de `consultas_veterinarias.motivo`).
* **`AS "Texto"`**: renombra la columna en el resultado para que se lea bonito.

---

## ✅ Lo que lograste

Construiste, paso a paso y **tú mismo**, una base de datos relacional de 3 tablas:

```
tutores ──< mascotas ──< consultas_veterinarias >── tutores
```

Mira el modelo completo en el [diagrama entidad-relación](README.md#modelo-de-datos).

> 📤 **Entrega:** guarda tu `CREATE TABLE consultas_veterinarias` y tus `INSERT` en
> `paso3.sql`, y una captura del resultado del **JOIN** de las 3 tablas. Dónde ubicar los
> archivos: [Entrega](ENTREGA.md).

➡️ **Próximo reto:** con todo esto ya puedes diseñar tu **propia** base de datos más completa
desde cero. ¡Ese será el siguiente ejercicio!
