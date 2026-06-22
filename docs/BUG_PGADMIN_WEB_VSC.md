# Bug: pgAdmin se queda en blanco tras el login en Codespaces (versión web)

> **Estado: RESUELTO** — solución final: hacer que pgAdmin confíe en las cabeceras
> `X-Forwarded-*` del proxy de Codespaces (**ProxyFix**: `PROXY_X_PROTO_COUNT`/`HOST_COUNT`/
> `PREFIX_COUNT`) en `.devcontainer/docker-compose.yml`. Los intentos previos (cookies y modo
> escritorio por sí solo) **no** funcionaron; se documentan abajo para no repetirlos.

## Síntoma

Al abrir el Codespace **desde el navegador** (VS Code web), pgAdmin se forwardea en el
puerto `5050` y carga, pero la interfaz (árbol de servidores, menús) **se queda en blanco**.
En la consola del navegador, las peticiones **XHR** a `preferences/get_all`, `misc/bgprocess/`,
`status`, `browser/check_corrupted_db_file`, `llm/status` devuelven **401 (Unauthorized)**,
mientras los archivos estáticos (`app.bundle.js`, etc.) cargan con **200**.

Este problema **no ocurre** con **VS Code de escritorio** abriendo el mismo Codespace: ahí
pgAdmin carga con normalidad.

## Causa raíz

El proxy de GitHub (`*.app.github.dev`) **termina el TLS** y reenvía a pgAdmin por HTTP
plano. Por defecto pgAdmin (Flask) **no confía** en las cabeceras `X-Forwarded-*` del proxy,
así que ve la petición como **HTTP** y con el host/esquema equivocados. En ese escenario
genera mal la **cookie de sesión** (y las URLs), por lo que no hay una sesión válida:

- Los archivos **estáticos** cargan con **200** (no requieren sesión).
- Las **XHR autenticadas** del SPA devuelven **401** → el SPA no recibe datos → **página en blanco**.

Con VS Code de escritorio el túnel `localhost` no mete un proxy que rompa el esquema, por eso
el bug solo se veía en la versión web.

> Las XHR son del **mismo origen** que la página, por lo que el atributo `SameSite` de la
> cookie **no** es el problema. El problema es que pgAdmin, al no saber que detrás hay un proxy
> HTTPS, no establece una cookie de sesión utilizable.

## Intentos que NO funcionaron

Se documentan para no repetirlos:

1. **`ENHANCED_COOKIE_PROTECTION: "False"`** — atacaba una supuesta rotación de IP. No
   resolvió el 401.
2. **`SESSION_COOKIE_SECURE: "True"` + `SESSION_COOKIE_SAMESITE: "'None'"`** — `SameSite` no
   aplica a peticiones de mismo origen, así que tampoco resolvió nada.
3. **Modo escritorio (`SERVER_MODE=False`) por sí solo** — quita la *pantalla* de login, pero
   pgAdmin hace **auto-login** y sigue usando una sesión con cookie. El 401 persistió igual.
   (Se mantiene, ver abajo, porque simplifica el uso, pero no es lo que arregla el bug.)

## Solución aplicada — ProxyFix

Hay que decirle a pgAdmin que está detrás de **un** proxy de confianza para que lea las
cabeceras `X-Forwarded-Proto`/`Host`/`Prefix` y reconstruya el esquema (https) y host reales.
Con eso genera la cookie de sesión correctamente y las XHR dejan de dar 401:

```yaml
pgadmin:
  image: dpage/pgadmin4:latest
  environment:
    PGADMIN_DEFAULT_EMAIL: postgres@sql.dev
    PGADMIN_DEFAULT_PASSWORD: 1234
    # Modo escritorio (sin login) — opcional, por comodidad
    PGADMIN_CONFIG_SERVER_MODE: "False"
    PGADMIN_CONFIG_MASTER_PASSWORD_REQUIRED: "False"
    # Lo que de verdad arregla el 401 tras el proxy de Codespaces:
    PGADMIN_CONFIG_PROXY_X_PROTO_COUNT: 1
    PGADMIN_CONFIG_PROXY_X_HOST_COUNT: 1
    PGADMIN_CONFIG_PROXY_X_PREFIX_COUNT: 1
```

> **Notas:**
> - `*_COUNT: 1` = confía en 1 salto de proxy (el de GitHub). No usar valores mayores: confiar
>   en cabeceras de más saltos de los reales es un riesgo de *spoofing*.
> - `PGADMIN_DEFAULT_EMAIL`/`PASSWORD` siguen siendo necesarios: el *entrypoint* del contenedor
>   los exige aunque haya modo escritorio.
> - Las variables `PGADMIN_CONFIG_*` se inyectan **verbatim como literal de Python** en el
>   `config_local.py`; por eso los enteros van sin comillas (`1`) y los booleanos como `"False"`.

## Si aún así falla: visibilidad del puerto

Los puertos reenviados de Codespaces son **privados** por defecto y exigen autenticación; en
algunos casos las peticiones XHR no la superan y devuelven 401. Si tras el ProxyFix sigue
fallando, en la pestaña **Ports** cambia la visibilidad del puerto **5050** a **Public**
(los puertos públicos no requieren esa autenticación). Alternativa siempre fiable: abrir el
Codespace en **VS Code de escritorio**, donde no hay proxy que rompa el esquema.

## Nota de seguridad

- Confiar en `X-Forwarded-*` con `*_COUNT: 1` es correcto: hay exactamente un proxy (GitHub).
- El modo escritorio desactiva el login de pgAdmin. Es aceptable aquí (puerto privado del
  propio Codespace, lab local de un usuario, credenciales `postgres`/`1234`). En producción
  **no** se usa: ahí va modo servidor + proxy bien configurado.

## Checklist

- [x] Causa raíz real: pgAdmin no confía en `X-Forwarded-*`, ve HTTP/host erróneo y genera mal
      la cookie de sesión → XHR autenticadas con 401 → página en blanco (estáticos 200).
- [x] Descartado `SameSite` (XHR de mismo origen), rotación de IP y "quitar el login"
      (auto-login sigue usando cookie).
- [x] `PROXY_X_PROTO_COUNT`/`HOST_COUNT`/`PREFIX_COUNT = 1` aplicados en `docker-compose.yml`.
- [x] Documentado el *fallback* de puerto público / VS Code escritorio.
- [x] Nota de seguridad incluida.
