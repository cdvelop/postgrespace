# Set 07 — Proyecto propio 🎓

Has completado los Sets 01 al 06: CRUD, JOINs, análisis, modelos N:M, funciones,
procedimientos y backup. Este set es la **demostración de que lo dominas**: diseñas y
construyes una base de datos de un dominio que tú eliges, desde cero.

> 🎯 La idea de este set: ya no hay veterinaria guiada. Tú defines el problema, diseñas
> las tablas, las relaciones, los datos de prueba, las consultas de análisis y al menos un
> procedimiento o función. El resultado debe funcionar de forma autónoma al arrancar el
> Dev Container.

> **Requisito:** haber completado los Sets 01 al 06.

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

---

## Cómo se entrega

Todo va en **un solo archivo**:

```
.devcontainer/initdb/apellido_nombre_dominio.sql
```

Ejemplo: `nunez_maria_biblioteca.sql`

> 💡 Si PostgreSQL ya está en marcha, usa **`Rebuild Container`** desde VS Code para forzar
> la inicialización desde cero.

El archivo tiene cuatro secciones en orden:

```sql
-- =============================================
-- PROYECTO: Nombre del proyecto
-- AUTOR: Tu nombre
-- DOMINIO: Biblioteca / Hospital / Gimnasio…
-- DESCRIPCIÓN: Qué representa cada tabla y
--              por qué están relacionadas así.
-- =============================================

-- 1. Base de datos
-- Nombre: apellido_nombre_dominio_db
-- Ejemplo: nunez_maria_biblioteca_db
CREATE DATABASE apellido_nombre_dominio_db;
\connect apellido_nombre_dominio_db

-- 2. Tablas (primero las independientes, luego las que tienen FK)
CREATE TABLE ...

-- 3. Datos de prueba
INSERT INTO ...

-- =============================================
-- CONSULTAS DE ANÁLISIS
-- Ejecuta estas consultas en pgAdmin o psql
-- para verificar que los datos son correctos.
-- =============================================

-- Consulta 1: [pregunta de negocio que responde]
SELECT ...;

-- Consulta 2: [pregunta de negocio que responde]
SELECT ...;

-- Consulta 3: [pregunta de negocio que responde]
SELECT ...;
```

---

## Referencia: cómo es un script de inicialización

El script de la veterinaria (`veterinaria.sql` en la carpeta `initdb`) es un ejemplo
de estructura que puedes tomar como referencia. El tuyo sigue el mismo patrón.

---

## ⚠️ Antes de entregar: verifica que funciona

1. En VS Code: **Ctrl+Shift+P → Dev Containers: Rebuild Container**
2. Conéctate a tu base de datos en pgAdmin o psql
3. Ejecuta las 3 consultas de análisis y confirma que devuelven resultados

Si algo falla durante el Rebuild, revisa los logs del contenedor para identificar el error.

---

## 📤 Checklist de entrega

- [ ] `.devcontainer/initdb/apellido_nombre_dominio.sql` existe y se ejecuta sin errores
- [ ] El archivo tiene comentario de cabecera con nombre, autor y descripción
- [ ] La base de datos tiene mínimo 5 tablas
- [ ] Hay al menos 1 relación N:M con tabla puente
- [ ] Hay datos de prueba en todas las tablas
- [ ] Hay mínimo 3 consultas de análisis al final del archivo
- [ ] Todo está en tu fork con un **Pull Request** al repositorio del curso
