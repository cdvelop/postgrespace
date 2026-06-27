# Ejercicio 3 — CRUD y transacciones desde Python

> 🎯 **Qué vas a aprender:** a insertar, actualizar y eliminar datos desde Python
> usando `commit()`, y a agrupar varias operaciones en una sola **transacción**
> ("todo o nada") con `rollback()` cuando algo falla.

---

## Paso 3.0 — ¿Qué es una transacción?

Una **transacción** es un grupo de operaciones que la base de datos trata como una sola unidad:
o se ejecutan **todas** correctamente, o no se aplica **ninguna**.
Es una característica de los gestores relacionales que soportan **ACID** (PostgreSQL, MySQL, SQL Server, Oracle…):

| Letra | Propiedad | Qué garantiza |
|---|---|---|
| **A** | Atomicidad | Todo o nada: si una operación falla, se deshacen todas las anteriores |
| **C** | Consistencia | La base pasa de un estado válido a otro estado válido, nunca a uno corrupto |
| **I** | Aislamiento | Las transacciones en paralelo no se interfieren entre sí |
| **D** | Durabilidad | Una vez confirmada, la transacción sobrevive a caídas y reinicios |

En este ejercicio trabajas principalmente con **A** (atomicidad) y **D** (durabilidad).

El caso clásico: una transferencia bancaria.

```
1. Descontar $100 de la cuenta A
2. Sumar $100 a la cuenta B
```

Si ocurre un error entre la operación 1 y la 2 (fallo de red, luz cortada, bug),
¿qué pasa con los $100? Sin transacciones, se pierden en el aire — la cuenta A ya fue
descontada pero la B nunca recibió nada.

Con una transacción, si la operación 2 falla, la operación 1 se **deshace** automáticamente.
La base queda exactamente como estaba antes.

---

### Por qué existe `commit()`

Los cambios (INSERT, UPDATE, DELETE) no quedan guardados permanentemente hasta que
los confirmas con `COMMIT`. En psycopg2, tú controlas cuándo confirmar:

```python
conn.commit()   # confirma los cambios → quedan guardados en disco
conn.rollback() # cancela los cambios → vuelve al estado anterior
```

Si el script falla antes del `commit()`, PostgreSQL descarta los cambios automáticamente.
Eso es exactamente lo que quieres: o todo se guarda, o nada.

> 💡 A diferencia del Query Tool de pgAdmin, en Python **no puedes seleccionar un bloque
> y ejecutar solo ese trozo**. El script corre de arriba abajo completo. Por eso en este
> ejercicio cada concepto tiene **su propio script**, que puedes ejecutar y ver el resultado
> de forma independiente.

---

## Paso 3.1 — INSERT: crea `paso3_1.py`

```python
import psycopg2

conn = psycopg2.connect(
    host="postgres",      # Codespaces: "postgres" | Local: "localhost"
    database="veterinariadb",
    user="postgres",
    password="1234"
)
cursor = conn.cursor()

# INSERT con RETURNING para obtener el id generado por el SERIAL
cursor.execute("""
    INSERT INTO mascotas (nombre, especie, edad_meses, tutor_id)
    VALUES (%s, %s, %s, %s)
    RETURNING id_mascota;
""", ("Thor", "Perro", 6, 2))

id_nuevo = cursor.fetchone()[0]
conn.commit()

print(f"Mascota registrada con id: {id_nuevo}")

cursor.close()
conn.close()
```

Ejecuta:

```bash
python3 entregas/apellido_nombre/06-python-veterinaria/paso3_1.py
```

Resultado esperado:

```
Mascota registrada con id: 9
```

> 🔎 `RETURNING id_mascota` hace que PostgreSQL devuelva el id asignado por el `SERIAL`.
> Lo capturamos con `fetchone()[0]` antes del `commit()`.

---

## Paso 3.2 — CRUD completo: crea `paso3_2.py`

Ahora en un solo script encadenas las cuatro operaciones sobre la misma fila.
Las operaciones comparten `id_nuevo`, por eso van juntas:

```python
import psycopg2

conn = psycopg2.connect(
    host="postgres",
    database="veterinariadb",
    user="postgres",
    password="1234"
)
cursor = conn.cursor()

# --- INSERT ---
cursor.execute("""
    INSERT INTO mascotas (nombre, especie, edad_meses, tutor_id)
    VALUES (%s, %s, %s, %s)
    RETURNING id_mascota;
""", ("Thor", "Perro", 6, 2))
id_nuevo = cursor.fetchone()[0]
conn.commit()
print(f"INSERT → id: {id_nuevo}")

# --- UPDATE ---
cursor.execute("""
    UPDATE mascotas SET edad_meses = %s WHERE id_mascota = %s;
""", (8, id_nuevo))
conn.commit()
print(f"UPDATE → {cursor.rowcount} fila(s) modificada(s)")

# --- SELECT de verificación ---
cursor.execute("""
    SELECT id_mascota, nombre, especie, edad_meses
    FROM mascotas WHERE id_mascota = %s;
""", (id_nuevo,))
print(f"SELECT → {cursor.fetchone()}")

# --- DELETE ---
cursor.execute("DELETE FROM mascotas WHERE id_mascota = %s;", (id_nuevo,))
conn.commit()
print(f"DELETE → {cursor.rowcount} fila(s) eliminada(s)")

# Confirma que ya no existe
cursor.execute("SELECT COUNT(*) FROM mascotas WHERE id_mascota = %s;", (id_nuevo,))
print(f"Verificación final → {cursor.fetchone()[0]} fila(s) con ese id")

cursor.close()
conn.close()
```

> 🔎 `cursor.rowcount` indica cuántas filas afectó la última operación.

Ejecuta:

```bash
python3 entregas/apellido_nombre/06-python-veterinaria/paso3_2.py
```

Resultado esperado:

```
INSERT → id: 9
UPDATE → 1 fila(s) modificada(s)
SELECT → (9, 'Thor', 'Perro', 8)
DELETE → 1 fila(s) eliminada(s)
Verificación final → 0 fila(s) con ese id
```

---

## Paso 3.3 — Transacciones: crea `paso3_3.py`

Hasta aquí cada `commit()` confirmó **una sola** operación. Pero en la vida real muchas
operaciones van **juntas o no van**. Registrar una consulta es el caso típico:

1. Insertar la consulta en `consultas_veterinarias`.
2. Registrar el servicio aplicado en `consulta_servicios` (la tabla puente del Set 03).

Una consulta guardada **sin** su servicio —o al revés— deja la base inconsistente.
Las dos inserciones deben formar **una sola transacción**: si la segunda falla,
la primera tampoco debe quedar.

```python
import psycopg2

conn = psycopg2.connect(
    host="postgres",
    database="veterinariadb",
    user="postgres",
    password="1234"
)
cursor = conn.cursor()

try:
    # Operación 1: la consulta. RETURNING nos da el id para la operación 2.
    cursor.execute("""
        INSERT INTO consultas_veterinarias
               (fecha_consulta, motivo, costo, tutor_id, mascota_id, veterinario_id)
        VALUES (%s, %s, %s, %s, %s, %s)
        RETURNING id_consulta;
    """, ("2026-06-22", "Control anual", 25.00, 1, 1, 1))
    id_consulta = cursor.fetchone()[0]

    # Operación 2: el servicio aplicado, usando el id recién generado
    cursor.execute("""
        INSERT INTO consulta_servicios (consulta_id, servicio_id)
        VALUES (%s, %s);
    """, (id_consulta, 1))

    conn.commit()   # confirma AMBAS a la vez
    print(f"Consulta {id_consulta} y su servicio registrados juntos ✅")

except psycopg2.Error as e:
    conn.rollback()
    print(f"Error: {e} → no se guardó nada ❌")

cursor.close()
conn.close()
```

Ejecuta:

```bash
python3 entregas/apellido_nombre/06-python-veterinaria/paso3_3.py
```

Resultado esperado:

```
Consulta 10 y su servicio registrados juntos ✅
```

### Prueba el "todo o nada": cambia `servicio_id` a `9999`

Edita la operación 2 y pon un id que no existe:

```python
    cursor.execute("""
        INSERT INTO consulta_servicios (consulta_id, servicio_id)
        VALUES (%s, %s);
    """, (id_consulta, 9999))   # 9999 no existe → viola la FK
```

Ejecuta de nuevo. La operación 1 se ejecutó sin problema, pero la 2 viola la FK →
Python entra al `except` → `rollback()` **deshace las dos**.

```
Error: insert or update on table "consulta_servicios" violates foreign key constraint ... → no se guardó nada ❌
```

Verifica que la consulta tampoco quedó:

```sql
SELECT * FROM consultas_veterinarias WHERE motivo = 'Control anual';
-- 0 filas: el rollback borró también la operación 1
```

> 💡 Ese es el corazón de una transacción: no quedó una consulta "huérfana" sin su
> servicio. O se guardan las dos, o ninguna.

> 🔎 Atajo: `with conn:` confirma al salir del bloque sin error y hace `rollback()`
> automático si salta una excepción. Por debajo es la misma transacción.

---

## Paso 3.4 — 🧪 Tu turno: crea `paso3.py` (entregable final)

Encapsula las dos inserciones en una función `agendar_consulta(...)` que las haga en
**una sola transacción** y devuelva el id de la consulta (o `None` si algo falló).

<details>
<summary>👀 Ver solución</summary>

```python
import psycopg2

def agendar_consulta(conn, fecha, motivo, costo, tutor_id, mascota_id, vet_id, servicio_id):
    cursor = conn.cursor()
    try:
        cursor.execute("""
            INSERT INTO consultas_veterinarias
                   (fecha_consulta, motivo, costo, tutor_id, mascota_id, veterinario_id)
            VALUES (%s, %s, %s, %s, %s, %s)
            RETURNING id_consulta;
        """, (fecha, motivo, costo, tutor_id, mascota_id, vet_id))
        id_consulta = cursor.fetchone()[0]

        cursor.execute("""
            INSERT INTO consulta_servicios (consulta_id, servicio_id)
            VALUES (%s, %s);
        """, (id_consulta, servicio_id))

        conn.commit()
        return id_consulta
    except psycopg2.Error as e:
        conn.rollback()
        print(f"No se pudo agendar: {e}")
        return None
    finally:
        cursor.close()


conn = psycopg2.connect(
    host="postgres",      # Codespaces: "postgres" | Local: "localhost"
    database="veterinariadb",
    user="postgres",
    password="1234"
)

id_c = agendar_consulta(conn, "2026-06-22", "Vacuna anual", 30.00, 2, 4, 1, 2)
print(f"Nueva consulta id: {id_c}")

conn.close()
```

</details>

```bash
python3 entregas/apellido_nombre/06-python-veterinaria/paso3.py
```

> 🧹 Para dejar la base como estaba, vuelve a ejecutar
> [`../04-admin-psql/setup.sql`](../../04-admin-psql/setup.sql) desde psql con `\i`.

---

## ✅ Lo que lograste

| Operación | Python |
|---|---|
| INSERT | `cursor.execute("INSERT ...", (valores,))` + `conn.commit()` |
| RETURNING | `cursor.fetchone()[0]` después del INSERT |
| UPDATE | `cursor.execute("UPDATE ...", (valor, id))` + `conn.commit()` |
| DELETE | `cursor.execute("DELETE ...", (id,))` + `conn.commit()` |
| Filas afectadas | `cursor.rowcount` |
| Transacción atómica | varias operaciones + **un solo** `conn.commit()` |
| Error + rollback | `try/except psycopg2.Error` + `conn.rollback()` deshace **todo** el bloque |

> 📤 **Entrega:** `paso3.py` con la función `agendar_consulta` + `paso3.png` con
> captura del output del `rollback()` (el error de FK).
> Dónde ubicar los archivos: [Entrega](ENTREGA.md).

> 🎓 **Has completado el Set 06.** Ahora sabes conectar Python a PostgreSQL,
> hacer operaciones reales y agruparlas en transacciones atómicas.
> En el [Set 07](../07-proyecto-propio/README.md) diseñas y construyes
> **tu propia base de datos** desde cero.
