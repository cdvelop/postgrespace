# Laboratorio PostgreSQL 🐘

Un laboratorio listo para aprender **PostgreSQL** con **pgAdmin**, sin instalar nada en tu
computador. El entorno arranca con el servidor ya configurado y una base de datos de ejemplo,
para que empieces a practicar SQL de inmediato.

---

## 🚀 Cómo empezar

Elige cómo levantar el entorno:

| Método | Para quién | Guía |
|---|---|---|
| **GitHub Codespaces** ⭐ | Recomendado. Todo en la nube, sin instalar (solo VS Code). | **[Iniciar con Codespaces](docs/INICIO_CODESPACES.md)** |
| **Instalación local** | Correr PostgreSQL y pgAdmin en tu propia máquina. | **[Iniciar en local](docs/INICIO_LOCAL.md)** |

---

## 📚 Ejercicios

Aprende SQL paso a paso, de lo más simple a lo más completo:

> 👉 **[Catálogo de ejercicios](exercise/README.md)**

Empieza por el set **01 — Veterinaria**: lees e insertas datos, creas tus propias tablas y
terminas relacionando tres tablas con un `JOIN`.

---

## 📖 Guías de uso

- **[Cómo hacer Backups](docs/BACKUPS.md)** — Respaldos, importaciones y exportaciones de tus bases de datos.
- **[Registrar el servidor manualmente](docs/REGISTRAR_SERVIDOR.md)** — Solo si el servidor pre-registrado no apareciera en pgAdmin.

## 🧠 Conceptos técnicos

- **[GitHub Codespaces](docs/CODESPACES.md)** — ¿Qué es Codespaces y cómo funciona en este proyecto?
- **[Dev Containers](docs/DEVCONTAINER.md)** — Qué son los contenedores de desarrollo y por qué los usamos.
- **[Docker](docs/DOCKER.md)** — Entiende Docker, la tecnología base de este proyecto.
- **[.gitkeep](docs/GITKEEP.md)** — Un archivo pequeño pero importante en tu repositorio.

---

## 🔑 Credenciales del laboratorio

**pgAdmin**

```text
Correo: postgres@sql.dev
Contraseña: 1234
```

**PostgreSQL**

```text
Host: postgres
Puerto: 5432
Usuario: postgres
Contraseña: 1234
Base de datos: postgres
```

> El servidor ya viene registrado en pgAdmin y la base de ejemplo **`veterinariadb`**
> (con la tabla `tutores` y 2 registros) se crea automáticamente en el primer arranque.

---

⭐ Si este laboratorio te fue útil para aprender PostgreSQL, **dale una estrella al repositorio**.
