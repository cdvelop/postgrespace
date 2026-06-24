# Ejercicio 3 — CRUD y transacciones desde Python

> 🎯 **Qué vas a aprender:** a insertar, actualizar y eliminar datos desde Python
> usando `commit()`, y a agrupar varias operaciones en una sola **transacción**
> ("todo o nada") con `rollback()` cuando algo falla.

---

## Paso 3.0 — Por qué existe `commit()`

PostgreSQL trabaja con **transacciones**: los cambios (INSERT, UPDATE, DELETE) no
quedan guardados permanentemente hasta que los confirmas con `COMMIT`.

En psycopg2, cada conexión empieza en modo transacción. Tú controlas cuándo confirmar:

```python
conn.commit()   # confirma los cambios → quedan guardados
conn.rollback() # cancela los cambios → vuelve al estado anterior
```

Si el script falla antes del `commit()`, PostgreSQL descarta los cambios automáticamente.
Eso es exactamente lo que quieres: o todo se guarda, o nada.

---

## Paso 3.1 — INSERT: registra una mascota nueva

Crea `paso3.py`:

```python
import psycopg2

conn = psycopg2.connect(
    host="postgres",      # Codespaces: "postgres" | Local: "localhost"
    database="veterinariadb",
    user="postgres",
    password="1234"
)
cursor = conn.cursor()

# INSERT con parámetros y RETURNING para obtener el id generado
cursor.execute("""
    INSERT INTO mascotas (nombre, especie, edad_meses, tutor_id)
    VALUES (%s, %s, %s, %s)
    RETURNING id_mascota;
""", ("Thor", "Perro", 6, 2))

id_nuevo = cursor.fetchone()[0]
conn.commit()

print(f"Mascota registrada con id: {id_nuevo}")
```

> 🔎 `RETURNING id_mascota` hace que PostgreSQL devuelva el id asignado por el
> `SERIAL`. Lo capturamos con `fetchone()[0]` antes del `commit()`.

---

## Paso 3.2 — UPDATE: actualiza un dato

Agrega esto al script (antes del `close()`):

```python
# Actualiza la edad de la mascota recién creada
cursor.execute("""
    UPDATE mascotas SET edad_meses = %s WHERE id_mascota = %s;
""", (8, id_nuevo))

filas_afectadas = cursor.rowcount
conn.commit()

print(f"Actualización: {filas_afectadas} fila(s) modificada(s)")
```

> 🔎 `cursor.rowcount` indica cuántas filas afectó la última operación.
> Es útil para verificar que el UPDATE sí encontró la fila.

---

## Paso 3.3 — SELECT de verificación

Antes de borrar, verifica que los cambios están en la base:

```python
cursor.execute("""
    SELECT id_mascota, nombre, especie, edad_meses FROM mascotas WHERE id_mascota = %s;
""", (id_nuevo,))

mascota = cursor.fetchone()
print(f"\nVerificación: {mascota}")
```

---

## Paso 3.4 — DELETE: elimina el registro de prueba

```python
# Elimina la mascota de prueba
cursor.execute("DELETE FROM mascotas WHERE id_mascota = %s;", (id_nuevo,))
conn.commit()

print(f"Mascota id {id_nuevo} eliminada")

# Confirma que ya no existe
cursor.execute("SELECT COUNT(*) FROM mascotas WHERE id_mascota = %s;", (id_nuevo,))
conteo = cursor.fetchone()[0]
print(f"Filas con ese id después del DELETE: {conteo}")  # debe ser 0

cursor.close()
conn.close()
```

Ejecuta el script completo:

```bash
python3 entregas/apellido_nombre/06-python-veterinaria/paso3.py
```

Resultado esperado:

```
Mascota registrada con id: 9
Actualización: 1 fila(s) modificada(s)

Verificación: (9, 'Thor', 'Perro', 8)
Mascota id 9 eliminada
Filas con ese id después del DELETE: 0
```

---

## Paso 3.5 — Transacciones: dos operaciones, todo o nada

Hasta aquí cada `commit()` confirmó **una sola** operación. Pero en la vida real muchas
operaciones van **juntas o no van**. Registrar una consulta es el caso típico:

1. Insertar la consulta en `consultas_veterinarias`.
2. Registrar el servicio aplicado en `consulta_servicios` (la tabla puente del Set 03).

Una consulta guardada **sin** su servicio —o al revés— deja la base inconsistente.
Las dos inserciones deben formar **una sola transacción**: si la segunda falla,
la primera tampoco debe quedar.

### Versión correcta: un solo commit para las dos

```python
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
    print(f"Consulta {id_consulta} y su servicio registrados juntos")

except psycopg2.Error as e:
    conn.rollback()
    print(f"Error: {e} → no se guardó nada")
```

### Versión que falla: comprueba el "todo o nada"

Cambia el `servicio_id` de la operación 2 por uno que **no existe** (ej. `9999`):

```python
    cursor.execute("""
        INSERT INTO consulta_servicios (consulta_id, servicio_id)
        VALUES (%s, %s);
    """, (id_consulta, 9999))   # 9999 no existe → falla la FK
```

La operación 1 (la consulta) se ejecutó sin problema, pero la operación 2 viola la
FK → Python entra al `except` → `rollback()` **deshace las dos**.

Verifica en pgAdmin que la consulta **tampoco** quedó:

```sql
SELECT * FROM consultas_veterinarias WHERE motivo = 'Control anual';
-- 0 filas: el rollback borró también la operación 1
```

> 💡 Ese es el corazón de una transacción: no quedó una consulta "huérfana" sin su
> servicio. O se guardan las dos, o ninguna.

> 🔎 Atajo: `with conn:` confirma al salir del bloque sin error y hace `rollback()`
> automático si salta una excepción. Por debajo es la misma transacción.

---

## Paso 3.6 — 🧪 Tu turno: función que agenda consulta + servicio

Encapsula las dos inserciones en una función `agendar_consulta(...)` que las haga en
**una sola transacción** y devuelva el id de la consulta (o `None` si algo falló).

<details>
<summary>👀 Ver solución</summary>

```python
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

        conn.commit()           # las dos operaciones, juntas
        return id_consulta
    except psycopg2.Error as e:
        conn.rollback()         # si una falla, se deshacen las dos
        print(f"No se pudo agendar: {e}")
        return None
    finally:
        cursor.close()

# Uso:
conn = psycopg2.connect(host="postgres",  # Codespaces: "postgres" | Local: "localhost"
                        database="veterinariadb", user="postgres", password="1234")
id_c = agendar_consulta(conn, "2026-06-22", "Vacuna anual", 30.00, 2, 4, 1, 2)
print(f"Nueva consulta id: {id_c}")
conn.close()
```

</details>

> 🧹 Para dejar la base como estaba, vuelve a ejecutar
> [`../04-admin-psql/setup.sql`](../../04-admin-psql/setup.sql) en pgAdmin.

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

> 📤 **Entrega:** `paso3.py` con el CRUD (INSERT + UPDATE + SELECT + DELETE) y la
> transacción de dos operaciones (consulta + servicio) con su `rollback()` +
> `paso3.png` con captura del output.
> Dónde ubicar los archivos: [Entrega](ENTREGA.md).

> 🎓 **Has completado el Set 06.** Ahora sabes conectar Python a PostgreSQL,
> hacer operaciones reales y agruparlas en transacciones atómicas.
> En el [Set 07](../07-proyecto-propio/README.md) diseñas y construyes
> **tu propia base de datos** desde cero.
