CREATE TABLE consultas_veterinarias (
    id_consulta    SERIAL PRIMARY KEY,
    fecha_consulta DATE NOT NULL,
    motivo         VARCHAR(255) NOT NULL,
    costo          DECIMAL(6,2),
    tutor_id       INT,
    mascota_id     INT,
    CONSTRAINT fk_consulta_tutor
        FOREIGN KEY (tutor_id)
        REFERENCES tutores(id_tutor)
        ON DELETE CASCADE,
    CONSTRAINT fk_consulta_mascota
        FOREIGN KEY (mascota_id)
        REFERENCES mascotas(id_mascota)
        ON DELETE CASCADE
);

INSERT INTO consultas_veterinarias (fecha_consulta, motivo, costo, tutor_id, mascota_id) VALUES
('2026-03-10', 'Vacuna anual contra la rabia', 35.00, 1, 1),  
('2026-03-11', 'Esterilización y control',     120.50, 2, 2);

SELECT
    c.fecha_consulta AS "Fecha",
    t.nombre         AS "Tutor",
    m.nombre         AS "Mascota",
    m.especie        AS "Especie",
    c.motivo         AS "Motivo",
    c.costo          AS "Costo"
FROM consultas_veterinarias c
INNER JOIN tutores  t ON c.tutor_id   = t.id_tutor
INNER JOIN mascotas m ON c.mascota_id = m.id_mascota;
