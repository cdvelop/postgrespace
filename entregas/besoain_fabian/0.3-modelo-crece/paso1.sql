SELECT (SELECT COUNT(*) FROM tutores)  AS tutores,
       (SELECT COUNT(*) FROM mascotas) AS mascotas,
       (SELECT COUNT(*) FROM consultas_veterinarias) AS consultas;


	  CREATE TABLE veterinarios (
    id_veterinario SERIAL PRIMARY KEY,
    nombre         VARCHAR(50) NOT NULL,
    especialidad   VARCHAR(50)
);

INSERT INTO veterinarios (nombre, especialidad) VALUES
('Dra. Paula Ríos',  'Medicina general'),  -- id 1
('Dr. Hugo Salas',   'Cirugía'),           -- id 2
('Dra. Elena Costa', 'Dermatología');      -- id 3

SELECT * FROM consultas_veterinarias;

ALTER TABLE consultas_veterinarias
ADD COLUMN veterinario_id INT;

SELECT id_consulta, motivo, veterinario_id FROM consultas_veterinarias;

ALTER TABLE consultas_veterinarias
ADD CONSTRAINT fk_consulta_veterinario
    FOREIGN KEY (veterinario_id)
    REFERENCES veterinarios(id_veterinario);

	-- La Dra. Paula Ríos (1) atiende las generales
UPDATE consultas_veterinarias SET veterinario_id = 1 WHERE id_consulta IN (1, 2, 4, 7, 8);
-- El Dr. Hugo Salas (2) atiende las quirúrgicas y radiografías
UPDATE consultas_veterinarias SET veterinario_id = 2 WHERE id_consulta IN (3, 5, 9);
-- La Dra. Elena Costa (3) atiende la de la mascota con plumas
UPDATE consultas_veterinarias SET veterinario_id = 3 WHERE id_consulta = 6;

SELECT COUNT(*) AS sin_veterinario
FROM consultas_veterinarias
WHERE veterinario_id IS NULL;

ALTER TABLE consultas_veterinarias
ADD CONSTRAINT chk_costo_positivo CHECK (costo >= 0);

ALTER TABLE consultas_veterinarias
ADD COLUMN pagada BOOLEAN DEFAULT false;

INSERT INTO consultas_veterinarias (fecha_consulta, motivo, costo, tutor_id, mascota_id, veterinario_id)
VALUES ('2026-06-01', 'Prueba', -10.00, 1, 1, 1);
