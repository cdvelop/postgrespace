# Plan de Optimización del Devcontainer Educativo

> **Estado:** Borrador — pendiente de aprobación antes de implementar.
> **Rama de trabajo:** `claude/adoring-keller-ziya8v`

---

## 1. Problema actual

Al abrir el Codespace o el devcontainer local, el entorno tarda varios minutos
en estar listo. Los cuellos de botella identificados son:

| Componente | Imagen actual | Tamaño comprimido (descarga) |
|---|---|---|
| Workspace | `mcr.microsoft.com/devcontainers/base:ubuntu` | ~400 MB |
| PostgreSQL | `postgres:16` | ~153 MB |
| pgAdmin 4 | `dpage/pgadmin4:latest` | ~170 MB |
| **Total descarga** | | **~723 MB** |

Además del tamaño de las imágenes, el `postCreateCommand` ejecuta
`apt-get update && apt-get install ...` **en cada creación de contenedor**,
lo que suma 1–3 minutos adicionales en Codespaces dependiendo de la red.

---

## 2. Cuellos de botella identificados

### 2.1 `dpage/pgadmin4:latest` — imagen más prescindible (170 MB)

pgAdmin 4 es la herramienta más pesada del stack y la que más tarda en
arrancar (carga inicial de Python/Flask + generación de la sesión).
Para un curso de SQL introductorio no se necesitan las funciones avanzadas
(ERD, backup servidor-a-servidor, query statistics profundas).

### 2.2 `postgres:16` — variante Debian innecesaria (153 MB vs 111 MB Alpine)

Se usa la imagen Debian por defecto. La variante Alpine recorta ~42 MB de
descarga y ~130 MB descomprimida sin sacrificar ninguna funcionalidad usada
en el curso (SQL estándar, `psql`, scripts de init).

> **Nota:** Para versiones de PostgreSQL, el curso no necesita la última.
> `postgres:15-alpine` o incluso `postgres:14-alpine` son perfectamente
> válidas para aprender SQL y pesan igual o menos. Se propone `15-alpine`
> por tener soporte ICU y ser la versión más usada en producción actualmente.

### 2.3 `postCreateCommand` — instalación en caliente (1–3 min extra)

Cada vez que se crea el contenedor se descarga e instala desde apt:
- `postgresql-client`
- `python3`, `python3-pip`, `python3-psycopg2`

Solución: construir una imagen personalizada (Dockerfile) que pre-instale
estos paquetes, de modo que la capa quede cacheada en el registro.

### 2.4 `mcr.microsoft.com/devcontainers/base:ubuntu` — imagen base grande

La imagen base de Microsoft incluye muchas herramientas de desarrollo
genéricas no necesarias para un curso de SQL. Sin embargo, es la que
provee la integración con VS Code Remote / Codespaces, por lo que
reemplazarla requiere más cuidado. Se propone crear un Dockerfile
que la use como `FROM` y pre-instale solo lo necesario.

---

## 3. Opciones para reemplazar pgAdmin 4

### Opción A: `sosedoff/pgweb` ⭐ Recomendada

- **Tamaño:** ~65 MB comprimido (ahorro de ~105 MB)
- **Tecnología:** binario único en Go, sin dependencias Python/Flask
- **Arranque:** prácticamente instantáneo (< 1 segundo)
- **Interfaz:** web limpia, diseñada solo para PostgreSQL
  - Explorar tablas, columnas, índices
  - Ejecutar consultas SQL con resaltado de sintaxis
  - Exportar resultados a CSV/JSON
  - Historial de consultas
- **Limitaciones para el curso:** ninguna relevante
- **Limitaciones reales:** no tiene asistente visual para CREATE TABLE,
  no genera backups con interfaz gráfica (se puede hacer con `pg_dump` desde terminal)
- **Imagen Docker Hub:** `sosedoff/pgweb`

### Opción B: `adminer` (imagen oficial)

- **Tamaño:** ~10–19 MB comprimido (el más ligero)
- **Tecnología:** un único archivo PHP + Alpine + nginx
- **Arranque:** muy rápido
- **Interfaz:** funcional pero genérica (soporta MySQL, SQLite, etc.)
- **Limitaciones:** interfaz menos pulida, orientada a administración rápida
  más que a aprendizaje de SQL

### Opción C: mantener `dpage/pgadmin4` con tag fijo

- En lugar de `:latest` (que descarga siempre), usar una versión fija
  como `:8.14` para que Docker cachee la imagen correctamente.
- **Sin ahorro de tamaño**, pero elimina re-descargas innecesarias.
- Válido como parche mínimo si no se quiere cambiar herramienta.

---

## 4. Plan de cambios propuesto

### Fase 1 — Cambios seguros (bajo riesgo)

| Cambio | Archivo | Beneficio estimado |
|---|---|---|
| `postgres:16` → `postgres:15-alpine` | `docker-compose.yml` | −42 MB descarga, −130 MB disco, arranque más rápido |
| `dpage/pgadmin4:latest` → `sosedoff/pgweb` | `docker-compose.yml` | −105 MB descarga, arranque < 1s vs 10–30s |
| Agregar `Dockerfile` para workspace | nuevo archivo | Elimina 1–3 min de `apt-get install` en cada arranque |

### Fase 2 — Validación

- Verificar que el script `01-veterinaria.sql` funciona igual con Postgres 15 Alpine
- Verificar que los alumnos pueden conectar, ejecutar queries, ver tablas en pgweb
- Verificar que `psql` desde terminal sigue funcionando (viene pre-instalado en la imagen custom)

### Fase 3 — Documentación

- Actualizar `docs/REGISTRAR_SERVIDOR.md` (pgweb conecta por URL, no por registro manual)
- Crear `docs/PGWEB.md` con guía de uso básico para alumnos

---

## 5. Estimación de mejora

| Métrica | Antes | Después (estimado) |
|---|---|---|
| Descarga total de imágenes | ~723 MB | ~575 MB |
| Ahorro en descarga | — | ~150 MB (−21%) |
| Tiempo arranque pgAdmin/pgweb | 10–30 s | < 2 s |
| Tiempo `postCreateCommand` | 1–3 min | ~10 s (solo verificación) |
| Versión PostgreSQL | 16 (Debian) | 15 (Alpine) |

> El mayor impacto en tiempo de arranque es reemplazar pgAdmin 4 por pgweb.
> La imagen Alpine de Postgres suma un ahorro relevante en disco pero el
> tiempo de arranque de Postgres ya era bajo.

---

## 6. Riesgos y mitigaciones

| Riesgo | Probabilidad | Mitigación |
|---|---|---|
| Sintaxis SQL incompatible entre Pg 15 y 16 | Baja | Las diferencias son mínimas para SQL básico; curso no usa features de Pg 16 |
| Alumnos extrañan la UI de pgAdmin | Media | Documentar pgweb; interfaz es más simple = menos confusión para principiantes |
| pgweb no soporta proxy headers de Codespaces | Baja | pgweb tiene soporte de `--prefix` y `--bind` que solventa el proxy; hay referencias de uso en Codespaces |
| Cache de imagen no funciona con `latest` en pgAdmin | Alta (ya existe) | Al reemplazar por pgweb con tag fijo, se elimina este problema |

---

## 7. Alternativa mínima (si no se aprueba cambiar pgAdmin)

Si se prefiere mantener pgAdmin 4, aplicar solo estos dos cambios:

1. `postgres:16` → `postgres:15-alpine`
2. `dpage/pgadmin4:latest` → `dpage/pgadmin4:8.14` (tag fijo, mejor caché)
3. Crear `Dockerfile` del workspace con paquetes pre-instalados

Ahorro estimado: −42 MB descarga, −1 a 3 min en `postCreateCommand`.

---

## 8. Próximos pasos

- [ ] Aprobar o ajustar este plan
- [ ] Implementar Fase 1 en la rama `claude/adoring-keller-ziya8v`
- [ ] Probar en Codespaces (o local con `docker compose up`)
- [ ] Aprobar y fusionar a `main`

---

*Investigado y redactado el 2026-06-23. Fuentes: Docker Hub (tamaños de imágenes), github.com/sosedoff/pgweb, hub.docker.com/r/dpage/pgadmin4.*
