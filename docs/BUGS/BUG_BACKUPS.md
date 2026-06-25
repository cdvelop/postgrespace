# Bug: los backups de pgAdmin no aparecen en `data/`

> **Estado: RESUELTO** — solución aplicada en `.devcontainer/docker-compose.yml`.

## Síntoma

Al hacer un backup desde pgAdmin, el proceso reporta **"Successfully completed"**, pero el
archivo no aparece en `data/` del repo. Adicionalmente, pgAdmin creaba un subdirectorio
`data/postgres_sql.dev/` que no se deseaba.

## Causa raíz

pgAdmin almacena los archivos de cada usuario en un subdirectorio nombrado a partir del email
(`postgres@sql.dev` → `postgres_sql.dev/`). Ese directorio se crea con `os.makedirs(dir, 0o700)`
— permisos `drwx------`, solo accesibles por uid 5050 — bloqueando la lectura desde el host.

El volumen original `../data:/var/lib/pgadmin/storage` hacía que pgAdmin creara y gestionara
ese subdirectorio por su cuenta.

## Solución definitiva

Montar `data/` **directamente** sobre el path del subdirectorio del usuario dentro del
contenedor, en vez de sobre el directorio padre:

```yaml
volumes:
  - ../data:/var/lib/pgadmin/storage/postgres_sql.dev
```

Resultado:
- pgAdmin detecta que `postgres_sql.dev/` ya existe (es el mount point) y **no intenta crearlo
  ni hacerle `chmod 700`**.
- Los backups se escriben directamente en `data/` sin subcarpeta intermedia.
- No se necesita entrypoint personalizado ni loops de corrección de permisos.

### Configuración final en `.devcontainer/docker-compose.yml`

```yaml
pgadmin:
  image: dpage/pgadmin4:latest
  restart: unless-stopped
  user: root
  environment:
    PGADMIN_DEFAULT_EMAIL: postgres@sql.dev
    PGADMIN_DEFAULT_PASSWORD: 1234
  ports:
    - "5050:80"
  volumes:
    - ../data:/var/lib/pgadmin/storage/postgres_sql.dev
```

> **Nota:** el nombre `postgres_sql.dev` del path dentro del contenedor corresponde al email
> del usuario de pgAdmin (`postgres@sql.dev`), donde `@` y `.` se reemplazan por `_`.
> Si se cambia el email, hay que actualizar también el path del volumen.

## Historial de diagnóstico

1. **Primer intento** — se añadió `user: root` y el volumen `../data:/var/lib/pgadmin/storage`.
   El volumen quedó montado pero pgAdmin seguía creando `postgres_sql.dev/` con `700`.
2. **Fix temporal** — `chmod 755` manual desde dentro del contenedor. Funcionaba hasta el
   próximo rebuild.
3. **Segundo intento** — loop background en el entrypoint haciendo `chmod 755` cada 5 s.
   Funcionaba pero añadía complejidad innecesaria.
4. **Solución final** — cambiar el target del mount a `.../postgres_sql.dev` directamente.
   pgAdmin no recrea ni restringe el directorio. Sin entrypoint personalizado.

## Checklist

- [x] Causa raíz identificada: `os.makedirs(dir, 0o700)` en código Python de pgAdmin.
- [x] Volumen apunta directamente al subdirectorio del usuario.
- [x] Backups guardados en `data/` sin subcarpeta intermedia.
- [x] Entrypoint personalizado eliminado (ya no necesario).
- [x] Ficheros anteriores (`respaldo1.db`, `respaldo2.txt`) migrados a `data/`.
