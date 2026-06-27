@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ mkdir -p entregas/apellido_nombre/04-procedimientos-psql
@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ mkdir -p entregas/alvaro_neira/04-procedimientos-psql
@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ pg_dump -U postgres -d veterinariadb > entregas/alvaro_neira/04-procedimientos-psql/paso3_backup.sql
@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ SELECT id_mascota, nombre FROM mascotas WHERE id_mascota = 1;
bash: SELECT: command not found
@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ -- Anota el nombre original
SELECT id_mascota, nombre FROM mascotas WHERE id_mascota = 1;
-- Resultado: Firulais

-- Cambia el nombre
UPDATE mascotas SET nombre = 'Firu_MODIFICADO' WHERE id_mascota = 1;

-- Confirma el cambio
SELECT id_mascota, nombre FROM mascotas WHERE id_mascota = 1;
-- Resultado: Firu_MODIFICADO
bash: --: command not found
bash: SELECT: command not found
bash: --: command not found
bash: --: command not found
bash: UPDATE: command not found
bash: --: command not found
bash: SELECT: command not found
bash: --: command not found
@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ psql -U postgres
psql (16.14 (Ubuntu 16.14-0ubuntu0.24.04.1), server 15.18)
Type "help" for help.

postgres=# SELECT id_mascota, nombre FROM mascotas WHERE id_mascota = 1;
ERROR:  relation "mascotas" does not exist
LINE 1: SELECT id_mascota, nombre FROM mascotas WHERE id_mascota = 1...
                                       ^
postgres=# \q                                    
@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ psql -U recepcionista -d veterinariadb
psql: error: connection to server at "postgres" (172.18.0.2), port 5432 failed: FATAL:  password authentication failed for user "recepcionista"
@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ psql -U postres -d veterinariadb
psql: error: connection to server at "postgres" (172.18.0.2), port 5432 failed: FATAL:  password authentication failed for user "postres"
@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ psql -U postgrespace -d veterinariadb
psql: error: connection to server at "postgres" (172.18.0.2), port 5432 failed: FATAL:  password authentication failed for user "postgrespace"
@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ psql -U postgres
psql (16.14 (Ubuntu 16.14-0ubuntu0.24.04.1), server 15.18)
Type "help" for help.

postgres=# \l
                                                          List of databases
     Name      |  Owner   | Encoding | Locale Provider |  Collate   |   Ctype    | ICU Locale | ICU Rules |    Access privileges     
---------------+----------+----------+-----------------+------------+------------+------------+-----------+--------------------------
 postgres      | postgres | UTF8     | libc            | en_US.utf8 | en_US.utf8 |            |           | 
 template0     | postgres | UTF8     | libc            | en_US.utf8 | en_US.utf8 |            |           | =c/postgres             +
               |          |          |                 |            |            |            |           | postgres=CTc/postgres
 template1     | postgres | UTF8     | libc            | en_US.utf8 | en_US.utf8 |            |           | =c/postgres             +
               |          |          |                 |            |            |            |           | postgres=CTc/postgres
 veterinariadb | postgres | UTF8     | libc            | en_US.utf8 | en_US.utf8 |            |           | =Tc/postgres            +
               |          |          |                 |            |            |            |           | postgres=CTc/postgres   +
               |          |          |                 |            |            |            |           | recepcionista=c/postgres
(4 rows)

postgres=# ^C
postgres=# \c veterinariadb
psql (16.14 (Ubuntu 16.14-0ubuntu0.24.04.1), server 15.18)
You are now connected to database "veterinariadb" as user "postgres".
veterinariadb=# \dt
                 List of relations
 Schema |          Name          | Type  |  Owner   
--------+------------------------+-------+----------
 public | consulta_servicios     | table | postgres
 public | consultas_veterinarias | table | postgres
 public | mascotas               | table | postgres
 public | servicios              | table | postgres
 public | tutores                | table | postgres
 public | veterinarios           | table | postgres
(6 rows)

veterinariadb=# -- Anota el nombre original
SELECT id_mascota, nombre FROM mascotas WHERE id_mascota = 1;
-- Resultado: Firulais

-- Cambia el nombre
UPDATE mascotas SET nombre = 'Firu_MODIFICADO' WHERE id_mascota = 1;

-- Confirma el cambio
SELECT id_mascota, nombre FROM mascotas WHERE id_mascota = 1;
-- Resultado: Firu_MODIFICADO
 id_mascota |  nombre  
------------+----------
          1 | Firulais
(1 row)

UPDATE 1
 id_mascota |     nombre      
------------+-----------------
          1 | Firu_MODIFICADO
(1 row)

veterinariadb=# psql -U postgres -c "
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'veterinariadb' AND pid <> pg_backend_pid();
"
veterinariadb-# psql -U postgres -c "DROP DATABASE veterinariadb;"
veterinariadb-# psql -U postgres -c "\l"
veterinariadb-# \q
@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ ^C
@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ psql -U postgres -c "
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'veterinariadb' AND pid <> pg_backend_pid();
"
 pg_terminate_backend 
----------------------
 t
 t
(2 rows)

@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ psql -U postgres -c "DROP DATABASE veterinariadb;"
ERROR:  database "veterinariadb" is being accessed by other users
DETAIL:  There is 1 other session using the database.
@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ psql -U postgres -c "\l"
                                                          List of databases
     Name      |  Owner   | Encoding | Locale Provider |  Collate   |   Ctype    | ICU Locale | ICU Rules |    Access privileges     
---------------+----------+----------+-----------------+------------+------------+------------+-----------+--------------------------
 postgres      | postgres | UTF8     | libc            | en_US.utf8 | en_US.utf8 |            |           | 
 template0     | postgres | UTF8     | libc            | en_US.utf8 | en_US.utf8 |            |           | =c/postgres             +
               |          |          |                 |            |            |            |           | postgres=CTc/postgres
 template1     | postgres | UTF8     | libc            | en_US.utf8 | en_US.utf8 |            |           | =c/postgres             +
               |          |          |                 |            |            |            |           | postgres=CTc/postgres
 veterinariadb | postgres | UTF8     | libc            | en_US.utf8 | en_US.utf8 |            |           | =Tc/postgres            +
               |          |          |                 |            |            |            |           | postgres=CTc/postgres   +
               |          |          |                 |            |            |            |           | recepcionista=c/postgres
(4 rows)

@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ psql -U postgres
psql (16.14 (Ubuntu 16.14-0ubuntu0.24.04.1), server 15.18)
Type "help" for help.

postgres=# SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'veterinariadb' AND pid <> pg_backend_pid();
 pg_terminate_backend 
----------------------
 t
(1 row)

postgres=# DROP DATABASE veterinariadb;
ERROR:  database "veterinariadb" is being accessed by other users
DETAIL:  There is 1 other session using the database.
postgres=# ALTER DATABASE veterinariadb WITH ALLOW_CONNECTIONS FALSE;
ALTER DATABASE
postgres=# SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'veterinariadb' AND pid <> pg_backend_pid();
 pg_terminate_backend 
----------------------
 t
(1 row)

postgres=# DROP DATABASE veterinariadb;
DROP DATABASE
postgres=# psql -U postgres -c "\l"
postgres-# psql -U postgres -c "CREATE DATABASE veterinariadb;"
postgres-# psql -U postgres -d veterinariadb < entregas/apellido_nombre/04-procedimientos-psql/paso3_backup.sql
postgres-# \c veterinariadb
connection to server at "postgres" (172.18.0.2), port 5432 failed: FATAL:  database "veterinariadb" does not exist
Previous connection kept
postgres-# \q
@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ psql -U postgres -c "CREATE DATABASE veterinariadb;"
CREATE DATABASE
@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ psql -U postgres -d veterinariadb < data/veterinaria_antes.sql
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
COPY 15
COPY 9
COPY 11
COPY 6
COPY 4
COPY 3
 setval 
--------
      9
(1 row)

 setval 
--------
     11
(1 row)

 setval 
--------
      6
(1 row)

 setval 
--------
      4
(1 row)

 setval 
--------
      3
(1 row)

ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
ALTER TABLE
GRANT
GRANT
GRANT
GRANT
GRANT
GRANT
@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ psql -U postgres -d veterinariadb
psql (16.14 (Ubuntu 16.14-0ubuntu0.24.04.1), server 15.18)
Type "help" for help.

veterinariadb=# \dt
                 List of relations
 Schema |          Name          | Type  |  Owner   
--------+------------------------+-------+----------
 public | consulta_servicios     | table | postgres
 public | consultas_veterinarias | table | postgres
 public | mascotas               | table | postgres
 public | servicios              | table | postgres
 public | tutores                | table | postgres
 public | veterinarios           | table | postgres
(6 rows)

veterinariadb=# psql -U postgres -d veterinariadb -c "SELECT id_mascota, nombre FROM mascotas WHERE id_mascota = 1;"
veterinariadb-# \q
@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ psql -U postgres -d veterinariadb -c "SELECT id_mascota, nombre FROM mascotas WHERE id_mascota = 1;"
 id_mascota |  nombre  
------------+----------
          1 | Firulais
(1 row)

@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ psql -U postgres -d veterinariadb -c "
SELECT (SELECT COUNT(*) FROM tutores)                 AS tutores,
       (SELECT COUNT(*) FROM mascotas)                AS mascotas,
       (SELECT COUNT(*) FROM veterinarios)            AS veterinarios,
       (SELECT COUNT(*) FROM consultas_veterinarias)  AS consultas,
       (SELECT COUNT(*) FROM servicios)               AS servicios,
       (SELECT COUNT(*) FROM consulta_servicios)      AS relaciones;
"
 tutores | mascotas | veterinarios | consultas | servicios | relaciones 
---------+----------+--------------+-----------+-----------+------------
       4 |       11 |            3 |         9 |         6 |         15
(1 row)

@alvaroneira2233-prog ➜ /workspaces/postgrespace (main) $ 
