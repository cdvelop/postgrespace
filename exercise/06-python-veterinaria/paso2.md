# Ejercicio 2 — SQL Injection y consultas seguras

> 🎯 **Qué vas a aprender:** qué es SQL Injection, por qué es peligroso y cómo
> prevenirlo usando parámetros con `%s`. Lo vas a comprobar tú mismo ejecutando
> el ataque antes de ver la solución.

---

## Paso 2.0 — El escenario

Imagina que construyes un sistema de búsqueda de tutores. El usuario escribe un nombre
y el programa lo busca en la base de datos. Parece simple.

Crea el archivo `paso2_vulnerable.py` en tu carpeta de entrega:

```python
import psycopg2

conn = psycopg2.connect(
    host="localhost",
    database="veterinariadb",
    user="postgres",
    password="1234"
)
cursor = conn.cursor()

print("=== Buscador de tutores ===")
nombre = input("Nombre del tutor: ")

# Construye la consulta pegando el input directamente
query = f"SELECT id_tutor, nombre, telefono FROM tutores WHERE nombre = '{nombre}'"

print(f"\nConsulta que se ejecuta:\n  {query}\n")

cursor.execute(query)
resultados = cursor.fetchall()

if resultados:
    for fila in resultados:
        print(f"  id={fila[0]}  nombre={fila[1]}  tel={fila[2]}")
else:
    print("Ningún tutor encontrado.")

cursor.close()
conn.close()
```

Ejecuta el script:

```bash
python3 entregas/apellido_nombre/06-python-veterinaria/paso2_vulnerable.py
```

---

## Paso 2.1 — Uso normal (funciona bien)

Cuando ejecutas el script, escribe un nombre real:

```
Nombre del tutor: Carlos Mendoza
```

Resultado:

```
Consulta que se ejecuta:
  SELECT id_tutor, nombre, telefono FROM tutores WHERE nombre = 'Carlos Mendoza'

  id=1  nombre=Carlos Mendoza  tel=555-1234
```

Todo bien. Ahora viene el problema.

---

## Paso 2.2 — El ataque: filtra sin saber la contraseña

Ejecuta el script de nuevo. Esta vez escribe esto exactamente como nombre:

```
' OR '1'='1' --
```

Resultado:

```
Consulta que se ejecuta:
  SELECT id_tutor, nombre, telefono FROM tutores WHERE nombre = '' OR '1'='1' --'

  id=1  nombre=Carlos Mendoza  tel=555-1234
  id=2  nombre=Ana López       tel=555-5678
  id=3  nombre=Luis García     tel=555-9012
  id=4  nombre=Sofía Torres    tel=555-3456
```

**Devolvió todos los tutores.** El filtro `WHERE nombre = '...'` fue ignorado porque
`'1'='1'` siempre es verdadero. El `--` comenta el resto de la consulta.

En un sistema de login real, esto significa entrar **sin conocer la contraseña**.

---

## Paso 2.3 — El ataque destructivo: modifica datos

Ejecuta el script una vez más y escribe:

```
'; UPDATE tutores SET telefono='HACKEADO' WHERE '1'='1
```

Resultado:

```
Consulta que se ejecuta:
  SELECT ... WHERE nombre = ''; UPDATE tutores SET telefono='HACKEADO' WHERE '1'='1'
```

Verifica el daño en pgAdmin:

```sql
SELECT nombre, telefono FROM tutores;
```

Todos los teléfonos dicen `HACKEADO`. El atacante modificó datos sin ningún permiso
especial — solo escribió texto en un campo de entrada.

> 🛠️ Restaura los datos ejecutando [`setup.sql`](../../../04-admin-psql/setup.sql)
> en pgAdmin antes de continuar.

---

## Paso 2.4 — Por qué ocurre esto

El problema es la **concatenación directa**: el programa trata el input del usuario
como parte del código SQL. El usuario puede escribir SQL y el servidor lo ejecuta.

```python
# Lo que el programador pensó:
f"WHERE nombre = '{nombre}'"
#              ↑ aquí va el nombre

# Lo que el atacante escribió:
f"WHERE nombre = '' OR '1'='1' --'"
#              ↑ cerró el string y agregó su propio SQL
```

---

## Paso 2.5 — La solución: parámetros con `%s`

Crea `paso2.py` (la versión segura):

```python
import psycopg2

conn = psycopg2.connect(
    host="localhost",
    database="veterinariadb",
    user="postgres",
    password="1234"
)
cursor = conn.cursor()

print("=== Buscador de tutores (versión segura) ===")
nombre = input("Nombre del tutor: ")

# %s le dice a psycopg2: "este valor viene de afuera, trátalo como dato, no como SQL"
cursor.execute(
    "SELECT id_tutor, nombre, telefono FROM tutores WHERE nombre = %s",
    (nombre,)
)

resultados = cursor.fetchall()

if resultados:
    for fila in resultados:
        print(f"  id={fila[0]}  nombre={fila[1]}  tel={fila[2]}")
else:
    print("Ningún tutor encontrado.")

cursor.close()
conn.close()
```

Ejecuta y escribe el mismo ataque:

```
Nombre del tutor: ' OR '1'='1' --
```

Resultado:

```
Ningún tutor encontrado.
```

psycopg2 envió `' OR '1'='1' --` como un valor de texto literal — no como SQL.
PostgreSQL lo buscó como nombre de tutor, no lo encontró, y devolvió cero filas.
**El ataque no funcionó.**

> 💡 El segundo argumento de `cursor.execute()` siempre es una **tupla**.
> Aunque sea un solo valor, lleva la coma: `(nombre,)` — no `(nombre)`.

---

## Paso 2.6 — `fetchone()`: cuando esperas una sola fila

Hasta ahora usaste `fetchall()`. Cuando la consulta devuelve exactamente una fila
(buscar por ID, por ejemplo), usa `fetchone()`:

```python
conn = psycopg2.connect(
    host="localhost", database="veterinariadb",
    user="postgres", password="1234"
)
cursor = conn.cursor()

tutor_id = 1

cursor.execute("""
    SELECT t.nombre,
           COUNT(cv.id_consulta)          AS consultas,
           COALESCE(SUM(cv.costo), 0)     AS total_gastado
    FROM tutores t
    LEFT JOIN consultas_veterinarias cv ON cv.tutor_id = t.id_tutor
    WHERE t.id_tutor = %s
    GROUP BY t.nombre;
""", (tutor_id,))

fila = cursor.fetchone()   # una sola tupla, o None si no hay resultado

if fila:
    nombre, consultas, total = fila
    print(f"Tutor:     {nombre}")
    print(f"Consultas: {consultas}")
    print(f"Total:     ${total:.2f}")
else:
    print("Tutor no encontrado")

cursor.close()
conn.close()
```

> 🔎 `fetchone()` devuelve una tupla o `None`. Por eso verificamos `if fila:`
> antes de desempaquetar — si el id no existe, no hay fila que desempaquetar.

---

## Paso 2.7 — 🧪 Tu turno: historial completo de un tutor

Escribe una función que reciba un `tutor_id` y muestre el historial completo de
sus consultas: mascota, fecha, motivo, costo y veterinario. Usa el JOIN de 4 tablas
que ya conoces del Set 02.

<details>
<summary>👀 Ver solución</summary>

```python
cursor.execute("""
    SELECT m.nombre        AS mascota,
           cv.fecha_consulta,
           cv.motivo,
           cv.costo,
           v.nombre        AS veterinario
    FROM consultas_veterinarias cv
    JOIN mascotas     m ON m.id_mascota      = cv.mascota_id
    JOIN veterinarios v ON v.id_veterinario  = cv.veterinario_id
    WHERE cv.tutor_id = %s
    ORDER BY cv.fecha_consulta;
""", (tutor_id,))

print(f"\n=== Historial tutor {tutor_id} ===")
for mascota, fecha, motivo, costo, vet in cursor.fetchall():
    print(f"  {fecha}  {mascota:<10}  {motivo:<25}  ${costo}  ({vet})")
```

</details>

---

## ✅ Lo que lograste

* **SQL Injection** → qué es, cómo se ejecuta y qué daño puede causar.
* **`%s` con tupla** → psycopg2 trata el valor como dato, nunca como SQL.
* **`fetchone()`** → una sola fila o `None`; siempre verificar antes de desempaquetar.
* **`fetchall()`** → lista de tuplas; lista vacía si no hay resultados.

> 📤 **Entrega:** `paso2.py` (versión segura con la búsqueda de tutor y el resumen
> con `fetchone()`) + `paso2.png` con captura del output de ambas consultas.
> El archivo `paso2_vulnerable.py` **no** se entrega — era solo para el experimento.
> Dónde ubicar los archivos: [Entrega](ENTREGA.md).

➡️ **Siguiente:** en el [Ejercicio 3](paso3.md) harás `INSERT`, `UPDATE` y `DELETE`
desde Python — el CRUD completo.
