# Set 05 — Proyecto propio 🎓

Has completado los Sets 01 al 04: CRUD, JOINs, análisis, modelos N:M, funciones,
procedimientos y backup. Este set es la **demostración de que lo dominas**: diseñas y
construyes una base de datos de un dominio que tú eliges, desde cero.

> 🎯 La idea de este set: ya no hay veterinaria guiada. Tú defines el problema, diseñas
> las tablas, las relaciones, los datos de prueba, las consultas de análisis y al menos un
> procedimiento o función. El resultado debe funcionar de forma autónoma al arrancar el
> Dev Container.

> **Requisito:** haber completado los Sets 01 al 04.

---

## Lo que vas a entregar

Un sistema de base de datos **completo y funcional** para un dominio de tu elección.
Ejemplos de dominio: biblioteca, hospital, gimnasio, restaurante, tienda, colegio,
videoteca, aerolínea, etc.

**Requisitos mínimos:**

| Requisito | Mínimo | Por qué |
|---|---|---|
| Tablas | 5 tablas con relaciones reales | Demostrar diseño relacional, no tablas aisladas |
| Relaciones | Al menos 1 relación N:M con tabla puente | Aprendida en el Set 03 |
| Datos de prueba | Mínimo 4-5 filas por tabla | Suficientes para que las consultas muestren resultados |
| Consultas de análisis | Mínimo 3 consultas útiles para el dominio | Demostrar que los datos sirven para responder preguntas reales |
| Función o procedimiento | Al menos 1 | Aprendido en el Set 04 |
| Script de inicialización | 1 archivo `.sql` en `.devcontainer/initdb/` | El Dev Container lo ejecuta automáticamente |

---

## Cómo se entrega

Tu proyecto se entrega en **dos lugares**:

### 1. Script de inicialización (el más importante)

Copia tu script en:

```
.devcontainer/initdb/02-[apellido_nombre].sql
```

Ejemplo: `02-nunez_maria.sql`

> 💡 El prefijo `02-` garantiza que tu script se ejecuta **después** del `01-veterinaria.sql`.
> Si PostgreSQL ya está en marcha cuando abres el codespace, el script no se re-ejecuta
> automáticamente: usa **`Rebuild Container`** desde VS Code para forzar la inicialización.

El script debe:
- Crear su propia base de datos (no uses `veterinariadb`)
- Crear todas las tablas con sus restricciones
- Insertar los datos de prueba
- Crear la función o procedimiento
- Ejecutarse completo sin errores

```sql
-- Ejemplo de estructura mínima
CREATE DATABASE midominiodb;
\connect midominiodb

CREATE TABLE ...
INSERT INTO ...
CREATE FUNCTION ...  -- o CREATE PROCEDURE
```

### 2. Carpeta de entrega

```
entregas/
└── apellido_nombre/
    └── 05-proyecto-propio/
        ├── README.md         ← descripción del proyecto (ver abajo)
        ├── initdb.sql        ← copia de tu script (el mismo que va en .devcontainer/initdb/)
        └── consultas.sql     ← tus 3+ consultas de análisis
```

---

## El README.md de tu proyecto

Dentro de `entregas/apellido_nombre/05-proyecto-propio/` incluye un `README.md` con:

1. **Nombre del proyecto** y dominio elegido
2. **Descripción de las tablas**: qué representa cada una
3. **Diagrama de relaciones** (en texto o mermaid, como los de los ejercicios anteriores)
4. **Las 3 preguntas de negocio** que responden tus consultas de análisis
5. **Descripción de tu función o procedimiento**: qué hace y por qué es útil

> 💡 Este README es la diferencia entre "entregar código" y "explicar un diseño". En el mundo
> real, un sistema de base de datos que nadie entiende no sirve de nada.

---

## Referencia: cómo es un script de inicialización

Puedes revisar cómo está construido el script de la veterinaria del curso:

```
.devcontainer/initdb/01-veterinaria.sql
```

Tu script sigue el mismo patrón:
1. `CREATE DATABASE nombre;`
2. `\connect nombre`
3. `CREATE TABLE` (en orden: primero las independientes, luego las que tienen FK)
4. `INSERT INTO` con datos de prueba
5. Funciones o procedimientos al final

---

## ⚠️ Antes de entregar: verifica que funciona

1. En VS Code: **Ctrl+Shift+P → Dev Containers: Rebuild Container**
2. Conéctate a tu base de datos en pgAdmin
3. Ejecuta `consultas.sql` y confirma que las 3 consultas devuelven resultados
4. Llama tu función o procedimiento y confirma que funciona

Si algo falla durante el Rebuild, revisa los logs del contenedor para identificar el error en tu script.

---

## 📤 Checklist de entrega

- [ ] `.devcontainer/initdb/02-[apellido_nombre].sql` existe y se ejecuta sin errores
- [ ] La base de datos tiene mínimo 5 tablas
- [ ] Hay al menos 1 relación N:M con tabla puente
- [ ] Hay datos de prueba en todas las tablas
- [ ] `entregas/apellido_nombre/05-proyecto-propio/README.md` está completo
- [ ] `entregas/apellido_nombre/05-proyecto-propio/initdb.sql` es una copia del script
- [ ] `entregas/apellido_nombre/05-proyecto-propio/consultas.sql` tiene 3+ consultas
- [ ] Todo está en tu fork con un **Pull Request** al repositorio del curso
