# 📤 Entrega del Set 04 — psql, usuarios y backup

## Qué entregar por ejercicio

| Ejercicio | Archivos | Contenido clave |
|---|---|---|
| **Paso 1** | `paso1.txt` + `paso1.png` | Output de `\conninfo`, `\dt`, `\du` y las dos consultas; captura de la segunda consulta |
| **Paso 2** | `paso2.sql` + `paso2.png` | Comandos `CREATE USER`, `GRANT`, `REVOKE`; captura del `ERROR: permission denied` |
| **Paso 3** | `paso3_backup.sql` + `paso3.txt` + `paso3.png` | Backup generado con `pg_dump`; output de DROP + restauración; captura del dato restaurado |

## Dónde van tus archivos

```
entregas/
└── apellido_nombre/
    └── 04-admin-psql/
        ├── paso1.txt
        ├── paso1.png
        ├── paso2.sql
        ├── paso2.png
        ├── paso3_backup.sql
        ├── paso3.txt
        └── paso3.png
```

Reglas: **todo en minúscula, sin tildes, sin `ñ`, sin espacios**.
Ejemplo: María Núñez → `nunez_maria`.

## Cómo guardar el output de terminal (`.txt`)

Ejecuta los comandos en el terminal de VS Code, selecciona el texto relevante
(comandos + resultados) y pégalo en un archivo nuevo.

## Subir tus entregas

Haz **commit** en tu **fork** y abre un **Pull Request** hacia el repositorio del curso.
