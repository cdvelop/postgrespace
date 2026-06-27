AND OR

SELECT * FROM mascotas WHERE especie = 'Perro' OR especie = 'Gato';


BETWEEN
  
SELECT nombre, edad_meses FROM mascotas WHERE edad_meses BETWEEN 10 AND 39;

IN

SELECT nombre, especie FROM mascotas WHERE especie IN ('Perro', 'Gato', 'Ave');


LIKE
  
SELECT fecha_consulta, motivo, costo
FROM consultas_veterinarias
WHERE motivo LIKE '%Radiografía%';

LIMIT

SELECT nombre, edad_meses FROM mascotas ORDER BY edad_meses ASC LIMIT 2;
