# Ejercicio 1 — Backup y restauración desde la terminal

> 🎯 **Qué vas a aprender:** a hacer un **backup completo** de tu base con `pg_dump` y a
> **restaurarla** con `psql`, todo desde la terminal, sin tocar pgAdmin. Esto es lo que ocurre
> en servidores reales donde no hay interfaz gráfica.

Hasta ahora sabes hacer backups desde pgAdmin (guardar en `/data/`). Pero hay dos limitaciones:
pgAdmin **no restaura** fácilmente desde un archivo `.sql`, y en un servidor real no habrá GUI.
`pg_dump` y `psql` resuelven los dos problemas.

---

## Paso 1.0 — Prepara tu punto de partida (¡no te lo saltes!)

Ejecuta [`setup.sql`](setup.sql) en el Query Tool sobre `veterinariadb`. Luego verifica:

```sql
SELECT (SELECT COUNT(*) FROM tutores)         AS tutores,
       (SELECT COUNT(*) FROM mascotas)        AS mascotas,
       (SELECT COUNT(*) FROM veterinarios)    AS veterinarios,
       (SELECT COUNT(*) FROM consultas_veterinarias) AS consultas,
       (SELECT COUNT(*) FROM servicios)       AS servicios,
       (SELECT COUNT(*) FROM consulta_servicios)     AS relaciones;
```

Debe dar **4, 8, 3, 9, 6, 15**. ✅

---

## Paso 1.1 — Abre la terminal del contenedor

### Si usas Codespaces (VS Code)

Abre el **Terminal** integrado de VS Code (menú **Terminal → New Terminal**).
Estás dentro del contenedor donde ya vive PostgreSQL: `pg_dump` y `psql` están disponibles
sin instalar nada.

Confirma que psql responde:

```bash
psql --version
```

Verás algo como `psql (PostgreSQL) 16.x`. ✅

### Si usas Dev Container local

El terminal de VS Code ya está dentro del contenedor. El comando es el mismo.

---

## Paso 1.2 — Genera un backup con `pg_dump`

`pg_dump` exporta **una base de datos completa** como instrucciones SQL. El resultado es un
archivo de texto que, ejecutado en orden, recrea exactamente lo que tenías.

```bash
pg_dump -U postgres -d veterinariadb > /data/backups/veterinaria_set03.sql
```

| Parte | Qué significa |
|---|---|
| `-U postgres` | usuario de PostgreSQL |
| `-d veterinariadb` | base de datos a exportar |
| `> /data/backups/veterinaria_set03.sql` | redirige la salida al archivo |

> 💡 La carpeta `/data/` está montada como volumen compartido: el archivo aparecerá
> automáticamente en `postgrespace/data/backups/` en tu VS Code.

Ábrelo desde VS Code y obsérva su contenido: verás los `CREATE TABLE`, los `INSERT` y las
restricciones, todo en orden. Ese archivo **es** tu base de datos portátil.

---

## Paso 1.3 — Restaura en una base nueva

La restauración tiene dos pasos: crear la base destino y volcar el archivo.

**1. Crea la base destino:**

```bash
psql -U postgres -c "CREATE DATABASE veterinaria_respaldo;"
```

El flag `-c` ejecuta un comando SQL directamente desde la terminal, sin entrar al prompt.

**2. Restaura el backup:**

```bash
psql -U postgres -d veterinaria_respaldo < /data/backups/veterinaria_set03.sql
```

Verás una lista de mensajes `SET`, `CREATE TABLE`, `INSERT`, etc.: PostgreSQL está ejecutando
tu archivo línea por línea. Si termina sin `ERROR`, la restauración fue exitosa. ✅

---

## Paso 1.4 — Verifica la restauración

Conéctate a la base restaurada y comprueba que los datos llegaron intactos:

```bash
psql -U postgres -d veterinaria_respaldo -c "
SELECT (SELECT COUNT(*) FROM tutores)         AS tutores,
       (SELECT COUNT(*) FROM mascotas)        AS mascotas,
       (SELECT COUNT(*) FROM veterinarios)    AS veterinarios,
       (SELECT COUNT(*) FROM consultas_veterinarias) AS consultas;
"
```

Debe dar **4, 8, 3, 9**. ✅ Tu base está restaurada y funcionando.

---

## Paso 1.5 — 🧪 El ciclo completo: rompe y repara

Para entender el valor del backup, simula un accidente: borra la tabla `mascotas` de la
base original y restáurala desde el backup.

```bash
# "Accidente": borra la tabla
psql -U postgres -d veterinariadb -c "DROP TABLE mascotas CASCADE;"

# Verifica que desapareció
psql -U postgres -d veterinariadb -c "\dt"

# Restaura solo desde veterinaria_respaldo
psql -U postgres -d veterinariadb -c "
CREATE TABLE mascotas AS SELECT * FROM veterinaria_respaldo.mascotas;
"
```

> 🔎 En producción real harías `pg_restore` o recrearías la DB completa. Aquí el ejercicio
> es comprobar que **tienes los datos salvados** y puedes recuperarlos. Eso es lo que vale.

Después del experimento, ejecuta `setup.sql` nuevamente para volver al estado limpio del Set 04.

---

## ✅ Lo que lograste

* **`pg_dump`** → exportar una base completa como SQL portátil.
* **`psql -c`** → ejecutar comandos SQL desde la terminal sin entrar al prompt.
* **`psql < archivo.sql`** → restaurar una base completa desde un archivo.
* Entendiste por qué los backups existen: un archivo SQL **es** tu base de datos.

> 📤 **Entrega:** guarda en `paso1.txt` el output de la terminal al ejecutar los comandos
> de los pasos 1.2 y 1.4 (copia y pega el texto). Adjunta una captura donde se vea la
> verificación del paso 1.4 mostrando los 4 conteos correctos.
> Dónde ubicar los archivos: [Entrega](ENTREGA.md).

➡️ **Siguiente:** en el [Ejercicio 2](paso2.md) crearás tu primera **función almacenada**
para encapsular consultas que usas con frecuencia.
