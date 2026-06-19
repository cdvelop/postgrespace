# Ejercicio 1 — psql, backup y usuarios

> 🎯 **Qué vas a aprender:** qué es `psql` y cómo usarlo desde la terminal, cómo hacer
> un backup desde pgAdmin y desde la terminal con `pg_dump`, cómo restaurar una base, y
> cómo crear un **usuario con permisos limitados** para proteger tus datos.

---

## Paso 1.0 — Prepara tu punto de partida (¡no te lo saltes!)

Ejecuta [`setup.sql`](setup.sql) en el Query Tool de pgAdmin sobre `veterinariadb`.
Luego verifica que los datos estén completos:

```sql
SELECT (SELECT COUNT(*) FROM tutores)                  AS tutores,
       (SELECT COUNT(*) FROM mascotas)                 AS mascotas,
       (SELECT COUNT(*) FROM veterinarios)             AS veterinarios,
       (SELECT COUNT(*) FROM consultas_veterinarias)   AS consultas,
       (SELECT COUNT(*) FROM servicios)                AS servicios,
       (SELECT COUNT(*) FROM consulta_servicios)       AS relaciones;
```

Debe dar **4, 8, 3, 9, 6, 15**. ✅

---

## Paso 1.1 — ¿Qué es psql?

**pgAdmin** es la interfaz gráfica que usas cuando haces clic con el ratón. Útil para
explorar, pero no existe en un servidor real: ahí solo hay terminal.

**`psql`** es la terminal oficial de PostgreSQL. Con ella puedes hacer todo lo que haces
en pgAdmin, pero escribiendo comandos. Es lo que usan los administradores de bases de
datos en producción.

> 🎬 **Antes de continuar:** mira el video
> [Aprende a usar psql paso a paso](https://youtu.be/DmZkPTZXjNw?si=tCaUEoCgQ_IRHIqL)
> (10 min, en español). Cubre exactamente los comandos que usarás en este set.
> Regresa aquí cuando termines.

---

## Paso 1.2 — Tu primera sesión en psql

### Si usas Codespaces

Abre el **Terminal** integrado de VS Code (menú **Terminal → New Terminal**).
Estás dentro del contenedor donde ya vive PostgreSQL — no instales nada.

### Si usas instalación local en Windows

Abre el programa **SQL Shell (psql)** desde el menú de inicio. Pulsa Enter en cada
campo para aceptar los valores por defecto y escribe la contraseña cuando la pida.

> 🎬 Este video muestra el flujo completo desde Windows:
> [psql desde Windows](https://youtu.be/zMc2xeO1F_k?si=rk5lQ-cArkW4IJD5)

---

Conéctate a la veterinaria (en Codespaces):

```bash
psql -U postgres -d veterinariadb
```

El prompt cambia a `veterinariadb=#`. Estás dentro. Prueba estos comandos uno por uno:

```
\l
```
Lista todas las bases de datos del servidor.

```
\dt
```
Lista las tablas de `veterinariadb`.

```sql
SELECT nombre, especie FROM mascotas LIMIT 3;
```
Una consulta real — igual que en pgAdmin, pero en la terminal.

```
\du
```
Lista los **usuarios** del servidor. Ahora mismo solo hay uno: `postgres` (superusuario).

```
\conninfo
```
Muestra a qué servidor, base de datos y usuario estás conectado.

```
\q
```
Sale de psql. Vuelves al terminal normal.

> 💡 Si el prompt cambia a `->`, psql espera más input — generalmente falta el `;`.
> Escríbelo y pulsa Enter.

---

## Paso 1.3 — Backup desde pgAdmin (tu primera vez)

Hacer un backup en pgAdmin es distinto según tu entorno. Ambos producen el mismo
resultado: un archivo `.sql` que recrea toda tu base de datos si lo ejecutas.

> 🎬 Si usas **instalación local en Windows**, este video (en inglés, con opción de
> audio en español) muestra el proceso completo en pgAdmin:
> [Backup y restauración desde pgAdmin](https://youtu.be/zMkkjSQD7SU?si=DhjQZg9CGDjAa_CN)

### Si usas Codespaces

En pgAdmin, pgAdmin solo puede ver su propio sistema de archivos interno — que ya está
conectado a la carpeta `data/` de tu proyecto. Por eso al guardar:

1. Click derecho sobre **`veterinariadb`** → **Backup...**
2. En **Format** selecciona **Plain**
3. En **Filename** escribe **solo el nombre** (sin ruta):
   ```
   veterinaria_pgadmin.sql
   ```
4. Haz clic en **Backup**

El archivo aparece automáticamente en `data/veterinaria_pgadmin.sql` dentro de tu
proyecto en VS Code.

### Si usas instalación local

En pgAdmin puedes navegar a cualquier carpeta. Usa el botón de carpeta junto al campo
**Filename** para navegar hasta la carpeta `04-procedimientos-psql` dentro de tu entrega,
y escribe el nombre:

```
paso1_backup.sql
```

---

Abre el archivo desde VS Code y mira su contenido: verás `CREATE TABLE`, `INSERT`,
`ALTER TABLE`... Ese archivo **es** tu base de datos en texto plano. Si lo ejecutas
en un PostgreSQL vacío, recrea todo.

---

## Paso 1.4 — Backup desde la terminal con `pg_dump`

`pg_dump` hace lo mismo que pgAdmin, pero desde la terminal. Con él puedes guardar
el archivo **directamente en tu carpeta de entrega** en un solo comando.

### Si usas Codespaces

El terminal de VS Code abre en la raíz del repositorio, así que las rutas relativas
funcionan directamente. Crea la carpeta de entrega si no existe (reemplaza con tu
apellido y nombre):

```bash
mkdir -p entregas/apellido_nombre/04-procedimientos-psql
```

Luego genera el backup directamente ahí:

```bash
pg_dump -U postgres -d veterinariadb > entregas/apellido_nombre/04-procedimientos-psql/paso1_backup.sql
```

### Si usas instalación local

Abre el terminal de VS Code (**Terminal → New Terminal**): se abre en la carpeta raíz
de tu proyecto. Desde ahí las rutas relativas también funcionan — el comando es
exactamente el mismo:

```bash
mkdir -p entregas/apellido_nombre/04-procedimientos-psql
pg_dump -U postgres -d veterinariadb > entregas/apellido_nombre/04-procedimientos-psql/paso1_backup.sql
```

> 💡 Si te pide contraseña, agrega `-W` al comando: `pg_dump -U postgres -W -d veterinariadb > ...`

---

| Parte | Qué significa |
|---|---|
| `-U postgres` | usuario de PostgreSQL |
| `-d veterinariadb` | base de datos a exportar |
| `> entregas/.../paso1_backup.sql` | redirige la salida al archivo en tu carpeta de entrega |

Abre el archivo desde VS Code y compáralo con el de pgAdmin: el contenido es
prácticamente idéntico. Con `pg_dump` el archivo quedó en tu entrega sin pasos intermedios.

---

## Paso 1.5 — Restaura en una base nueva

La restauración tiene dos pasos: crear la base destino y volcar el archivo.

**1. Crea la base destino:**

```bash
psql -U postgres -c "CREATE DATABASE veterinaria_respaldo;"
```

El flag `-c` ejecuta un comando SQL desde la terminal sin entrar al prompt interactivo.

**2. Restaura el backup:**

```bash
psql -U postgres -d veterinaria_respaldo < entregas/apellido_nombre/04-procedimientos-psql/paso1_backup.sql
```

> 💡 Reemplaza `apellido_nombre` con el nombre de tu carpeta de entrega.

Verás mensajes como `SET`, `CREATE TABLE`, `INSERT`... PostgreSQL ejecuta tu archivo
línea por línea. Si termina sin `ERROR`, la restauración fue exitosa. ✅

**3. Verifica que los datos llegaron intactos:**

```bash
psql -U postgres -d veterinaria_respaldo -c "
SELECT (SELECT COUNT(*) FROM tutores)                 AS tutores,
       (SELECT COUNT(*) FROM mascotas)                AS mascotas,
       (SELECT COUNT(*) FROM veterinarios)            AS veterinarios,
       (SELECT COUNT(*) FROM consultas_veterinarias)  AS consultas;
"
```

Debe dar **4, 8, 3, 9**. ✅ Guarda el output de este comando: es parte de tu entrega.

---

## Paso 1.6 — Crea un usuario con permisos limitados

Hasta ahora todo lo haces como `postgres`, el superusuario que puede hacer cualquier
cosa. En una aplicación real esto es peligroso: si alguien roba las credenciales, tiene
acceso total. La solución es crear **usuarios con permisos mínimos**.

Vamos a crear un usuario `recepcionista` que solo puede leer (`SELECT`) la veterinaria,
sin poder modificar ni borrar nada.

Abre psql como superusuario:

```bash
psql -U postgres
```

**Crea el usuario:**

```sql
CREATE USER recepcionista WITH PASSWORD 'clave123';
```

**Dale acceso a la base de datos:**

```sql
GRANT CONNECT ON DATABASE veterinariadb TO recepcionista;
```

**Dale permiso de lectura en todas las tablas:**

```sql
\c veterinariadb
GRANT SELECT ON ALL TABLES IN SCHEMA public TO recepcionista;
```

**Sale:**

```
\q
```

---

## Paso 1.7 — Verifica que los permisos funcionan

Conéctate como `recepcionista`:

```bash
psql -U recepcionista -d veterinariadb
```

**Esto debe funcionar (puede leer):**

```sql
SELECT nombre, especie FROM mascotas;
```

**Esto debe fallar (no puede escribir):**

```sql
INSERT INTO mascotas (nombre, especie, tutor_id) VALUES ('Test', 'Gato', 1);
```

Verás: `ERROR: permission denied for table mascotas` ✅

Eso es exactamente lo que queremos. Sal con `\q`.

---

## Paso 1.8 — 🧪 Tu turno: usuario con permisos parciales

Crea un segundo usuario llamado `veterinario_app` que pueda hacer `SELECT` e `INSERT`
en `consultas_veterinarias` y `consulta_servicios`, pero **no** pueda modificar
`tutores` ni `mascotas`.

<details>
<summary>👀 Ver solución</summary>

```sql
-- Conéctate como superusuario
-- psql -U postgres

CREATE USER veterinario_app WITH PASSWORD 'vet_clave456';
GRANT CONNECT ON DATABASE veterinariadb TO veterinario_app;

\c veterinariadb

-- Acceso de escritura solo donde necesita operar
GRANT SELECT, INSERT ON consultas_veterinarias TO veterinario_app;
GRANT SELECT, INSERT ON consulta_servicios     TO veterinario_app;

-- Solo lectura en tablas de referencia (las necesita para los JOINs)
GRANT SELECT ON tutores, mascotas, veterinarios, servicios TO veterinario_app;
```

Verifica:

```bash
psql -U veterinario_app -d veterinariadb
```

```sql
-- Funciona:
SELECT * FROM consultas_veterinarias LIMIT 2;

-- Falla:
DELETE FROM tutores WHERE id_tutor = 1;
-- ERROR: permission denied for table tutores
```

</details>

---

## ✅ Lo que lograste

* **`psql`** → la terminal de PostgreSQL: navegar, consultar y administrar sin GUI.
* **Backup en pgAdmin** → formato Plain, guardado escribiendo solo el nombre del archivo.
* **`pg_dump`** → backup directo a la carpeta de entrega en un solo comando.
* **`psql -c`** → ejecutar un comando SQL sin entrar al prompt interactivo.
* **`psql < archivo.sql`** → restaurar una base completa desde un archivo.
* **`CREATE USER` + `GRANT`** → usuarios con permisos mínimos para proteger los datos.

> 📤 **Entrega:**
> - `paso1_backup.sql` → ya quedó en tu carpeta de entrega al hacer `pg_dump`
> - `paso1.txt` → copia el output de la terminal del paso 1.5 (restauración + verificación)
> - `paso1.png` → captura del paso 1.7 mostrando el `ERROR: permission denied`
>
> Dónde ubicar los archivos: [Entrega](ENTREGA.md).

➡️ **Siguiente:** en el [Ejercicio 2](paso2.md) crearás tu primera **función almacenada**
para encapsular consultas que usas con frecuencia.
