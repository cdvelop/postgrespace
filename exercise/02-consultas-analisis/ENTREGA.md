# 📤 Entrega del Set 02 — Consultas y análisis

Para cada ejercicio entregarás **2 archivos**: tu **script `.sql`** (las consultas que
escribiste) y **una captura** del resultado clave. Sigue estas reglas y se corregirá rápido y justo.

---

## Qué entregar por ejercicio

| Ejercicio | Archivo `.sql` (tu código) | Captura `.png` (resultado clave) |
|---|---|---|
| **Paso 1** | **Tus** 4 consultas (`AND`/`OR`, `BETWEEN`/`IN`, `LIKE`, `ORDER BY ... LIMIT`) — no incluyas `setup.sql` | El **top 3 de consultas más caras** (paso 1.5) |
| **Paso 2** | Tus resúmenes, incluyendo un `GROUP BY` y un `HAVING` | **Cuánto facturó cada tutor** (paso 2.3) |
| **Paso 3** | Una consulta con `LEFT JOIN`, una con `JOIN` + `GROUP BY` y una con **subconsulta** | El **reporte de gasto por tutor** (paso 3.3) |

> 💡 **Importante:** las consultas deben **ejecutarse sin error** sobre tu base. Antes de
> entregar, corre tu `.sql` completo de arriba a abajo y confirma que todo funciona.

---

## Dónde y cómo se organizan tus entregas

Tienes **una sola carpeta propia**: `entregas/apellido_nombre/`. Dentro, cada **set de
ejercicios** tiene su subcarpeta (este es el set `02-consultas-analisis`). Así, cada set vive
en su espacio y **nunca chocan** entre sí.

```
entregas/
└── apellido_nombre/                 ← tu carpeta (la única que tocas)
    ├── 01-veterinaria/              ← set anterior
    └── 02-consultas-analisis/       ← este set
        ├── paso1.sql
        ├── paso1.png
        ├── paso2.sql
        ├── paso2.png
        ├── paso3.sql
        └── paso3.png
```

Reglas:

- **Tu carpeta** se llama `apellido_nombre`: **todo en minúscula, sin tildes, sin `ñ` y sin
  espacios.** Ejemplo: María Núñez → `nunez_maria`.
- Dentro de cada set, los archivos se llaman simplemente `paso1`, `paso2`, `paso3`
  (la ruta ya dice de quién y de qué set son; no repitas tu nombre en cada archivo).

---

## Cómo guardar tu `.sql` desde pgAdmin

1. En el **Query Tool**, con tu código escrito, abre el menú **File** (o el icono de guardar 💾).
2. Elige **Save As** y guarda el archivo como `pasoN.sql` en tu carpeta del set.

## Cómo tomar la captura

- Asegúrate de que se vea **tu SQL** y el **resultado** (la grilla de abajo o el mensaje).
- Guarda la imagen como `pasoN.png` junto a su `.sql`.

---

## Subir tus entregas

Una vez tengas tus archivos en `entregas/apellido_nombre/02-consultas-analisis/`, haz **commit**
en tu **fork** y abre un **Pull Request** hacia el repositorio del curso.

> ¿No sabes aún qué es un Pull Request? Mira el video tutorial del
> [Set 01](../01-veterinaria/ENTREGA.md#subir-tus-entregas). El proceso es idéntico.
