Crea el usuario con contraseña:

CREATE USER recepcionista WITH PASSWORD 'clave123';

-- Como superusuario:
psql -U postgres
CREATE USER veterinario_app WITH PASSWORD 'vet456';
GRANT CONNECT ON DATABASE veterinariadb TO veterinario_app;
\c veterinariadb
You are now connected to database "veterinariadb" as user "postgres".
-- Escritura solo donde opera
GRANT SELECT, INSERT ON consultas_veterinarias TO veterinario_app;
GRANT SELECT, INSERT ON consulta_servicios     TO veterinario_app;

-- Solo lectura en tablas de referencia
GRANT SELECT ON tutores, mascotas, veterinarios, servicios TO veterinario_app;

--GRANT

Dale permiso de conectarse a la base:

GRANT CONNECT ON DATABASE veterinariadb TO recepcionista;

Dale permiso de leer todas las tablas:

GRANT SELECT ON ALL TABLES IN SCHEMA public TO recepcionista;


GRANT SELECT ON consultas_veterinarias TO recepcionista;
\q

-- Escritura solo donde opera
GRANT SELECT, INSERT ON consultas_veterinarias TO veterinario_app;
GRANT SELECT, INSERT ON consulta_servicios     TO veterinario_app;

-- Solo lectura en tablas de referencia
GRANT SELECT ON tutores, mascotas, veterinarios, servicios TO veterinario_app;

-- REVOKE

-- Quita el acceso a la tabla de costos
REVOKE SELECT ON consultas_veterinarias FROM recepcionista;
