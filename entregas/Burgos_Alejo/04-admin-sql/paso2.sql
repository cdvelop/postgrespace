-- ## EJERCICIO 5 ##

-- Paso 4.1
CREATE USER recepcionista WITH PASSWORD 'clave123';
GRANT CONNECT ON DATABASE veterinariadb TO recepcionista;
-- Permiso para leer todas las tablas
GRANT SELECT ON ALL TABLES IN SCHEMA public TO recepcionista;

-- Paso 4.3
-- Quita el acceso a la tabla de costos
REVOKE SELECT ON consultas_veterinarias FROM recepcionista;

-- Paso 4.4
CREATE USER veterinario_app WITH PASSWORD 'vet456';
GRANT CONNECT ON DATABASE veterinariadb TO veterinario_app;

-- Escritura solo donde opera
GRANT SELECT, INSERT ON consultas_veterinarias TO veterinario_app;
GRANT SELECT, INSERT ON consulta_servicios     TO veterinario_app;

-- Solo lectura en tablas de referencia
GRANT SELECT ON tutores, mascotas, veterinarios, servicios TO veterinario_app;

