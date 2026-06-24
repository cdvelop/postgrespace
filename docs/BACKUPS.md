# Backups en PostgreSQL con pgAdmin

## El problema

Cuando intentas hacer un backup desde pgAdmin usando la interfaz web, el navegador no puede guardar archivos directamente en tu máquina. Esto ocurre porque **pgAdmin está dentro de un [contenedor Docker](DOCKER.md)** y solo ve el sistema de archivos interno del contenedor, no tu computadora.

## La solución

Ya está configurada en este proyecto. Se creó una **carpeta compartida llamada `data/`** que funciona como un puente entre tu máquina y los contenedores.

### Cómo usarla

**1. Crea un backup desde pgAdmin:**

- Click derecho sobre tu base de datos
- Selecciona **Backup...**
- En el campo **Filename** escribe: `/data/mi_respaldo.sql`
- Haz clic en **Backup**

**2. Busca el archivo:**

El archivo aparecerá automáticamente en la carpeta `data/` de tu proyecto, visible desde VS Code.

```
postgrespace/
├── data/
│   └── mi_respaldo.sql   ← Tu backup aquí
└── .devcontainer/
```

### ¿Qué es la carpeta `data/`?

Es un volumen compartido entre tu computadora y los contenedores Docker. Sirve para:
- Guardar backups
- Importar archivos SQL
- Exportar datos
- Compartir archivos entre servicios

Puedes crear subcarpetas organizadas según necesites:
```
data/
├── backups/
├── imports/
├── exports/
└── datasets/
```

---

## Restaurar un backup desde la terminal

pgAdmin no tiene una opción directa para restaurar desde un archivo `.sql`. La forma más
confiable es usar `psql` desde el terminal de VS Code.

**1. Crea la base de datos destino** (si no existe):

```bash
psql -U postgres -c "CREATE DATABASE nombre_restaurado;"
```

**2. Restaura el archivo:**

```bash
psql -U postgres -d nombre_restaurado < /data/mi_respaldo.sql
```

Verás una lista de mensajes `SET`, `CREATE TABLE`, `INSERT`... Si termina sin `ERROR`,
la restauración fue exitosa.

**3. Verifica:**

```bash
psql -U postgres -d nombre_restaurado -c "\dt"
```

> 💡 ¿Quieres practicar esto con un caso concreto? El
> [Set 04 — Ejercicio 1](../exercise/04-procedimientos-psql/paso1.md) tiene un paso a paso
> completo de backup y restauración sobre la base de la veterinaria.

---

## Notas adicionales

### `.gitkeep`
Si notas un archivo llamado `.gitkeep` dentro de la carpeta `data/`, no es un error. Es un marcador que Git usa para version la carpeta. [Aprende más sobre `.gitkeep`](GITKEEP.md).

### Dev Containers
La configuración de `data/` ya está incluida en `.devcontainer/docker-compose.yml`. Si hiciste cambios manualmente al archivo, recuerda reconstruir el Dev Container en VS Code. [¿Qué es Dev Containers?](DEVCONTAINER.md)