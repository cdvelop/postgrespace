# Ejercicio 2 — Muchos a muchos (la tabla puente)

> 🎯 **Qué vas a aprender:** a modelar una relación **muchos-a-muchos (N:M)** con una **tabla
> puente**. Es el concepto relacional más importante que te faltaba y aparece en casi todos los
> sistemas reales (pedidos↔productos, alumnos↔cursos, consultas↔servicios).

Una consulta puede incluir **varios servicios** (vacuna, examen, baño…), y un mismo servicio
aparece en **muchas consultas**. Eso es **muchos-a-muchos**.

```
  consultas (muchas) >────< (muchos) servicios
```

> ⚠️ **Una sola clave foránea NO alcanza.** Si pusieras `servicio_id` dentro de `consultas`,
> cada consulta tendría **un solo** servicio. Y al revés tampoco. La única forma correcta es
> una **tabla intermedia** que guarde cada *pareja* (consulta, servicio).

---

## Paso 2.1 — Crea la tabla `servicios` (CREAR)

```sql
CREATE TABLE servicios (
    id_servicio SERIAL PRIMARY KEY,
    nombre      VARCHAR(50) NOT NULL UNIQUE,   -- no puede haber 2 servicios con el mismo nombre
    precio      DECIMAL(6,2) CHECK (precio >= 0)
);

INSERT INTO servicios (nombre, precio) VALUES
('Vacuna',          20.00),  -- id 1
('Examen general',  15.00),  -- id 2
('Baño',            10.00),  -- id 3
('Desparasitación', 12.00),  -- id 4
('Radiografía',     25.00),  -- id 5
('Cirugía',        100.00);  -- id 6
```

> 💡 `UNIQUE` en `nombre` evita servicios duplicados. Fíjate que ya estás combinando lo del
> Set 01 (`CREATE`, `PRIMARY KEY`) con lo del Ejercicio 1 (`CHECK`, `UNIQUE`).

> 💰 **`DECIMAL(6,2)`** es para el dinero del `precio`: se lee `DECIMAL(precisión, escala)` →
> hasta **6 dígitos en total** y **2 después del punto** (máximo `9999.99`). Es exacto, sin los
> redondeos de la coma flotante. Lo viste por primera vez con el `costo` en el
> [Set 01 — Paso 3](../01-veterinaria/paso3.md#paso-31--crea-la-tabla-consultas_veterinarias-crear).

---

## Paso 2.2 — Crea la tabla puente `consulta_servicios` (LO NUEVO)

La tabla puente solo guarda **parejas**: qué consulta usó qué servicio. Tiene **dos** claves
foráneas (una a cada tabla que conecta).

```sql
CREATE TABLE consulta_servicios (
    consulta_id INT,
    servicio_id INT,

    -- 👇 La clave primaria es la PAREJA completa: impide repetir el mismo
    --    servicio dos veces en la misma consulta.
    PRIMARY KEY (consulta_id, servicio_id),

    CONSTRAINT fk_cs_consulta
        FOREIGN KEY (consulta_id) REFERENCES consultas_veterinarias(id_consulta)
        ON DELETE CASCADE,
    CONSTRAINT fk_cs_servicio
        FOREIGN KEY (servicio_id) REFERENCES servicios(id_servicio)
        ON DELETE CASCADE
);
```

> 🔑 **Clave primaria compuesta:** `PRIMARY KEY (consulta_id, servicio_id)` significa que la
> *combinación* de los dos no se puede repetir. Así, la consulta 1 no puede tener "Vacuna" dos
> veces, pero sí puede tener "Vacuna" **y** "Examen general". Justo lo que queremos.

---

## Paso 2.3 — Conecta consultas con servicios (INSERTAR parejas)

Cada fila dice "esta consulta incluyó este servicio". Una consulta con 2 servicios = 2 filas.

```sql
INSERT INTO consulta_servicios (consulta_id, servicio_id) VALUES
(1, 1), (1, 2),   -- consulta 1: Vacuna + Examen general
(2, 2),           -- consulta 2: Examen general
(3, 6), (3, 2),   -- consulta 3: Cirugía + Examen general
(4, 4),           -- consulta 4: Desparasitación
(5, 6), (5, 2),   -- consulta 5: Cirugía + Examen general
(6, 2),           -- consulta 6: Examen general
(7, 3),           -- consulta 7: Baño
(8, 1), (8, 2),   -- consulta 8: Vacuna + Examen general
(9, 5);           -- consulta 9: Radiografía
```

Mira el contenido de la tabla puente:

```sql
SELECT * FROM consulta_servicios ORDER BY consulta_id, servicio_id;
```

> 💡 Por sí sola se ve fea (solo números). Su magia aparece cuando la **unes** con las otras
> tablas para mostrar nombres legibles… eso es justo el [Ejercicio 3](paso3.md).

---

## Paso 2.4 — 🧪 Prueba la clave primaria compuesta (a propósito falla)

Intenta meter una pareja **repetida** (la consulta 1 ya tiene el servicio 1):

```sql
INSERT INTO consulta_servicios (consulta_id, servicio_id) VALUES (1, 1);
```

PostgreSQL lo **rechaza**:

```text
ERROR: duplicate key value violates unique constraint "consulta_servicios_pkey"
```

> 🎉 La clave primaria compuesta **impide** registrar dos veces el mismo servicio en la misma
> consulta. Integridad de datos en acción.

---

## ✅ Lo que lograste

* Entendiste **por qué** una FK simple no basta para una relación **N:M**.
* Creaste una **tabla puente** con **dos** claves foráneas.
* Usaste una **clave primaria compuesta** para impedir parejas repetidas.
* Reforzaste `UNIQUE` y `CHECK` del ejercicio anterior.

> 📤 **Entrega:** guarda en `paso2.sql` tus `CREATE TABLE servicios`, `CREATE TABLE
> consulta_servicios` y los `INSERT` de las parejas. Adjunta una captura del **error de clave
> duplicada** del paso 2.4. Dónde ubicar los archivos: [Entrega](ENTREGA.md).

➡️ **Siguiente:** en el [Ejercicio 3](paso3.md) unirás **hasta 5 tablas** en una sola consulta
para sacar reportes reales: qué servicios tuvo cada consulta y cuánto ingresó cada servicio.
