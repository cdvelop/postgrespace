# 📤 Entrega del Set 03 — Haciendo crecer el modelo

Para cada ejercicio entregarás **2 archivos**: tu **script `.sql`** (lo que escribiste) y
**una captura** del resultado clave.

---

## Qué entregar por ejercicio

| Ejercicio | Archivo `.sql` (tu código) | Captura `.png` (resultado clave) |
|---|---|---|
| **Paso 1** | `CREATE TABLE veterinarios` + tus `ALTER TABLE` + los `UPDATE` | `SELECT id_consulta, motivo, veterinario_id FROM consultas_veterinarias;` con el veterinario asignado |
| **Paso 2** | `CREATE TABLE servicios` + `CREATE TABLE consulta_servicios` + los `INSERT` de parejas | El **error de clave duplicada** del paso 2.4 |
| **Paso 3** | Tus consultas, incluyendo **ingresos por servicio** (3.2) y el **JOIN de 5 tablas** (3.4) | El resultado del **reporte de las 5 tablas** (3.4) |

> 💡 **Importante:** tus scripts deben **ejecutarse sin error** sobre una base recién preparada
> con `setup.sql`. Antes de entregar, corre `setup.sql` y luego `paso1.sql`, `paso2.sql` y
> `paso3.sql` en orden, y confirma que todo funciona.

---

## Dónde y cómo se organizan tus entregas

Tienes **una sola carpeta propia**: `entregas/apellido_nombre/`. Dentro, cada **set** tiene su
subcarpeta (este es el set `03-modelo-crece`). Así nunca chocan entre sí.

```
entregas/
└── apellido_nombre/              ← tu carpeta (la única que tocas)
    ├── 01-veterinaria/
    ├── 02-consultas-analisis/
    └── 03-modelo-crece/          ← este set
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
- Dentro de cada set, los archivos se llaman simplemente `paso1`, `paso2`, `paso3`.

---

## Cómo guardar tu `.sql` y la captura

1. En el **Query Tool**, con tu código escrito, usa **File → Save As** y guarda como `pasoN.sql`.
2. Toma una captura donde se vea **tu SQL** y el **resultado**, y guárdala como `pasoN.png`.

---

## Subir tus entregas

Cuando tengas tus archivos en `entregas/apellido_nombre/03-modelo-crece/`, haz **commit** en tu
**fork** y abre un **Pull Request** hacia el repositorio del curso.

> ¿No recuerdas cómo? Mira el video tutorial del
> [Set 01](../01-veterinaria/ENTREGA.md#subir-tus-entregas). El proceso es idéntico.
