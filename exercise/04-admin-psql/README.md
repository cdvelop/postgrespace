# Set 04 — psql, usuarios y backup 🖥️

En los Sets anteriores usaste pgAdmin para todo. En este set aprendes a controlar
PostgreSQL **desde la terminal**, a proteger los datos con **usuarios y permisos**, y
a hacer **backups** que te permiten recuperarte de cualquier error.

> 🎯 El eje de este set: administrar la base de datos sin interfaz gráfica.

> **Requisito:** haber completado los Sets 01, 02 y 03.
>
> 🛟 **Empieza ejecutando [`setup.sql`](setup.sql)** en pgAdmin sobre `veterinariadb`.

## Ruta de aprendizaje

| # | Ejercicio | Aprendes | Tú haces |
|---|---|---|---|
| 1 | **[Conoce psql](paso1.md)** | `\l`, `\dt`, `\du`, `\d`, `\c`, `\q` | Conectarte, navegar y hacer consultas desde la terminal |
| 2 | **[Usuarios y permisos](paso2.md)** | `CREATE USER`, `GRANT`, `REVOKE` | Usuario de solo lectura y usuario con permisos parciales |
| 3 | **[Backup y restauración](paso3.md)** | `pg_dump`, `psql < archivo`, `DROP DATABASE` | Hacer backup, borrar la base y restaurarla |

## 📤 Entrega

Lee las instrucciones en **[Entrega](ENTREGA.md)**.
