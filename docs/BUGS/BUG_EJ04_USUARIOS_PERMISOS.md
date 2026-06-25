# Bug — Ejercicio 04: conexión como usuario nuevo falla en devcontainer

**Estado: PENDIENTE — falta mensaje de error exacto para confirmar causa**
**Afecta:** [exercise/04-admin-psql/paso2.md](../../exercise/04-admin-psql/paso2.md)

---

## Síntoma reportado

Al crear el usuario `recepcionista` desde psql, salir con `\q` y reconectar:

```bash
psql -U recepcionista -d veterinariadb
```

Se genera un error. El ejercicio falla en este entorno pero funciona en instalación local.

---

## Hallazgos de la investigación

### 1. La secuencia del ejercicio funciona correctamente (cuando PGHOST está activo)

Reproducción completa ejecutada en el devcontainer — todos los pasos pasan:

```bash
psql -U postgres -c "CREATE USER recepcionista WITH PASSWORD 'clave123';"
# → CREATE ROLE ✅

psql -U postgres -c "GRANT CONNECT ON DATABASE veterinariadb TO recepcionista;"
# → GRANT ✅

psql -U postgres -d veterinariadb -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO recepcionista;"
# → GRANT ✅

psql -U recepcionista -d veterinariadb -c "SELECT nombre, especie FROM mascotas LIMIT 2;"
# → Firulais | Perro  ✅

psql -U recepcionista -d veterinariadb -c "INSERT INTO mascotas (nombre, especie, tutor_id) VALUES ('Test', 'Gato', 1);"
# → ERROR: permission denied for table mascotas  ✅ (comportamiento esperado)
```

El método de autenticación confirmado es `trust` y **no se usa contraseña** (`Password Used: false`).

### 2. Diferencia arquitectónica clave: no hay socket Unix en el workspace

En una instalación **local**, psql se conecta por socket Unix:
```
/var/run/postgresql/.s.PGSQL.5432
```

En el **devcontainer**, el socket NO existe en el workspace — PostgreSQL está en un
contenedor separado:

```bash
ls /var/run/postgresql/
# → No such file or directory
```

Si `PGHOST` no está definido, psql intenta el socket y falla para TODOS los usuarios:

```
psql: error: connection to server on socket "/var/run/postgresql/.s.PGSQL.5432" failed:
No such file or directory — Is the server running locally?
```

En el devcontainer, **toda conexión psql depende de `PGHOST=postgres`** (TCP al contenedor).

### 3. PGHOST está en remoteEnv pero puede no estar presente en todos los contextos

El `devcontainer.json` inyecta:
```json
"remoteEnv": {
  "PGHOST": "postgres",
  "PGUSER": "postgres",
  "PGDATABASE": "postgres"
}
```

Estos valores están disponibles en el terminal de VS Code. Pero si un terminal se abre
fuera del contexto del devcontainer (ej. script de shell, herramienta externa), `PGHOST`
podría no estar definido y todo falla.

### 4. El error "permission denied" esperado puede confundirse con un bug

El paso 4.2 espera que el INSERT falle:
```
ERROR:  permission denied for table mascotas
```

Si el alumno interpreta esto como un error del ejercicio (no como el resultado correcto),
reportaría el ejercicio como roto.

---

## Causa probable (pendiente de confirmar con el mensaje de error exacto)

| Hipótesis | Síntoma | Verificación |
|---|---|---|
| `PGHOST` no definido en el contexto donde se ejecuta psql | `No such file or directory` en socket | `echo $PGHOST` antes de psql |
| El INSERT falla con `permission denied` y se interpreta como bug | `ERROR: permission denied for table mascotas` | Es comportamiento **correcto** |
| `pg_hba.conf` no montado correctamente y usa auth por defecto (scram) | `password authentication failed` al reconectar como recepcionista | Ver logs del contenedor postgres |

---

## Cómo verificar en la próxima sesión

Al reproducir el error, ejecutar:

```bash
# 1. Verificar que PGHOST está definido
echo "PGHOST=$PGHOST"
# Debe mostrar: PGHOST=postgres

# 2. Si está vacío, definirlo manualmente y probar
export PGHOST=postgres
psql -U recepcionista -d veterinariadb -c "SELECT 1;"

# 3. Si falla con error de autenticación, verificar pg_hba.conf activo
psql -U postgres -c "SELECT type, database, user_name, address, auth_method FROM pg_hba_file_rules;"
# Debe mostrar: host | {all} | {all} | 0.0.0.0 | trust

# 4. Capturar el mensaje de error exacto y agregarlo aquí
```

---

## Diferencia local vs devcontainer (resumen)

| Aspecto | Local | Devcontainer |
|---|---|---|
| Transporte psql | Socket Unix (`/var/run/postgresql/`) | TCP al host `postgres:5432` |
| Necesita `PGHOST` | No (socket local) | Sí (obligatorio) |
| Auth método | Depende del pg_hba.conf local | `trust` (custom pg_hba.conf) |
| `recepcionista` necesita password | Sí (md5/scram en default) | No (trust) |

---

## Próximo paso

Reproducir el error con `PGHOST` definido y capturar el mensaje exacto.
Actualizar esta sección con el error real para confirmar la causa y aplicar fix.
