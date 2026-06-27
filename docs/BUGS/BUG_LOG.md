# Registro de bugs — Entorno pgAdmin + PostgreSQL en Codespaces

---

## Bug 1 — pgAdmin no puede resolver el host `postgres`

**Estado: RESUELTO**

### Error

```
failed to resolve host 'postgres': [Errno -2] Name does not resolve
```

Se mostraba en el diálogo "Connect to Server" de pgAdmin al intentar conectarse al servidor "PostgreSQL Curso".

### Causa

El `servers.json` configuraba `"Host": "postgres"` esperando que el DNS interno de Docker resuelva el nombre del servicio. En entornos **GitHub Codespaces con `docker-outside-of-docker`**, docker-compose genera una red con nombre prefijado automáticamente (ej. `postgrespace_default`) y los contenedores podían quedar en redes distintas, rompiendo la resolución de nombres entre servicios.

### Solución aplicada

Agregar una red explícita `pgnet` en [docker-compose.yml](../.devcontainer/docker-compose.yml) y conectar los tres servicios (`workspace`, `postgres`, `pgadmin`) a ella:

```yaml
networks:
  pgnet:
    driver: bridge

services:
  workspace:
    networks: [pgnet]
  postgres:
    networks: [pgnet]
  pgadmin:
    networks: [pgnet]
```

Con esto el DNS interno de Docker garantiza que `postgres` resuelve correctamente desde el contenedor de pgAdmin.

---

## Bug 2 — pgAdmin pide contraseña al conectar (popup al abrir)

**Estado: RESUELTO**

### Síntoma

Al abrir pgAdmin, aparecía el diálogo "Connect to Server — Please enter the password for the user 'postgres'" aunque el servidor ya estaba pre-registrado vía `servers.json`.

### Causa

`servers.json` pre-registra el servidor pero pgAdmin **no acepta contraseñas en texto plano** en ese archivo por razones de seguridad. Al no haber credencial almacenada, pgAdmin la solicita en cada sesión.

### Solución aplicada

Se usó el mecanismo estándar de PostgreSQL: un **pgpassfile** (equivalente a `~/.pgpass`).

1. Crear [.devcontainer/pgadmin/pgpassfile](../.devcontainer/pgadmin/pgpassfile):

```
postgres:5432:*:postgres:1234
```

2. Agregar `"Passfile": "/pgpassfile"` en [servers.json](../.devcontainer/pgadmin/servers.json):

```json
{
  "Servers": {
    "1": {
      "Name": "PostgreSQL Curso",
      "Host": "postgres",
      "Port": 5432,
      "Username": "postgres",
      "SSLMode": "prefer",
      "Passfile": "/pgpassfile"
    }
  }
}
```

3. Montar el archivo en el contenedor de pgAdmin en [docker-compose.yml](../.devcontainer/docker-compose.yml):

```yaml
volumes:
  - ./pgadmin/pgpassfile:/pgpassfile
```

---

## Bug 3 — `veterinariadb` no se creaba al iniciar el contenedor

**Estado: RESUELTO**

### Síntoma

Al abrir pgAdmin, solo aparecía la base de datos `postgres` (la por defecto). La base de datos `veterinariadb` definida en [.devcontainer/initdb/veterinaria.sql](../.devcontainer/initdb/veterinaria.sql) no existía.

### Causa

Los scripts en `docker-entrypoint-initdb.d` **solo se ejecutan cuando el data directory de PostgreSQL está completamente vacío**. La carpeta `pgdta/` (volumen persistente mapeado a `/var/lib/postgresql/data`) ya contenía datos de una inicialización anterior del Codespace. Al detectar que el directorio no estaba vacío, PostgreSQL omitió los scripts de `initdb` y arrancó directamente con los datos existentes.

### Solución aplicada

1. Detener el contenedor de PostgreSQL:
   ```bash
   docker stop postgrespace_devcontainer-postgres-1
   ```

2. Limpiar el data directory con permisos de root (los archivos son del uid 999 del proceso postgres):
   ```bash
   sudo find /workspaces/postgrespace/pgdta -mindepth 1 -delete
   ```

3. Reiniciar el contenedor. PostgreSQL detecta el directorio vacío, ejecuta `initdb` y luego corre `veterinaria.sql`, creando `veterinariadb` con la tabla `tutores` y 2 registros de ejemplo.

### Estado actual verificado

```
     Name      |  Owner
---------------+----------
 postgres      | postgres
 veterinariadb | postgres

 id_tutor |     nombre     | telefono
----------+----------------+----------
        1 | Carlos Mendoza | 555-1234
        2 | Ana Gómez      | 555-5678
```

### Nota para futuras sesiones

Si el Codespace ya tiene datos en `pgdta/`, `veterinariadb` seguirá existente entre sesiones — ese es el comportamiento correcto (persistencia). Solo es necesario limpiar `pgdta/` si se quiere **resetear** el entorno desde cero.

---

## Bug 4 — `FATAL: could not open file "global/pg_filenode.map": Permission denied`

**Estado: RESUELTO**

### Síntoma

Al intentar conectar desde pgAdmin, el diálogo mostraba:
```
connection failed: connection to server at "172.18.0.2", port 5432 failed:
FATAL: could not open file "global/pg_filenode.map": Permission denied
```

### Causa

El bind mount `../pgdta:/var/lib/postgresql/data` causaba un desajuste de UID en Codespaces con `docker-outside-of-docker`. Cuando el container postgres (uid 999) escribía archivos en ese directorio, el sistema de archivos del Codespace los registraba como propiedad de uid 1000 (el usuario `vscode`). Al leerlos de vuelta desde el container, postgres (uid 999) no tenía permiso de lectura sobre sus propios archivos.

### Solución aplicada

Eliminar completamente el bind mount de `pgdta/` del servicio postgres en [docker-compose.yml](../.devcontainer/docker-compose.yml). Sin bind mount, Docker crea un volumen anónimo gestionado internamente donde PostgreSQL inicializa sus archivos con los permisos correctos (uid 999). Los scripts de `initdb` siguen funcionando porque el volumen anónimo comienza vacío.

```yaml
# Antes (causaba el bug):
volumes:
  - ../pgdta:/var/lib/postgresql/data  # ← ELIMINADO
  - ./initdb:/docker-entrypoint-initdb.d
  - ./pg_hba.conf:/etc/postgresql/pg_hba.conf

# Después:
volumes:
  - ./initdb:/docker-entrypoint-initdb.d
  - ./pg_hba.conf:/etc/postgresql/pg_hba.conf
```

El directorio `pgdta/` también fue eliminado del proyecto.

---

## Estado general del entorno

| Componente | Estado |
|---|---|
| Red Docker `pgnet` | Activa — los tres servicios se resuelven por nombre |
| PostgreSQL 16 | Corriendo en puerto 5432 |
| `veterinariadb` + tabla `tutores` | Creada con datos de ejemplo |
| pgAdmin 4 | Corriendo en puerto 5050 |
| Conexión pgAdmin → postgres | Automática sin popup de contraseña (pgpassfile) |
| Volumen postgres | Anónimo (gestionado por Docker, sin bind mount) |
