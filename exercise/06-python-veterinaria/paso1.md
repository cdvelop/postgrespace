# Ejercicio 1 — Configuración y primera consulta

> 🎯 **Qué vas a aprender:** a tener Python funcionando en tu entorno, instalar
> `psycopg2` y ejecutar tu primera consulta contra la veterinaria desde un script.

---

## Paso 1.0 — ¿Tienes Python disponible?

Antes de escribir código, verifica que Python está instalado en tu entorno.

### Si usas Codespaces

Python ya está incluido — no necesitas instalar nada. Verifica en el terminal:

```bash
python3 --version
```

Verás algo como `Python 3.11.x`. ✅

### Si usas instalación local en Windows

Es posible que Python no esté instalado. Ábrelo en el terminal de VS Code:

```bash
python --version
```

Si aparece un error o abre la tienda de Microsoft, Python no está instalado.

> 🎬 Sigue este video para instalarlo correctamente en Windows:
> [Instalar Python en Windows](https://youtu.be/gqwFz56XSxc?si=y1zdaNP45qNzBEEE)
>
> Puntos importantes del video:
> - Marca **"Add Python to PATH"** durante la instalación (sin eso, los comandos no funcionan)
> - Reinicia VS Code después de instalar

Después de instalar, verifica de nuevo:

```bash
python --version
```

> 💡 En Windows el comando puede ser `python` (sin el `3`). En Codespaces es `python3`.
> En los pasos siguientes usa el que funcione en tu entorno.

---

## Paso 1.1 — ¿Qué es psycopg2?

`psycopg2` es la biblioteca que hace de puente entre Python y PostgreSQL.
Tu script Python le pasa SQL a `psycopg2`, y `psycopg2` lo ejecuta en el servidor
y te devuelve los resultados como listas de Python.

```
script.py  →  psycopg2  →  PostgreSQL  →  resultados  →  script.py
```

---

## Paso 1.2 — Instala psycopg2

### Si usas Codespaces

Ya está instalado automáticamente al arrancar el entorno. Verifica:

```bash
python3 -c "import psycopg2; print(psycopg2.__version__)"
```

Verás algo como `2.9.x`. ✅

### Si usas instalación local

Instálalo desde el terminal de VS Code:

```bash
pip install psycopg2-binary
```

Verifica:

```bash
python -c "import psycopg2; print(psycopg2.__version__)"
```

> 💡 `psycopg2-binary` incluye todo en un solo paquete, sin dependencias externas.
> Es la forma recomendada para aprendizaje.

---

## Paso 1.3 — Prepara la veterinaria

Asegúrate de que `veterinariadb` está activa y con datos. En pgAdmin ejecuta:

```sql
SELECT COUNT(*) FROM mascotas;
-- Debe dar 8
```

Si da error o 0, ejecuta primero [`../04-admin-psql/setup.sql`](../04-admin-psql/setup.sql).

---

## Paso 1.4 — Tu primer script: conectar y listar

Crea la carpeta de entrega y el archivo (reemplaza con tu apellido y nombre):

```
entregas/apellido_nombre/06-python-veterinaria/paso1.py
```

Escribe este código:

```python
import psycopg2

# Datos de conexión
conn = psycopg2.connect(
    host="localhost",
    database="veterinariadb",
    user="postgres",
    password="1234"
)

# Cursor: el objeto que ejecuta SQL
cursor = conn.cursor()

# Ejecuta una consulta
cursor.execute("SELECT nombre, especie FROM mascotas ORDER BY nombre;")

# Obtén todos los resultados
mascotas = cursor.fetchall()

# Muéstralos
print("=== Mascotas registradas ===")
for mascota in mascotas:
    nombre, especie = mascota
    print(f"  {nombre} ({especie})")

print(f"\nTotal: {len(mascotas)} mascotas")

# Cierra la conexión
cursor.close()
conn.close()
```

Ejecuta el script desde el terminal:

```bash
# Codespaces
python3 entregas/apellido_nombre/06-python-veterinaria/paso1.py

# Local Windows
python entregas/apellido_nombre/06-python-veterinaria/paso1.py
```

Resultado esperado:

```
=== Mascotas registradas ===
  Bobby (Perro)
  Canela (Conejo)
  Coco (Perro)
  ...

Total: 8 mascotas
```

✅

---

## Paso 1.5 — Entiende el flujo

| Línea | Qué hace |
|---|---|
| `psycopg2.connect(...)` | Abre la conexión al servidor PostgreSQL |
| `conn.cursor()` | Crea el cursor (el "ejecutor" de SQL) |
| `cursor.execute("SELECT ...")` | Envía el SQL al servidor |
| `cursor.fetchall()` | Trae todos los resultados como lista de tuplas |
| `cursor.close()` / `conn.close()` | Libera los recursos de la conexión |

> 🔎 `fetchall()` devuelve una lista de **tuplas**. Cada tupla es una fila:
> `('Bobby', 'Perro')`. Por eso desempaquetamos con `nombre, especie = mascota`.

---

## Paso 1.6 — 🧪 Tu turno: cuenta por especie

Modifica el script para que también imprima cuántas mascotas hay de cada especie,
ordenado de más a menos.

<details>
<summary>👀 Ver solución</summary>

```python
cursor.execute("""
    SELECT especie, COUNT(*) AS total
    FROM mascotas
    GROUP BY especie
    ORDER BY total DESC;
""")

print("\n=== Por especie ===")
for especie, total in cursor.fetchall():
    print(f"  {especie}: {total}")
```

</details>

---

## ✅ Lo que lograste

* Python instalado y verificado en tu entorno.
* `psycopg2` instalado y conectado a PostgreSQL.
* Tu primer `SELECT` desde Python con `fetchall()`.
* El flujo completo: `connect → cursor → execute → fetch → close`.

> 📤 **Entrega:** `paso1.py` en tu carpeta de entrega + `paso1.png` con captura
> del output en la terminal mostrando las mascotas y el conteo por especie.
> Dónde ubicar los archivos: [Entrega](ENTREGA.md).

➡️ **Siguiente:** en el [Ejercicio 2](paso2.md) aprenderás qué es SQL Injection,
cómo funciona el ataque y cómo prevenirlo.
