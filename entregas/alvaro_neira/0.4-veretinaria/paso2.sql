@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ psql -U postgres
psql (16.14 (Ubuntu 16.14-0ubuntu0.24.04.1), server 15.18)
Type "help" for help.

postgres=# CREATE USER recepcionista WITH PASSWORD 'clave123';
ERROR:  role "recepcionista" already exists
postgres=# \q
@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ psql -U recepcionista -d veterinariadb
psql: error: connection to server at "postgres" (172.18.0.2), port 5432 failed: FATAL:  password authentication failed for user "recepcionista"
@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ SELECT nombre, especie FROM mascotas;
bash: SELECT: command not found
@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ \q
bash: q: command not found
@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ psql -U postgres -d veterinariadb
psql (16.14 (Ubuntu 16.14-0ubuntu0.24.04.1), server 15.18)
Type "help" for help.

veterinariadb=# -- Quita el acceso a la tabla de costos
REVOKE SELECT ON consultas_veterinarias FROM recepcionista;
REVOKE
veterinariadb=# SELECT costo FROM consultas_veterinarias;
-- ERROR: permission denied for table consultas_veterinarias
 costo  
--------
  30.00
  18.50
 150.00
  22.00
 120.00
  15.00
  12.00
  30.00
  45.00
(9 rows)

veterinariadb=# GRANT SELECT ON consultas_veterinarias TO recepcionista;
GRANT
veterinariadb=# \q
@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ 
