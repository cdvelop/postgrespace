# 📤 Entrega del Set 04 — Procedimientos almacenados y psql

Para cada ejercicio entregarás entre **2 y 3 archivos** según el tipo de paso.

---

## Qué entregar por ejercicio

| Ejercicio | Archivos a entregar | Contenido clave |
|---|---|---|
| **Paso 1** | `paso1.txt` + `paso1.png` | Output de terminal (pg_dump + verificación) y captura de los 4 conteos correctos |
| **Paso 2** | `paso2.sql` + `paso2.png` | Las 3 funciones (`costo_total_tutor`, `resumen_tutor`, `mascotas_sin_consulta`) y captura de `resumen_tutor(1)` |
| **Paso 3** | `paso3.sql` + `paso3.txt` + `paso3.png` | Procedimiento completo (con ampliación 3.5), output de psql de los comandos 3.4, y captura de las dos tablas con filas insertadas |

> 💡 **Importante:** tus scripts deben **ejecutarse sin error** sobre una base recién preparada
> con `setup.sql`. Antes de entregar, corre `setup.sql` y luego `paso2.sql` y `paso3.sql`
> en orden, y confirma que todo funciona.

---

## Cómo guardar el output de terminal (`.txt`)

1. Ejecuta los comandos en el terminal de VS Code.
2. Selecciona todo el texto relevante (comandos + resultados).
3. Copia y pégalo en un archivo de texto: **File → New File** en VS Code, pega y guarda
   como `paso1.txt` o `paso3.txt`.

---

## Dónde y cómo se organizan tus entregas

```
entregas/
└── apellido_nombre/
    ├── 01-veterinaria/
    ├── 02-consultas-analisis/
    ├── 03-modelo-crece/
    └── 04-procedimientos-psql/     ← este set
        ├── paso1.txt
        ├── paso1.png
        ├── paso2.sql
        ├── paso2.png
        ├── paso3.sql
        ├── paso3.txt
        └── paso3.png
```

Reglas de nombre de carpeta: **todo en minúscula, sin tildes, sin `ñ`, sin espacios**.
Ejemplo: María Núñez → `nunez_maria`.

---

## Cómo guardar tu `.sql` y la captura

1. En el **Query Tool**, con tu código escrito, usa **File → Save As** y guarda como `pasoN.sql`.
2. Toma una captura donde se vea **tu SQL** y el **resultado**, y guárdala como `pasoN.png`.

---

## Subir tus entregas

Cuando tengas tus archivos en `entregas/apellido_nombre/04-procedimientos-psql/`, haz
**commit** en tu **fork** y abre un **Pull Request** hacia el repositorio del curso.

> ¿No recuerdas cómo? Mira el video tutorial del
> [Set 01](../01-veterinaria/ENTREGA.md#subir-tus-entregas). El proceso es idéntico.
