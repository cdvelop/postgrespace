# Ejercicios de PostgreSQL 🐘

Catálogo de los sets de ejercicios del curso. Cada **set** es una ruta guiada, de lo más
simple a lo más completo, sobre un caso práctico. Hazlos en orden.

> **Requisito:** tener el laboratorio abierto y pgAdmin conectado.
> Si aún no llegas ahí, sigue el [README principal](../README.md).

## Sets disponibles

| # | Set | De qué trata | Aprendes |
|---|---|---|---|
| 01 | **[Veterinaria](01-veterinaria/README.md)** | Tutores, mascotas y consultas | CRUD básico, CREATE TABLE, claves foráneas y JOIN |
| 02 | **[Consultas y análisis](02-consultas-analisis/README.md)** | Le haces preguntas a la base de la veterinaria | `WHERE` avanzado, `ORDER BY`, agregaciones, `GROUP BY`/`HAVING`, `LEFT JOIN` y subconsultas |
| 03 | **[Haciendo crecer el modelo](03-modelo-crece/README.md)** | Amplías la veterinaria con veterinarios y servicios | `ALTER TABLE`, `CHECK`/`DEFAULT`/`UNIQUE`, relación muchos-a-muchos con tabla puente y JOIN de varias tablas |
| 04 | **[Procedimientos almacenados y psql](04-procedimientos-psql/README.md)** | Lógica que vive en el servidor y control desde la terminal | `pg_dump`, restauración, `CREATE FUNCTION`, `CREATE PROCEDURE`, `LANGUAGE plpgsql`, `psql` sin GUI |
| 05 | **[Proyecto propio](05-proyecto-propio/README.md)** | Diseñas y construyes una base de datos desde cero | Diseño relacional autónomo, script de inicialización en `.devcontainer/initdb/`, documentación |

## Cómo se organizan las entregas

Cada set indica qué entregar y cómo. La estructura general es **una carpeta por alumno**, y
dentro **una subcarpeta por set**:

```
entregas/
└── apellido_nombre/
    ├── 01-veterinaria/
    │   ├── paso1.sql
    │   ├── paso1.png
    │   └── ...
    └── 02-…/
```

Así tus entregas de distintos sets **nunca chocan**. El detalle de cada set está en su propio
archivo de **Entrega**.
