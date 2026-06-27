# Ejercicio 1 — Conoce psql: la terminal de PostgreSQL

> 🎯 **Qué vas a aprender:** qué es `psql`, cómo conectarte a una base de datos desde
> la terminal y cómo navegar con los comandos esenciales. Sin instalar nada extra —
> ya está en tu entorno.

> 🎬 **Antes de continuar:** mira el video
> [Aprende a usar psql paso a paso](https://youtu.be/DmZkPTZXjNw?si=tCaUEoCgQ_IRHIqL)
> (10 min, en español). Cubre exactamente los comandos de este ejercicio.
> Regresa aquí cuando termines.

---

## Paso 1.1 — ¿Qué es psql y para qué sirve?

**pgAdmin** es la interfaz gráfica con menús y clics. Útil para explorar, pero
**no existe en un servidor real**: en producción solo hay terminal.

**`psql`** es la terminal oficial de PostgreSQL. Con ella puedes:
- Crear bases de datos y tablas
- Insertar, consultar y modificar datos
- Gestionar usuarios y permisos
- Ejecutar scripts SQL completos

Todo lo que haces con el ratón en pgAdmin, puedes hacerlo en psql escribiendo comandos.
A partir de este set, **psql es tu herramienta principal**.

---

## Paso 1.2 — Abre psql

### Si usas Codespaces

Abre el **Terminal** de VS Code: menú **Terminal → New Terminal**.
Estás dentro del contenedor donde ya vive PostgreSQL. Conéctate a la veterinaria:

```bash
psql -U postgres -d veterinariadb
```

### Si usas instalación local en Windows

Abre el programa **SQL Shell (psql)** desde el menú de inicio. Pulsa Enter en cada
campo para aceptar los valores por defecto y escribe la contraseña cuando la pida.

<details>
<summary>📺 Video: psql desde Windows</summary>

[psql en Windows paso a paso](https://youtu.be/zMc2xeO1F_k?si=rk5lQ-cArkW4IJD5)

</details>

---

El prompt cambia a:

```
veterinariadb=#
```

Eso significa que estás dentro de `veterinariadb` como usuario `postgres`. ✅

> 💡 Si el prompt termina en `->` o `veterinariadb-#`, psql está esperando más texto
> — normalmente falta el `;`. Escríbelo y pulsa Enter.

---

## Paso 1.3 — Prepara el punto de partida con psql

Vamos a cargar el script [`setup.sql`](setup.sql) directamente desde psql usando el
meta-comando `\i` (de *input*). Necesitas indicar la **ruta completa** al archivo.

### En Codespaces

```
\i /workspaces/postgrespace/exercise/04-admin-psql/setup.sql
```

### En instalación local (Windows)

Usa la ruta donde clonaste el repositorio, con barras normales `/`:

```
\i C:/ruta/a/postgrespace/exercise/04-admin-psql/setup.sql
```

> 💡 **¿Cómo sé la ruta exacta?** En el Terminal escribe `pwd` (Linux/Mac) o `cd`
> (Windows) para ver en qué carpeta estás. También puedes arrastrar el archivo desde
> el explorador de VS Code al terminal para que complete la ruta automáticamente.

Verás que psql ejecuta cada instrucción y al final aparece `INSERT 0 15` y similares.

Verifica que los datos cargaron correctamente con esta consulta:

```sql
SELECT (SELECT COUNT(*) FROM tutores)                 AS tutores,
       (SELECT COUNT(*) FROM mascotas)                AS mascotas,
       (SELECT COUNT(*) FROM veterinarios)            AS veterinarios,
       (SELECT COUNT(*) FROM consultas_veterinarias)  AS consultas,
       (SELECT COUNT(*) FROM servicios)               AS servicios,
       (SELECT COUNT(*) FROM consulta_servicios)      AS relaciones;
```

Debe dar **4, 8, 3, 9, 6, 15**. ✅

> **¿Prefieres usar pgAdmin?** Puedes abrir `setup.sql` en el Query Tool de pgAdmin y
> ejecutarlo allí. El resultado es idéntico — pero aprender a hacerlo con `\i` en psql
> es parte del objetivo de este set.

---

## Paso 1.4 — Comandos de navegación

Los comandos que empiezan con `\` son **meta-comandos** de psql (no son SQL).
No llevan `;` al final.

**¿En qué servidor estoy conectado?**

```
\conninfo
```

Muestra el servidor, la base de datos activa y el usuario.

**¿Qué bases de datos existen?**

```
\l
```

Verás `veterinariadb`, `postgres` y otras del sistema.

**¿Qué tablas tiene esta base?**

```
\dt
```

Aparecen las 6 tablas de la veterinaria.

**¿Cómo está estructurada una tabla?**

```
\d mascotas
```

Muestra columnas, tipos y restricciones de `mascotas`.

**¿Qué usuarios existen en el servidor?**

```
\du
```

Ahora mismo solo hay uno: `postgres` (superusuario con todos los permisos).

---

## Paso 1.5 — Tu primera consulta desde psql

Escribe SQL directamente en el prompt, igual que en pgAdmin:

```sql
SELECT nombre, especie FROM mascotas ORDER BY nombre;
```

Verás los resultados en tabla de texto. Prueba una más:

```sql
SELECT t.nombre AS tutor, COUNT(m.id_mascota) AS mascotas
FROM tutores t
LEFT JOIN mascotas m ON m.tutor_id = t.id_tutor
GROUP BY t.nombre
ORDER BY mascotas DESC;
```

> 🔎 Las consultas largas puedes escribirlas en varias líneas — psql espera hasta que
> pongas el `;` final.

---

## Paso 1.6 — Cambia de base de datos y sal

Conéctate a otra base sin salir de psql:

```
\c postgres
```

El prompt cambia a `postgres=#`. Vuelve a la veterinaria:

```
\c veterinariadb
```

Para salir de psql:

```
\q
```

Vuelves al terminal normal.

---

## ✅ Lo que lograste

| Meta-comando | Qué hace |
|---|---|
| `\i ruta/archivo.sql` | Ejecuta un script SQL desde un archivo |
| `\conninfo` | Muestra conexión activa |
| `\l` | Lista bases de datos |
| `\dt` | Lista tablas |
| `\d tabla` | Estructura de una tabla |
| `\du` | Lista usuarios |
| `\c nombre` | Cambia de base de datos |
| `\q` | Sale de psql |

> 📤 **Entrega:** guarda en `paso1.txt` el output del terminal con los resultados de
> los meta-comandos `\conninfo`, `\dt` y `\du`, y las dos consultas del paso 1.5.
> Adjunta una captura (`paso1.png`) donde se vea el resultado de la segunda consulta.
> Dónde ubicar los archivos: [Entrega](ENTREGA.md).

➡️ **Siguiente:** en el [Ejercicio 2](paso2.md) crearás usuarios y permisos desde psql.
