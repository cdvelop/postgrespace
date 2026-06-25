# Ejercicio 4 — Usuarios y permisos

> 🎯 **Qué vas a aprender:** a crear **usuarios** con contraseña y a asignarles
> permisos específicos con `GRANT`. Así proteges los datos: cada persona o aplicación
> solo puede hacer lo que necesita.

---

## Paso 4.0 — El problema

Hasta ahora todo lo haces como `postgres`, el **superusuario** que puede hacer
cualquier cosa: crear tablas, borrar bases, cambiar contraseñas.

En una aplicación real esto es peligroso:
- La app de recepción no debería poder borrar registros históricos
- La app de reportes no debería poder modificar datos
- Si alguien roba las credenciales del superusuario, tiene acceso total

La solución es **el principio de mínimo privilegio**: cada usuario recibe solo los
permisos que necesita para su tarea, nada más.

---

## Paso 4.1 — Crea un usuario de solo lectura

Vamos a crear `recepcionista`: puede consultar datos pero no puede modificarlos.

Abre psql como superusuario:

```bash
psql -U postgres
```

**Crea el usuario con contraseña:**

```sql
CREATE USER recepcionista WITH PASSWORD 'clave123';
```

**Dale permiso de conectarse a la base:**

```sql
GRANT CONNECT ON DATABASE veterinariadb TO recepcionista;
```

**Conéctate a `veterinariadb`** (el `GRANT` sobre tablas debe ejecutarse dentro de esa base):

```
\c veterinariadb
```

```
You are now connected to database "veterinariadb" as user "postgres".
```

**Dale permiso de leer todas las tablas:**

```sql
GRANT SELECT ON ALL TABLES IN SCHEMA public TO recepcionista;
```

Sale de psql:

```
\q
```

---

## Paso 4.2 — Verifica que los permisos funcionan

Conéctate como `recepcionista`:

```bash
psql -U recepcionista -d veterinariadb
```

**Prueba que puede leer:**

```sql
SELECT nombre, especie FROM mascotas;
```

Funciona. ✅

**Prueba que no puede escribir:**

```sql
INSERT INTO mascotas (nombre, especie, tutor_id) VALUES ('Test', 'Gato', 1);
```

Resultado esperado:

```
ERROR:  permission denied for table mascotas
```

✅ Eso es exactamente lo que queremos. Sal con `\q`.

---

## Paso 4.3 — Revoca permisos

Si ya no necesitas que `recepcionista` tenga acceso a una tabla específica:

Primero sal de psql si todavía estás dentro:

```
\q
```

Luego conéctate como superusuario:

```bash
psql -U postgres -d veterinariadb
```

```sql
-- Quita el acceso a la tabla de costos
REVOKE SELECT ON consultas_veterinarias FROM recepcionista;
```

Verifica conectándote como `recepcionista`:

```
\q
```

```bash
psql -U recepcionista -d veterinariadb
```

```sql
SELECT costo FROM consultas_veterinarias;
```

```
ERROR:  permission denied for table consultas_veterinarias
```

✅ El permiso fue revocado. Sal y vuelve a darlo para no romper los pasos siguientes:

```
\q
```

```bash
psql -U postgres -d veterinariadb
```

```sql
GRANT SELECT ON consultas_veterinarias TO recepcionista;
\q
```

---

## Paso 4.4 — 🧪 Tu turno: usuario con permisos parciales

Crea un usuario `veterinario_app` que pueda insertar y consultar en
`consultas_veterinarias` y `consulta_servicios`, pero **solo leer** el resto de
las tablas (necesita leerlas para los JOINs).

<details>
<summary>👀 Ver solución</summary>

```sql
-- Como superusuario:
psql -U postgres
```

```sql
CREATE USER veterinario_app WITH PASSWORD 'vet456';
GRANT CONNECT ON DATABASE veterinariadb TO veterinario_app;
```

```
\c veterinariadb
```

```
You are now connected to database "veterinariadb" as user "postgres".
```

```sql
-- Escritura solo donde opera
GRANT SELECT, INSERT ON consultas_veterinarias TO veterinario_app;
GRANT SELECT, INSERT ON consulta_servicios     TO veterinario_app;

-- Solo lectura en tablas de referencia
GRANT SELECT ON tutores, mascotas, veterinarios, servicios TO veterinario_app;
```

Verifica:

```
\q
```

```bash
psql -U veterinario_app -d veterinariadb
```

```sql
-- Funciona:
SELECT id_consulta, motivo FROM consultas_veterinarias LIMIT 3;

-- Falla:
DELETE FROM tutores WHERE id_tutor = 1;
-- ERROR: permission denied for table tutores
```

</details>

---

## ✅ Lo que lograste

| Comando | Qué hace |
|---|---|
| `CREATE USER nombre WITH PASSWORD '...'` | Crea un usuario con contraseña |
| `GRANT CONNECT ON DATABASE db TO usuario` | Permite conectarse a la base |
| `GRANT SELECT ON ALL TABLES IN SCHEMA public TO usuario` | Acceso de solo lectura a todo |
| `GRANT SELECT, INSERT ON tabla TO usuario` | Permisos específicos por tabla |
| `REVOKE permiso ON tabla FROM usuario` | Quita un permiso |
| `\du` | Lista usuarios y sus roles |

> 📤 **Entrega:** guarda en `paso2.sql` los comandos `CREATE USER`, `GRANT` y `REVOKE`
> que ejecutaste (los del profesor y el ejercicio). Adjunta `paso2.png` con la captura
> del `ERROR: permission denied` al intentar insertar como `recepcionista`.
> Dónde ubicar los archivos: [Entrega](ENTREGA.md).

➡️ **Siguiente:** en el [Ejercicio 3](paso3.md) harás un **backup real** — modificarás
datos, borrarás la base y la restaurarás desde el respaldo.
