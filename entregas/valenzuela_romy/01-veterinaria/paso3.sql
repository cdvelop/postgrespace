-- Paso 3.1: Crear tabla con 2 FK
CREATE TABLE consultas_veterinarias (
    id_consulta SERIAL PRIMARY KEY,
    fecha_consulta DATE NOT NULL,
    motivo VARCHAR(255) NOT NULL,
    costo DECIMAL(6,2),
    tutor_id INT,
    mascota_id INT,
   
    CONSTRAINT fk_consulta_mascota FOREIGN KEY (mascota_id) REFERENCES mascotas(id_mascotas),
    CONSTRAINT fk_tutor FOREIGN KEY (tutor_id) REFERENCES tutores(id_tutor)   

);

-- Paso 3.2: Insertar 2 consultas
INSERT INTO consultas_veterinarias (mascota_id, tutor_id, fecha_consulta, motivo, costo) VALUES
(1, 1, '2025-09-10', 'Control anual y vacunas', 9999),
(2, 2, '2025-09-12', 'Dolor de estómago', 8000);

-- Paso 3.3: JOIN de las 3 tablas 
SELECT
     c.fecha_consulta AS "Fecha",
     t.nombre AS "Tutor",
     m.nombre AS "Mascota",
     m.especie AS "Especie",
     c.motivo AS "Motivo",
     c.costo AS "Costo",

FROM consultas_veterinarias c
INNER JOIN tutores t ON c.tutor_id = t.id_tutor
INNER JOIN mascotas m ON c.mascota_id = m.id_mascotas;