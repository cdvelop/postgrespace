# Ejercicio 5 — Backup y restauración

> 🎯 **Qué vas a aprender:** a hacer un respaldo completo con `pg_dump`, a simular
> un accidente real (modificar datos y borrar la base) y a restaurar desde el backup
> comprobando que todo vuelve exactamente como estaba.

---

## Paso 5.0 — ¿Para qué sirve un backup?

Un backup es una copia de tu base de datos guardada como archivo de texto con
instrucciones SQL. Si algo sale mal — un error, un borrado accidental, un servidor
caído — puedes volver exactamente al estado que tenías cuando hiciste la copia.

En este ejercicio lo vas a comprobar de forma concreta: harás un cambio en los datos,
**borrarás la base entera** y luego la restaurarás desde el backup.

---

## Paso 5.1 — Backup desde pgAdmin

Antes de usar la terminal, hazlo desde pgAdmin para ver cómo funciona la interfaz.

### Si usas Codespaces

1. Click derecho sobre **`veterinariadb`** en el árbol → **Backup...**
2. En **Format** selecciona **Plain**
3. En **Filename** escribe solo el nombre (sin ruta):
   ```
   veterinaria_antes.sql
   ```
4. Haz clic en **Backup**

El archivo aparece en `data/veterinaria_antes.sql` dentro de tu proyecto en VS Code.

### Si usas instalación local

1. Click derecho sobre **`veterinariadb`** → **Backup...**
2. En **Format** selecciona **Plain**
3. Usa el botón de carpeta para navegar hasta tu carpeta de entrega y escribe:
   ```
   veterinaria_antes.sql
   ```
4. Haz clic en **Backup**

<details>
<summary>📺 Video: backup y restauración desde pgAdmin en Windows</summary>

[Backup y restauración en pgAdmin (audio disponible en español)](https://youtu.be/zMkkjSQD7SU?si=DhjQZg9CGDjAa_CN)

</details>

---

Abre el archivo desde VS Code. Verás `CREATE TABLE`, `INSERT`, `ALTER TABLE`...
Ese archivo **es** tu base de datos completa en texto plano.

---

## Paso 5.2 — Backup desde la terminal con `pg_dump`

Ahora haz el mismo backup desde la terminal. La ventaja: puedes elegir exactamente
dónde queda el archivo y automatizarlo en scripts.

Abre el terminal de VS Code y crea la carpeta de entrega si aún no existe
(reemplaza con tu apellido y nombre):

```bash
mkdir -p entregas/apellido_nombre/04-procedimientos-psql
```

Genera el backup directamente en tu carpeta de entrega:

```bash
pg_dump -U postgres -d veterinariadb > entregas/apellido_nombre/04-procedimientos-psql/paso3_backup.sql
```

> 💡 **Local en Windows:** si `pg_dump` pide contraseña agrega `-W` al comando.
> El terminal de VS Code abre en la raíz del proyecto, así que la ruta relativa funciona igual.

Abre el archivo y compáralo con el de pgAdmin: el contenido es prácticamente idéntico.

---

## Paso 5.3 — Modifica un dato conocido

Para poder verificar la restauración después, haz un cambio pequeño y memorable.

En pgAdmin, ejecuta en `veterinariadb`:

```sql
-- Anota el nombre original
SELECT id_mascota, nombre FROM mascotas WHERE id_mascota = 1;
-- Resultado: Firulais

-- Cambia el nombre
UPDATE mascotas SET nombre = 'Firu_MODIFICADO' WHERE id_mascota = 1;

-- Confirma el cambio
SELECT id_mascota, nombre FROM mascotas WHERE id_mascota = 1;
-- Resultado: Firu_MODIFICADO
```

Ahora la base tiene un dato distinto al backup que acabas de hacer. ✅

---

## Paso 5.4 — Borra la base de datos (¡el momento tenso!)

Esto simula un accidente grave. Desde la terminal:

**1. Desconéctate de `veterinariadb`** (PostgreSQL no permite borrar una base con conexiones activas):

```bash
psql -U postgres -c "
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'veterinariadb' AND pid <> pg_backend_pid();
"
```

**2. Borra la base:**

```bash
psql -U postgres -c "DROP DATABASE veterinariadb;"
```

**3. Confirma que ya no existe:**

```bash
psql -U postgres -c "\l"
```

`veterinariadb` ya no aparece. La base desapareció. 😱

---

## Paso 5.5 — Restaura desde el backup

**1. Crea la base vacía:**

```bash
psql -U postgres -c "CREATE DATABASE veterinariadb;"
```

**2. Restaura el backup:**

```bash
psql -U postgres -d veterinariadb < entregas/apellido_nombre/04-procedimientos-psql/paso3_backup.sql
```

Verás mensajes: `SET`, `CREATE TABLE`, `INSERT`... PostgreSQL está ejecutando tu
archivo línea por línea. Si termina sin `ERROR`, la restauración fue exitosa. ✅

**3. Verifica que los datos volvieron:**

```bash
psql -U postgres -d veterinariadb -c "SELECT id_mascota, nombre FROM mascotas WHERE id_mascota = 1;"
```

Resultado esperado:

```
 id_mascota | nombre
------------+---------
          1 | Firulais
```

**El nombre es `Firulais` — no `Firu_MODIFICADO`** — porque el backup se hizo antes
del cambio. La base está exactamente como estaba cuando hiciste el respaldo. ✅

---

## Paso 5.6 — Verifica el conteo completo

```bash
psql -U postgres -d veterinariadb -c "
SELECT (SELECT COUNT(*) FROM tutores)                 AS tutores,
       (SELECT COUNT(*) FROM mascotas)                AS mascotas,
       (SELECT COUNT(*) FROM veterinarios)            AS veterinarios,
       (SELECT COUNT(*) FROM consultas_veterinarias)  AS consultas,
       (SELECT COUNT(*) FROM servicios)               AS servicios,
       (SELECT COUNT(*) FROM consulta_servicios)      AS relaciones;
"
```

Debe dar **4, 8, 3, 9, 6, 15**. ✅ Todo está intacto.

---

## ✅ Lo que lograste

| Herramienta | Qué hace |
|---|---|
| pgAdmin → Backup (Plain) | Backup desde la interfaz gráfica |
| `pg_dump -U postgres -d db > archivo.sql` | Backup completo desde la terminal |
| `psql -U postgres -c "comando"` | Ejecuta SQL desde la terminal sin entrar al prompt |
| `psql -U postgres -d db < archivo.sql` | Restaura una base desde un archivo |
| `DROP DATABASE` + `CREATE DATABASE` | Ciclo completo de destrucción y recuperación |

> 📤 **Entrega:**
> - `paso3_backup.sql` → ya quedó en tu carpeta de entrega al hacer `pg_dump`
> - `paso3.txt` → copia el output de terminal de los pasos 5.4 y 5.5
> - `paso3.png` → captura del paso 5.6 mostrando `Firulais` restaurado y los conteos correctos
>
> Dónde ubicar los archivos: [Entrega](ENTREGA.md).

---

> 🎓 **Has completado el Set 04.** Ahora sabes usar psql, crear funciones y
> procedimientos, proteger datos con usuarios y permisos, y hacer backups reales.
> En el [Set 06](../06-python-veterinaria/README.md) usarás todo esto desde Python.
