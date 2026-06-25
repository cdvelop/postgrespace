| Meta-comando | Qué hace |
|---|---|
| `\conninfo` | Muestra conexión activa |
| `\l` | Lista bases de datos |
| `\dt` | Lista tablas |
| `\d tabla` | Estructura de una tabla |
| `\du` | Lista usuarios |
| `\c nombre` | Cambia de base de datos |
| `\q` | Sale de psql |
--- 
01-veterinaria=# \conninfo
        Connection Information
      Parameter       |     Value
----------------------+----------------
 Database             | 01-veterinaria
 Client User          | postgres
 Host                 | localhost
 Host Address         | ::1
 Server Port          | 5432
 Options              |
 Protocol Version     | 3.0
 Password Used        | true
 GSSAPI Authenticated | false
 Backend PID          | 17568
 SSL Connection       | false
 Superuser            | on
 Hot Standby          | off
(13 rows)
---
01-veterinaria=# \l
                                                               List of databases
      Name      |  Owner   | Encoding | Locale Provider |      Collate       |       Ctype        | Locale | ICU Rules |   Access privileges
----------------+----------+----------+-----------------+--------------------+--------------------+--------+-----------+-----------------------
 01-veterinaria | postgres | UTF8     | libc            | Spanish_Chile.1252 | Spanish_Chile.1252 |        |           |
 DATA_TAMA      | postgres | UTF8     | libc            | Spanish_Chile.1252 | Spanish_Chile.1252 |        |           |
 postgres       | postgres | UTF8     | libc            | Spanish_Chile.1252 | Spanish_Chile.1252 |        |           |
 template0      | postgres | UTF8     | libc            | Spanish_Chile.1252 | Spanish_Chile.1252 |        |           | =c/postgres          +
                |          |          |                 |                    |                    |        |           | postgres=CTc/postgres
 template1      | postgres | UTF8     | libc            | Spanish_Chile.1252 | Spanish_Chile.1252 |        |           | =c/postgres          +
                |          |          |                 |                    |                    |        |           | postgres=CTc/postgres
(5 rows)
---01-veterinaria=# \dt
                   List of tables
 Schema |          Name          | Type  |  Owner
--------+------------------------+-------+----------
 public | consulta_servicios     | table | postgres
 public | consultas_veterinarias | table | postgres
 public | mascotas               | table | postgres
 public | servicios              | table | postgres
 public | tutores                | table | postgres
 public | veterinarios           | table | postgres
(6 rows)
---
01-veterinaria=# \d mascotas
                                         Table "public.mascotas"
   Column   |         Type          | Collation | Nullable |                   Default
------------+-----------------------+-----------+----------+----------------------------------------------
 id_mascota | integer               |           | not null | nextval('mascotas_id_mascota_seq'::regclass)
 nombre     | character varying(50) |           | not null |
 especie    | character varying(30) |           |          |
 edad_meses | integer               |           |          |
 tutor_id   | integer               |           |          |
Indexes:
    "mascotas_pkey" PRIMARY KEY, btree (id_mascota)
Foreign-key constraints:
    "fk_tutor" FOREIGN KEY (tutor_id) REFERENCES tutores(id_tutor) ON DELETE CASCADE
Referenced by:
    TABLE "consultas_veterinarias" CONSTRAINT "fk_consulta_mascota" FOREIGN KEY (mascota_id) REFERENCES mascotas(id_mascota) ON DELETE CASCADE
---
01-veterinaria=# \du
                             List of roles
 Role name |                         Attributes
-----------+------------------------------------------------------------
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS


01-veterinaria=# SELECT nombre, especie FROM mascotas ORDER BY nombre;
  nombre  | especie
----------+---------
 Firulais | Perro
 Kira     | Gato
 Luna     | Gato
 Michi    | Gato
 Nemo     | Pez
 Pepe     | Ave
 Rocky    | Perro
 Toby     | Perro
(8 rows)
---
01-veterinaria=# SELECT t.nombre AS tutor, COUNT(m.id_mascota) AS mascotas
01-veterinaria-# FROM tutores t
01-veterinaria-# LEFT JOIN mascotas m ON m.tutor_id = t.id_tutor
01-veterinaria-# GROUP BY t.nombre
01-veterinaria-# ORDER BY mascotas DESC;
     tutor      | mascotas
----------------+----------
 Ana G¾mez      |        3
 Carlos Mendoza |        3
 SofÝa Rojas    |        1
 Luis MartÝnez  |        1
(4 rows)
