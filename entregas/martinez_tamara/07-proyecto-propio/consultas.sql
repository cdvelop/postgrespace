-- CONSULTA 1
-- Qué compró cada cliente, cuándo y cómo pagó?
-- Muestra el historial completo de compras

 
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
 

-- CONSULTA 2
-- Qué autores escribieron cada libro?
-- Demuestra la relación N:M entre LIBROS y AUTORES

 
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
 

-- CONSULTA 3
-- Cuánto ha gastado cada cliente en total?
-- Identifica los clientes más activos

 
SELECT
    C.Nombre                AS Cliente,
    COUNT(RC.ID_Compra)     AS Cantidad_compras,
    SUM(RC.Total)           AS Total_gastado
FROM CLIENTES C
JOIN REGISTRO_COMPRA RC ON C.ID_Cliente = RC.ID_Cliente
GROUP BY C.Nombre
ORDER BY Total_gastado DESC;

-- USO DE LA FUNCIÓN
-- Calcula el total gastado por un cliente específico

 
-- Total gastado por María (ID_Cliente = 1)
SELECT total_compras_cliente(1) AS Total_Maria;
 
-- Total gastado por Pedro (ID_Cliente = 2)
SELECT total_compras_cliente(2) AS Total_Pedro;
