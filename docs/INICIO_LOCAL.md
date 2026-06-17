# Iniciar en local (sin Codespaces)

Guía para correr el laboratorio en **tu propia máquina**, instalando PostgreSQL y pgAdmin.
Útil si prefieres no usar Codespaces o quieres practicar sin conexión.

> 💡 **Diferencias con Codespaces:** en local **tú** instalas PostgreSQL y pgAdmin, el servidor
> se conecta en `localhost` (no en `postgres`), y la base `veterinariadb` con la tabla `tutores`
> **no aparece sola**: la creas una vez en el paso 3. De ahí en adelante, los ejercicios son
> idénticos. No necesitas descargar nada: el código lo copias directamente desde GitHub.

---

## 1. Instalar PostgreSQL y pgAdmin (Windows 10 / 11)

Sigue este video paso a paso para descargar, instalar y configurar **PostgreSQL** y **pgAdmin**:

> 🎥 **[Instalar PostgreSQL y pgAdmin en Windows](https://youtu.be/eq-MandG9dU)**

Mientras instalas, ten en cuenta:

* **Componentes:** deja los que vienen marcados por defecto (*PostgreSQL Server* y *pgAdmin 4*
  son los que usarás).
* **Contraseña del superusuario `postgres`:** anótala bien, la usarás siempre para conectarte.
* **Puerto:** deja el predeterminado **5432**.

> 🐧🍎 ¿Linux o macOS? Instala PostgreSQL y pgAdmin desde el
> [sitio oficial de PostgreSQL](https://www.postgresql.org/download/). El resto de la guía es igual.

---

## 2. Conectar pgAdmin a tu PostgreSQL local

1. Abre **pgAdmin**.
2. En el panel izquierdo, clic derecho en **Servers → Register → Server…**.
3. Pestaña **General → Name:** `PostgreSQL Local` (el nombre que quieras).
4. Pestaña **Connection:**

   ```text
   Host name/address: localhost
   Port:              5432
   Username:          postgres
   Password:          (la que pusiste al instalar)
   ```
5. Marca **Save password** y presiona **Save**.

> ⚠️ A diferencia de Codespaces, aquí el host es **`localhost`**, porque PostgreSQL corre en tu
> propia máquina.

---

## 3. Crear la base `veterinariadb` con su primera tabla

En Codespaces esto se hace solo. En local lo haces **una vez**:

1. En pgAdmin, clic derecho en **Databases → Create → Database…**, nómbrala `veterinariadb` y
   guarda.
2. Selecciona la base **`veterinariadb`** y abre el **Query Tool**.
3. Abre en GitHub el archivo
   [`.devcontainer/initdb/01-veterinaria.sql`](../.devcontainer/initdb/01-veterinaria.sql) y
   **copia desde `CREATE TABLE tutores ...` hasta el final**. Pégalo en el Query Tool y ejecútalo
   (▶ o `F5`).
   **No copies** las dos primeras líneas (`CREATE DATABASE veterinariadb;` y `\connect
   veterinariadb`): la base ya la creaste en el punto 1.

> ✅ Copiamos el código **desde el archivo del proyecto**, no lo reescribimos aquí: así hay un
> **único origen de verdad** y, si el script cambia, esta guía sigue siendo válida.

---

## 4. Verificar y empezar los ejercicios

En pgAdmin, sobre `veterinariadb`, abre el **Query Tool** y ejecuta:

```sql
SELECT * FROM tutores;
```

Debes ver 2 tutores de ejemplo. 🎉 Todo listo: abre el catálogo y empieza por el primer set.

> 👉 **[Catálogo de ejercicios](../exercise/README.md)**

> 🛟 Cada set trae un `setup.sql` que reconstruye su punto de partida. Si en local necesitas
> empezar un set desde cero, abre ese `setup.sql` en GitHub, copia su contenido y pégalo en el
> Query Tool de `veterinariadb`.
