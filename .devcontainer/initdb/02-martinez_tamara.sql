
--   BASE DE DATOS: LIBRERÍA
--   Normalizada hasta 3FN
--   Incluye relación N:M (LIBROS - AUTORES)


CREATE DATABASE libreria;
\connect libreria


--   TABLAS INDEPENDIENTESS (sin FK)
--   Se crean primero para que las FK funcionen

-- 1. GENERO
CREATE TABLE GENERO (
    ID_Genero   SERIAL        PRIMARY KEY,
    Nombre      VARCHAR(50)   NOT NULL
);

-- 2. AUTORES
CREATE TABLE AUTORES (
    ID_Autor      SERIAL        PRIMARY KEY,
    Nombre        VARCHAR(100)  NOT NULL,
    Nacionalidad  VARCHAR(50)
);

-- 3. TIPO_PAGO
CREATE TABLE TIPO_PAGO (
    ID_Pago     SERIAL        PRIMARY KEY,
    Tipo_pago   VARCHAR(20)   NOT NULL
);

-- 4. CLIENTES
CREATE TABLE CLIENTES (
    ID_Cliente      SERIAL        PRIMARY KEY,
    Nombre          VARCHAR(50)   NOT NULL,
    RUT             CHAR(12)      NOT NULL UNIQUE,
    Email           VARCHAR(100)  NOT NULL UNIQUE,
    Telefono        CHAR(9),
    Fecha_registro  DATE          DEFAULT CURRENT_DATE
);


--   TABLAS CON FK
--   Se crean después de las independientes


-- 5. LIBROS (depende de GENERO)
CREATE TABLE LIBROS (
    ID_Libro    SERIAL          PRIMARY KEY,
    Titulo      VARCHAR(200)    NOT NULL,
    ISBN        CHAR(13)        NOT NULL UNIQUE,
    Precio      DECIMAL(10,2)   NOT NULL,
    Stock       INT             NOT NULL DEFAULT 0,
    ID_Genero   INT             NOT NULL,
    FOREIGN KEY (ID_Genero) REFERENCES GENERO(ID_Genero)
);

-- 6. LIBRO_AUTOR — tabla puente N:M
--    PK compuesta: la combinación ID_Libro + ID_Autor es única
CREATE TABLE LIBRO_AUTOR (
    ID_Libro    INT   NOT NULL,
    ID_Autor    INT   NOT NULL,
    PRIMARY KEY (ID_Libro, ID_Autor),
    FOREIGN KEY (ID_Libro)  REFERENCES LIBROS(ID_Libro),
    FOREIGN KEY (ID_Autor)  REFERENCES AUTORES(ID_Autor)
);

-- 7. REGISTRO_COMPRA (depende de CLIENTES, LIBROS, TIPO_PAGO)
CREATE TABLE REGISTRO_COMPRA (
    ID_Compra     SERIAL          PRIMARY KEY,
    ID_Cliente    INT             NOT NULL,
    ID_Libro      INT             NOT NULL,
    ID_Pago       INT             NOT NULL,
    Fecha_compra  DATE            DEFAULT CURRENT_DATE,
    Cantidad      INT             NOT NULL DEFAULT 1,
    Total         DECIMAL(10,2)   NOT NULL,
    FOREIGN KEY (ID_Cliente)  REFERENCES CLIENTES(ID_Cliente),
    FOREIGN KEY (ID_Libro)    REFERENCES LIBROS(ID_Libro),
    FOREIGN KEY (ID_Pago)     REFERENCES TIPO_PAGO(ID_Pago)
);

--   DATOS DE PRUEBA
-- GENERO
INSERT INTO GENERO (Nombre) VALUES
('Literatura Infantil'),
('Literatura Fantasía'),
('Literatura Clásica'),
('Arte'),
('Cine');

-- AUTORES
INSERT INTO AUTORES (Nombre, Nacionalidad) VALUES
('Antoine de Saint-Exupéry',  'Francés'),
('J.K. Rowling',              'Británica'),
('Homero',                    'Griego'),
('Hermann Hesse',             'Alemán'),
('Pablo Picasso',             'Español'),
('Mark Cousin',               'Británico');

-- TIPO_PAGO
INSERT INTO TIPO_PAGO (Tipo_pago) VALUES
('Efectivo'),
('Débito'),
('Crédito');

-- CLIENTES
INSERT INTO CLIENTES (Nombre, RUT, Email, Telefono, Fecha_registro) VALUES
('María',  '5.555.555-5',  'maria@correo.cl',  '912345678',  '2024-01-15'),
('Pedro',  '4.444.444-4',  'pedro@correo.cl',  '923456789',  '2024-02-20'),
('Juan',   '33.333.333-3', 'juan@correo.cl',   '934567890',  '2024-03-10'),
('Diego',  '22.222.222-2', 'diego@correo.cl',  '945678901',  '2024-04-05');

-- LIBROS
INSERT INTO LIBROS (Titulo, ISBN, Precio, Stock, ID_Genero) VALUES
('El Principito',       '9788841908799',  9990.00,  15,  1),
('Harry Potter',        '9789878000404',  14990.00, 10,  2),
('La Odisea',           '9788842493908',  11990.00, 8,   3),
('Demian',              '9789561230156',  8990.00,  12,  3),
('Colores',             '9788572311065',  12990.00, 5,   4),
('100 Películas Clásicas', '9788383655616', 19990.00, 7, 5);

-- LIBRO_AUTOR (tabla puente N:M)
-- Un libro puede tener varios autores
INSERT INTO LIBRO_AUTOR (ID_Libro, ID_Autor) VALUES
(1, 1),  -- El Principito → Saint-Exupéry
(2, 2),  -- Harry Potter → J.K. Rowling
(3, 3),  -- La Odisea → Homero
(4, 4),  -- Demian → Hermann Hesse
(5, 5),  -- Colores → Picasso
(5, 1),  -- Colores → también Saint-Exupéry (N:M en acción)
(6, 6),  -- 100 Películas → Mark Cousin
(6, 2);  -- 100 Películas → también J.K. Rowling (N:M en acción)

-- REGISTRO_COMPRA
INSERT INTO REGISTRO_COMPRA (ID_Cliente, ID_Libro, ID_Pago, Fecha_compra, Cantidad, Total) VALUES
(1, 1, 1, '2024-05-01', 1,  9990.00),   -- María compró El Principito en Efectivo
(1, 2, 1, '2024-05-01', 1,  14990.00),  -- María compró Harry Potter en Efectivo
(2, 3, 3, '2024-05-10', 1,  11990.00),  -- Pedro compró La Odisea con Crédito
(3, 4, 2, '2024-05-15', 2,  17980.00),  -- Juan compró 2 Demian con Débito
(3, 5, 1, '2024-05-15', 1,  12990.00),  -- Juan compró Colores en Efectivo
(4, 6, 2, '2024-05-20', 1,  19990.00);  -- Diego compró 100 Películas con Débito


--   FUNCIÓN: calcular total de compras por cliente


CREATE OR REPLACE FUNCTION total_compras_cliente(p_id_cliente INT)
RETURNS DECIMAL AS $$
DECLARE
    v_total DECIMAL;
BEGIN
    SELECT COALESCE(SUM(Total), 0)
    INTO v_total
    FROM REGISTRO_COMPRA
    WHERE ID_Cliente = p_id_cliente;

    RETURN v_total;
END;
$$ LANGUAGE plpgsql;


--   CONSULTAS DE ANÁLISIS

-- 1. Ver todas las compras con nombres reales
SELECT
    RC.ID_Compra,
    C.Nombre            AS Cliente,
    L.Titulo            AS Libro,
    G.Nombre            AS Genero,
    TP.Tipo_pago        AS Pago,
    RC.Fecha_compra,
    RC.Cantidad,
    RC.Total
FROM REGISTRO_COMPRA RC
JOIN CLIENTES   C   ON RC.ID_Cliente = C.ID_Cliente
JOIN LIBROS     L   ON RC.ID_Libro   = L.ID_Libro
JOIN GENERO     G   ON L.ID_Genero   = G.ID_Genero
JOIN TIPO_PAGO  TP  ON RC.ID_Pago    = TP.ID_Pago
ORDER BY RC.Fecha_compra;

-- 2. Ver libros con todos sus autores
SELECT
    L.Titulo        AS Libro,
    G.Nombre        AS Genero,
    A.Nombre        AS Autor,
    A.Nacionalidad
FROM LIBROS L
JOIN LIBRO_AUTOR LA ON L.ID_Libro  = LA.ID_Libro
JOIN AUTORES     A  ON LA.ID_Autor = A.ID_Autor
JOIN GENERO      G  ON L.ID_Genero = G.ID_Genero
ORDER BY L.Titulo;

-- 3. Total gastado por cada cliente
SELECT
    C.Nombre            AS Cliente,
    COUNT(RC.ID_Compra) AS Cantidad_compras,
    SUM(RC.Total)       AS Total_gastado
FROM CLIENTES C
JOIN REGISTRO_COMPRA RC ON C.ID_Cliente = RC.ID_Cliente
GROUP BY C.Nombre
ORDER BY Total_gastado DESC;

-- 4. Usar la función para ver total de un cliente específico
SELECT total_compras_cliente(1) AS Total_Maria;
