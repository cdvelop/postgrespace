CREATE TABLE servicios (
    id_servicio SERIAL PRIMARY KEY,
    nombre      VARCHAR(50) NOT NULL UNIQUE,   -- no puede haber 2 servicios con el mismo nombre
    precio      DECIMAL(6,2) CHECK (precio >= 0)
);

INSERT INTO servicios (nombre, precio) VALUES
('Vacuna',          20.00),  -- id 1
('Examen general',  15.00),  -- id 2
('Baño',            10.00),  -- id 3
('Desparasitación', 12.00),  -- id 4
('Radiografía',     25.00),  -- id 5
('Cirugía',        100.00);  -- id 6

CREATE TABLE consulta_servicios (
    consulta_id INT,
    servicio_id INT,

    -- 👇 La clave primaria es la PAREJA completa: impide repetir el mismo
    --    servicio dos veces en la misma consulta.
    PRIMARY KEY (consulta_id, servicio_id),

    CONSTRAINT fk_cs_consulta
        FOREIGN KEY (consulta_id) REFERENCES consultas_veterinarias(id_consulta)
        ON DELETE CASCADE,
    CONSTRAINT fk_cs_servicio
        FOREIGN KEY (servicio_id) REFERENCES servicios(id_servicio)
        ON DELETE CASCADE
);

INSERT INTO consulta_servicios (consulta_id, servicio_id) VALUES
(1, 1), (1, 2),   -- consulta 1: Vacuna + Examen general
(2, 2),           -- consulta 2: Examen general
(3, 6), (3, 2),   -- consulta 3: Cirugía + Examen general
(4, 4),           -- consulta 4: Desparasitación
(5, 6), (5, 2),   -- consulta 5: Cirugía + Examen general
(6, 2),           -- consulta 6: Examen general
(7, 3),           -- consulta 7: Baño
(8, 1), (8, 2),   -- consulta 8: Vacuna + Examen general
(9, 5);           -- consulta 9: Radiografía

SELECT * FROM consulta_servicios ORDER BY consulta_id, servicio_id;

INSERT INTO consulta_servicios (consulta_id, servicio_id) VALUES (1, 1);
