# Bug: pgAdmin se queda en blanco tras el login en Codespaces (versión web)

> **Estado: RESUELTO** — solución aplicada en `.devcontainer/docker-compose.yml`.

## Síntoma

Al abrir el Codespace **desde el navegador** (VS Code web), pgAdmin se forwardea en el
puerto `5050` y se ve correctamente la **pantalla de login**. Tras introducir las
credenciales y pulsar *Login*:

- La página se queda **completamente en blanco**.
- La interfaz de pgAdmin (árbol de servidores, menús, etc.) **no carga**.

Este problema **no ocurre** cuando se usa **VS Code de escritorio** (instalado en la
máquina host) abriendo el mismo Codespace: ahí pgAdmin carga con normalidad después del
login.

## Causa raíz

La diferencia está en **cómo se reenvía el puerto** según el cliente:

| Cliente | Cómo llega el tráfico a pgAdmin | IP del cliente |
|---|---|---|
| **VS Code escritorio** | Túnel SSH directo a `localhost` | Estable (siempre la misma) |
| **VS Code web (Codespaces)** | Proxy de GitHub (`*.app.github.dev`) | Puede **rotar** entre IPs |

pgAdmin trae activada por defecto la opción **`ENHANCED_COOKIE_PROTECTION`**. Esta función
ata la cookie de sesión a la **IP del cliente** (y al user-agent) como medida anti-secuestro
de sesión.

Cuando se accede a través del proxy de GitHub, las peticiones posteriores al login pueden
salir con una **IP distinta** a la que generó la cookie. pgAdmin detecta el cambio de IP,
considera la sesión inválida y **rechaza las peticiones de la aplicación (SPA)**:

- La página de **login** se renderiza porque **no necesita sesión válida**.
- Tras autenticarse, cada petición de datos de la interfaz devuelve un rechazo/redirección
  → el SPA no recibe contenido → **página en blanco**.

Con VS Code de escritorio el túnel `localhost` mantiene una IP constante, la cookie sigue
siendo válida y pgAdmin carga sin problemas — por eso el bug solo se ve en la versión web.

## Solución aplicada

Desactivar `ENHANCED_COOKIE_PROTECTION` en el contenedor de pgAdmin mediante la variable de
entorno `PGADMIN_CONFIG_ENHANCED_COOKIE_PROTECTION`:

```yaml
pgadmin:
  image: dpage/pgadmin4:latest
  environment:
    PGADMIN_DEFAULT_EMAIL: postgres@sql.dev
    PGADMIN_DEFAULT_PASSWORD: 1234
    PGADMIN_CONFIG_ENHANCED_COOKIE_PROTECTION: "False"
```

> **Formato:** las variables `PGADMIN_CONFIG_*` inyectan valores en el `config_local.py` de
> pgAdmin. El valor debe escribirse como literal de Python entre comillas (`"False"`), no
> como booleano de YAML.

Con la protección desactivada, la cookie de sesión deja de validarse contra la IP del
cliente, por lo que sobrevive al reenvío a través del proxy de GitHub y la interfaz de
pgAdmin carga correctamente también en la versión web de Codespaces.

## Nota de seguridad

`ENHANCED_COOKIE_PROTECTION` es una defensa adicional opcional. Desactivarla es **seguro y
aceptable en este entorno educativo**, donde:

- pgAdmin solo es accesible a través del puerto privado reenviado del propio Codespace del
  alumno (no es público).
- Las credenciales son de un laboratorio local (`postgres` / `1234`), no de producción.

En un despliegue de producción detrás de un proxy se recomendaría, en su lugar, configurar
correctamente las cabeceras `X-Forwarded-For` y el `ProxyFix` de pgAdmin en vez de desactivar
la protección.

## Checklist

- [x] Causa raíz identificada: `ENHANCED_COOKIE_PROTECTION` ata la cookie a la IP, que rota
      tras el proxy de GitHub en la versión web.
- [x] Diferencia VS Code escritorio (túnel localhost, IP estable) vs web (proxy, IP rotante)
      documentada.
- [x] `PGADMIN_CONFIG_ENHANCED_COOKIE_PROTECTION: "False"` añadido en `docker-compose.yml`.
- [x] Nota de seguridad sobre el alcance del cambio incluida.
