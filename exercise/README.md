# Ejercicios de PostgreSQL 🐘

Catálogo de los sets de ejercicios del curso. Cada **set** es una ruta guiada, de lo más
simple a lo más completo, sobre un caso práctico. Hazlos en orden.

> **Requisito:** tener el laboratorio abierto y pgAdmin conectado.
> Si aún no llegas ahí, sigue el [README principal](../README.md).

## Sets disponibles

| # | Set | De qué trata | Aprendes |
|---|---|---|---|
| 01 | **[Veterinaria](01-veterinaria/README.md)** | Tutores, mascotas y consultas | CRUD básico, `CREATE TABLE`, claves foráneas y `JOIN` |
| 02 | **[Consultas y análisis](02-consultas-analisis/README.md)** | Le haces preguntas a la base de la veterinaria | `WHERE` avanzado, `ORDER BY`, agregaciones, `GROUP BY`/`HAVING`, `LEFT JOIN`, subconsultas |
| 03 | **[Haciendo crecer el modelo](03-modelo-crece/README.md)** | Amplías la veterinaria con veterinarios y servicios | `ALTER TABLE`, `CHECK`/`DEFAULT`/`UNIQUE`, relación N:M con tabla puente, JOIN de varias tablas |
| 04 | **[psql, usuarios y backup](04-admin-psql/README.md)** | Administras la base desde la terminal | `psql`, `CREATE USER`, `GRANT`, `REVOKE`, `pg_dump`, restauración |
| 05 | **[Vistas, funciones y procedimientos](05-logica-servidor/README.md)** | Lógica que vive en el servidor | `CREATE VIEW`, `CREATE FUNCTION`, `CREATE PROCEDURE`, `LANGUAGE plpgsql`, `CALL` |
| 06 | **[Python conectado a PostgreSQL](06-python-veterinaria/README.md)** | Consultas y CRUD desde un script Python | `psycopg2`, `cursor.execute()`, `fetchall()`, transacciones atómicas (`commit()`/`rollback()`), parámetros seguros |
| 07 | **[Proyecto propio](07-proyecto-propio/README.md)** | Diseñas y construyes una base de datos desde cero | Diseño relacional autónomo, script de inicialización, documentación |

## Cómo se organizan las entregas

```
entregas/
└── apellido_nombre/
    ├── 01-veterinaria/
    ├── 02-consultas-analisis/
    ├── 03-modelo-crece/
    ├── 04-admin-psql/
    ├── 05-logica-servidor/
    ├── 06-python-veterinaria/
    └── 07-proyecto-propio/
```

Así tus entregas de distintos sets **nunca chocan**. El detalle de cada set está en su propio
archivo de **Entrega**.
