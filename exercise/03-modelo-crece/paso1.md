# Ejercicio 1 — Modifica una tabla que ya existe

> 🎯 **Qué vas a aprender:** a **modificar** una tabla viva (con datos) usando `ALTER TABLE`,
> a **conectarla** con una tabla nueva, y a ponerle **reglas de calidad** a los datos con
> `CHECK` y `DEFAULT`. Hasta ahora siempre creabas tablas desde cero; en la vida real las bases
> ya existen y se van **modificando**.

Vamos a registrar **qué veterinario atiende cada consulta**. Para eso crearemos la tabla
`veterinarios` y le agregaremos a `consultas_veterinarias` una columna que apunte a ella.

---

## Paso 1.0 — Prepara tu punto de partida (¡no te lo saltes!)

Ejecuta el script [`setup.sql`](setup.sql) en el Query Tool sobre `veterinariadb`
(menú **File → Open**, o copia su contenido, y `F5`). Deja la base con las 3 tablas y datos.
Comprueba:

```sql
SELECT (SELECT COUNT(*) FROM tutores)  AS tutores,
       (SELECT COUNT(*) FROM mascotas) AS mascotas,
       (SELECT COUNT(*) FROM consultas_veterinarias) AS consultas;
```

Debe dar **4, 8, 9**. ✅ Es seguro re-ejecutar `setup.sql` cuando quieras empezar limpio.

---

## Paso 1.1 — Crea la tabla `veterinarios` (CREAR)

```sql
CREATE TABLE veterinarios (
    id_veterinario SERIAL PRIMARY KEY,
    nombre         VARCHAR(50) NOT NULL,
    especialidad   VARCHAR(50)
);

INSERT INTO veterinarios (nombre, especialidad) VALUES
('Dra. Paula Ríos',  'Medicina general'),  -- id 1
('Dr. Hugo Salas',   'Cirugía'),           -- id 2
('Dra. Elena Costa', 'Dermatología');      -- id 3
```

Nada nuevo aquí: es un `CREATE TABLE` como los del Set 01. Lo interesante viene ahora.

---

## Paso 1.2 — Agrega una columna a una tabla con datos (`ALTER TABLE`)

Antes de modificarla, **mírala** para recordar qué columnas y datos tiene:

```sql
SELECT * FROM consultas_veterinarias;
```

Verás sus 9 consultas con `id_consulta`, `fecha_consulta`, `motivo`, `costo`, `tutor_id` y
`mascota_id`. Todavía **no** hay ninguna columna para el veterinario. Eso es lo que vamos a
agregar.

`consultas_veterinarias` ya existe y tiene esas 9 filas. **No la borramos**: le agregamos una
columna nueva con `ALTER TABLE`.

```sql
ALTER TABLE consultas_veterinarias
ADD COLUMN veterinario_id INT;
```

Mira qué pasó:

```sql
SELECT id_consulta, motivo, veterinario_id FROM consultas_veterinarias;
```

> 🔎 La columna nueva aparece en **todas** las filas existentes, pero **vacía** (`NULL`):
> PostgreSQL no inventa un veterinario, solo deja el hueco. En el paso 1.4 lo llenaremos.

---

## Paso 1.3 — Convierte esa columna en clave foránea (`ALTER TABLE ADD CONSTRAINT`)

La columna existe, pero todavía no es un "puente" hacia `veterinarios`. Le agregamos la FK:

```sql
ALTER TABLE consultas_veterinarias
ADD CONSTRAINT fk_consulta_veterinario
    FOREIGN KEY (veterinario_id)
    REFERENCES veterinarios(id_veterinario);
```

> 💡 Es la misma idea de clave foránea del Set 01, pero **añadida después** sobre una tabla que
> ya existía. A partir de ahora, `veterinario_id` solo aceptará valores que existan en
> `veterinarios` (o `NULL`).

---

## Paso 1.4 — Asigna un veterinario a cada consulta (`UPDATE`)

Las consultas existentes tienen `veterinario_id` en `NULL`. Vamos a asignarlos con `UPDATE`
(recuerda: el `WHERE` decide a cuáles afecta).

```sql
-- La Dra. Paula Ríos (1) atiende las generales
UPDATE consultas_veterinarias SET veterinario_id = 1 WHERE id_consulta IN (1, 2, 4, 7, 8);
-- El Dr. Hugo Salas (2) atiende las quirúrgicas y radiografías
UPDATE consultas_veterinarias SET veterinario_id = 2 WHERE id_consulta IN (3, 5, 9);
-- La Dra. Elena Costa (3) atiende la de la mascota con plumas
UPDATE consultas_veterinarias SET veterinario_id = 3 WHERE id_consulta = 6;
```

> 💡 **`IN (1, 2, 4, 7, 8)`** es un atajo: significa "que el `id_consulta` sea **alguno** de
> esos valores". Equivale a escribir `id_consulta = 1 OR id_consulta = 2 OR ...`, pero más
> corto y legible. Así, el primer `UPDATE` afecta de una sola vez a las consultas 1, 2, 4, 7 y 8.
> Cuando es un solo valor, basta con `= 6` (sin `IN`), como en el último.

Comprueba que ya no quedan consultas sin veterinario:

```sql
SELECT COUNT(*) AS sin_veterinario
FROM consultas_veterinarias
WHERE veterinario_id IS NULL;
```

Debe dar **0**. ✅

---

## Paso 1.5 — Ponle reglas de calidad: `CHECK` y `DEFAULT`

Una clave foránea protege las **relaciones**; ahora protegeremos los **valores**.

**`CHECK`** obliga a que una columna cumpla una condición. El costo nunca debería ser negativo:

```sql
ALTER TABLE consultas_veterinarias
ADD CONSTRAINT chk_costo_positivo CHECK (costo >= 0);
```

**`DEFAULT`** da un valor automático cuando no se especifica. Agreguemos si la consulta está
pagada, que por defecto sea "no":

```sql
ALTER TABLE consultas_veterinarias
ADD COLUMN pagada BOOLEAN DEFAULT false;
```

---

## Paso 1.6 — 🧪 Prueba el `CHECK` (a propósito falla)

Intenta registrar una consulta con costo negativo:

```sql
INSERT INTO consultas_veterinarias (fecha_consulta, motivo, costo, tutor_id, mascota_id, veterinario_id)
VALUES ('2026-06-01', 'Prueba', -10.00, 1, 1, 1);
```

PostgreSQL lo **rechaza**:

```text
ERROR: new row for relation "consultas_veterinarias" violates check constraint "chk_costo_positivo"
```

> 🎉 Justo lo que queremos: el `CHECK` **impide datos sin sentido** (un costo negativo). Igual
> que la FK protege las relaciones, el `CHECK` protege los valores.

---

## ✅ Lo que lograste

* **`ALTER TABLE ADD COLUMN`** → agregar una columna a una tabla con datos, sin borrarla.
* **`ALTER TABLE ADD CONSTRAINT`** → añadir una clave foránea *después* de crear la tabla.
* **`UPDATE ... WHERE`** → rellenar la columna nueva en las filas que ya existían.
* **`CHECK`** y **`DEFAULT`** → reglas que mantienen los datos limpios y con sentido.

> 📤 **Entrega:** guarda en `paso1.sql` tu `CREATE TABLE veterinarios` + los `ALTER TABLE` +
> los `UPDATE`. Adjunta una captura del `SELECT id_consulta, motivo, veterinario_id FROM
> consultas_veterinarias;` mostrando las consultas **ya con su veterinario**.
> Dónde ubicar los archivos: [Entrega](ENTREGA.md).

➡️ **Siguiente:** en el [Ejercicio 2](paso2.md) aprenderás a modelar lo que una sola clave
foránea **no puede**: una relación **muchos-a-muchos** con una **tabla puente**.
