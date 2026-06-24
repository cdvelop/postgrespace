# Set 05 — Vistas, funciones y procedimientos 🧠

Ya sabes administrar PostgreSQL desde la terminal. Ahora das el siguiente salto:
**lógica que vive dentro del servidor**. En lugar de escribir la misma consulta
repetida en cada aplicación, la guardas una vez en la base de datos y la llamas
por su nombre.

> 🎯 El eje de este set: la base de datos no solo guarda — también procesa.

> **Requisito:** haber completado los Sets 01 al 04.
>
> 🛟 **Empieza ejecutando [`setup.sql`](setup.sql)** en pgAdmin sobre `veterinariadb`.

## Ruta de aprendizaje

| # | Ejercicio | Aprendes | Tú haces |
|---|---|---|---|
| 1 | **[Vistas](paso1.md)** | `CREATE VIEW`, consultar una vista como tabla | Vista de mascotas con tutor y vista de historial |
| 2 | **[Funciones](paso2.md)** | `CREATE FUNCTION`, `RETURNS`, `LANGUAGE sql` | Función que calcula el gasto total de un tutor |
| 3 | **[Procedimientos](paso3.md)** | `CREATE PROCEDURE`, `LANGUAGE plpgsql`, `CALL` | Procedimiento que actualiza datos en la base |

## ¿Cuál usar?

```
VIEW       → consulta guardada con nombre, sin parámetros
FUNCTION   → lógica con parámetros que devuelve un valor
PROCEDURE  → lógica con parámetros que modifica datos
```

## 📤 Entrega

Lee las instrucciones en **[Entrega](ENTREGA.md)**.
