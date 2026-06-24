-- crea un usuario con algunos permisos 
Crea el usuario con contraseña:

CREATE USER recepcionista WITH PASSWORD 'clave123';
Dale permiso de conectarse a la base:

GRANT CONNECT ON DATABASE veterinariadb TO recepcionista;
Dale permiso de leer todas las tablas:

\c veterinariadb
GRANT SELECT ON ALL TABLES IN SCHEMA public TO recepcionista;

-- Quita el acceso a la tabla de costos
REVOKE SELECT ON consultas_veterinarias FROM recepcionista;

| Comando | Qué hace |
|---|---|
| `CREATE USER nombre WITH PASSWORD '...'` | Crea un usuario con contraseña |
| `GRANT CONNECT ON DATABASE db TO usuario` | Permite conectarse a la base |
| `GRANT SELECT ON ALL TABLES IN SCHEMA public TO usuario` | Acceso de solo lectura a todo |
| `GRANT SELECT, INSERT ON tabla TO usuario` | Permisos específicos por tabla |
| `REVOKE permiso ON tabla FROM usuario` | Quita un permiso |
| `\du` | Lista usuarios y sus roles |
