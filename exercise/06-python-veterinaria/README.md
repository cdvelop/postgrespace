# Set 06 — Python conectado a PostgreSQL 🐍

Has construido una base de datos funcional y aprendido a administrarla con psql.
Ahora das el siguiente paso: **conectar un programa Python a la veterinaria** y
hacer operaciones de base de datos desde código.

> 🎯 La idea de este set: ver la base de datos desde "afuera". Las mismas tablas que
> consultabas en pgAdmin, ahora las consulta y modifica un programa Python.

> **Requisito:** haber completado los Sets 01 al 04.

---

## Ruta de aprendizaje

| # | Ejercicio | Aprendes | Tú haces |
|---|---|---|---|
| 1 | **[Conexión y primera consulta](paso1.md)** | `psycopg2`, variables de entorno, `cursor.execute()` | Conectarte a la veterinaria y listar mascotas |
| 2 | **[Consultas con parámetros](paso2.md)** | Parámetros seguros (`%s`), `fetchone()`, `fetchall()` | Buscar mascotas por especie y obtener el historial de un tutor |
| 3 | **[CRUD y transacciones](paso3.md)** | `INSERT`, `UPDATE`, `DELETE`, `commit()`/`rollback()`, transacción atómica | CRUD de una mascota y registrar consulta + servicio como una sola transacción "todo o nada" |

---

## Cómo trabaja Python con PostgreSQL

```
Tu script Python
      │
      │  psycopg2 (biblioteca de conexión)
      │
      ▼
PostgreSQL (veterinariadb)
      │
      ├── tutores
      ├── mascotas
      ├── veterinarios
      └── ...
```

`psycopg2` es la biblioteca estándar para conectar Python a PostgreSQL.
Traduce tus instrucciones Python en comandos SQL que el servidor entiende.

---

## 📤 Entrega

Lee las instrucciones en **[Entrega de los ejercicios](ENTREGA.md)**.
