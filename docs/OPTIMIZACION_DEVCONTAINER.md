# Optimización del Devcontainer Educativo

> **Estado:** Implementado — pendiente de prueba y fusión a `main`.
> **Rama de trabajo:** `optimize/devcontainer-arranque`

---

## 1. Problema original

Al abrir el Codespace o el devcontainer local, el entorno tardaba varios
minutos en estar listo. Los cuellos de botella identificados:

| Componente | Imagen original | Tamaño comprimido |
|---|---|---|
| Workspace | `mcr.microsoft.com/devcontainers/base:ubuntu` | ~400 MB |
| PostgreSQL | `postgres:16` | ~153 MB |
| pgAdmin 4 | `dpage/pgadmin4:latest` | ~170 MB |
| **Total descarga** | | **~723 MB** |

Además, el `postCreateCommand` ejecutaba `apt-get update && apt-get install ...`
**en cada creación de contenedor**, sumando 1–3 minutos adicionales.

---

## 2. Cuellos de botella y soluciones aplicadas

### 2.1 `postCreateCommand` con `apt-get install` → Dockerfile de workspace

**Problema:** cada vez que se creaba el contenedor, se descargaba e instalaba
desde apt: `postgresql-client`, `python3`, `python3-pip`, `python3-psycopg2`.
Esto sumaba 1–3 minutos en cada arranque.

**Solución aplicada:** se creó `.devcontainer/Dockerfile` que pre-instala
esos paquetes en la imagen del workspace. La capa queda cacheada en el registro
de Docker y no se repite en arranques subsiguientes.

```dockerfile
FROM mcr.microsoft.com/devcontainers/base:ubuntu
RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
       postgresql-client python3 python3-pip python3-psycopg2 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
```

**Ahorro:** ~1–3 minutos por arranque.

---

### 2.2 `postgres:16` (Debian) → `postgres:15-alpine`

**Problema:** se usaba la variante Debian por defecto, más pesada.

**Solución aplicada:** cambio a la variante Alpine.

| Imagen | Tamaño comprimido |
|---|---|
| `postgres:16` | 153 MB |
| `postgres:15-alpine` | 111 MB |

**Ahorro:** ~42 MB de descarga, ~130 MB en disco.

> PostgreSQL 15 es perfectamente válido para aprender SQL estándar y tiene
> soporte ICU (disponible desde Alpine+Pg15). La diferencia de versión no
> afecta ningún contenido del curso.

---

### 2.3 `dpage/pgadmin4:latest` → `dpage/pgadmin4:9.16` (tag fijo)

**Problema 1 — tag `:latest` impide el caché de Docker.**
Cada vez que Docker ve `:latest` verifica si hay una nueva versión. Si la hay,
re-descarga la imagen completa (~170 MB) aunque nada haya cambiado en el curso.

**Problema 2 — arranque lento de pgAdmin (15–30 s).**
pgAdmin está construido sobre Python/Flask y necesita inicializar su base de
datos interna, compilar assets y levantar el servidor WSGI en cada arranque.
Este tiempo es intrínseco a la arquitectura de pgAdmin y **no se puede eliminar**
sin cambiar de herramienta.

**Solución aplicada:** cambio de `:latest` a `9.16` (versión actual estable).
Esto permite que Docker reutilice capas cacheadas si la imagen ya fue descargada
previamente, evitando re-descargas innecesarias.

**Se mantuvo pgAdmin** (en lugar de sustituirlo) porque los alumnos deben
familiarizarse con la herramienta que encontrarán en entornos reales.

**Ahorro:** elimina re-descargas de 170 MB por actualizaciones de `:latest`.

---

### 2.4 `depends_on` en pgAdmin

**Mejora menor agregada:** pgAdmin ahora declara `depends_on: postgres`,
lo que hace que Docker Compose inicie los servicios en el orden correcto y
evita errores de conexión durante el arranque inicial.

---

## 3. Estado final del stack

| Componente | Antes | Después | Cambio |
|---|---|---|---|
| Workspace | imagen directa + `apt-get` en arranque | Dockerfile con paquetes pre-instalados | −1 a 3 min/arranque |
| PostgreSQL | `postgres:16` (153 MB) | `postgres:15-alpine` (111 MB) | −42 MB descarga |
| pgAdmin | `dpage/pgadmin4:latest` (sin caché) | `dpage/pgadmin4:9.16` (cacheado) | sin re-descargas |
| **Total descarga** | **~723 MB** | **~681 MB** | **−42 MB** |

---

## 4. Optimización pendiente de mayor impacto: Codespaces Prebuilds

La mejora más significativa que **no se ha implementado** aún es habilitar
los **Prebuilds de GitHub Codespaces**.

### Qué son

Un prebuild construye el devcontainer por adelantado (al hacer push a `main`
o en un schedule) y almacena la imagen lista en los servidores de GitHub.
Cuando un alumno abre el Codespace, **no hay que construir ni descargar nada**:
el entorno ya está listo.

**Reducción de tiempo:** de 3–5 minutos a menos de 30 segundos.

### Cómo habilitarlos

1. Ir a **Settings → Codespaces → Prebuilds** en el repositorio de GitHub.
2. Clic en **Set up prebuild**.
3. Seleccionar la rama `main` y el archivo de configuración `.devcontainer/devcontainer.json`.
4. Trigger recomendado: **"On every push"** a `main`.
5. Guardar.

### Consideración de costo

Los prebuilds consumen minutos de Actions de GitHub. Para un repositorio
educativo público o con plan gratuito, los minutos gratuitos suelen ser
suficientes. Se puede limitar a regiones específicas para reducir el consumo.

---

## 5. Otros cuellos de botella que NO se optimizaron (y por qué)

| Elemento | Por qué no se cambió |
|---|---|
| Imagen base del workspace (`devcontainers/base:ubuntu`) | Reemplazarla rompería la integración con VS Code Remote/Codespaces |
| Startup lento de pgAdmin (15–30 s) | Intrínseco a Python/Flask; eliminarlo requeriría cambiar de herramienta |
| Extensiones VS Code | Se instalan una vez y quedan cacheadas; impacto mínimo |

---

## 6. Cómo probar

```bash
# En local con Docker instalado
cd .devcontainer
docker compose up

# Verificar que pgAdmin abre en http://localhost:5050
# Credenciales: postgres@sql.dev / 1234
# El servidor "PostgreSQL Curso" debe aparecer pre-registrado
```

En Codespaces: abrir un nuevo Codespace desde la rama `optimize/devcontainer-arranque`.

---

*Investigado e implementado el 2026-06-23.*
