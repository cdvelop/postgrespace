--- Crea la tabla veterinarios (CREAR)
CREATE TABLE veterinarios (
    id_veterinario SERIAL PRIMARY KEY,
    nombre         VARCHAR(50) NOT NULL,
    especialidad   VARCHAR(50)
);
-- inserta veterinarios en 
INSERT INTO veterinarios (nombre, especialidad) VALUES
('Dra. Paula Ríos',  'Medicina general'),  -- id 1
('Dr. Hugo Salas',   'Cirugía'),           -- id 2
('Dra. Elena Costa', 'Dermatología');      -- id 3
--- ALTER TABLE ADD COLUMN --- Agrega una columna a una tabla con datos (ALTER TABLE)
ALTER TABLE consultas_veterinarias
ADD COLUMN veterinario_id INT;
--- ALTER TABLE ADD CONSTRAINT FOREING KEY REFERENCES --- Convierte esa columna en clave foránea (ALTER TABLE ADD CONSTRAINT)
ALTER TABLE consultas_veterinarias
ADD CONSTRAINT fk_consulta_veterinario
    FOREIGN KEY (veterinario_id)
    REFERENCES veterinarios(id_veterinario);
--- UPDATE SET WHERE IN  --- Asigna un veterinario a cada consulta (UPDATE)
-- La Dra. Paula Ríos (1) atiende las generales
UPDATE consultas_veterinarias SET veterinario_id = 1 WHERE id_consulta IN (1, 2, 4, 7, 8);
-- El Dr. Hugo Salas (2) atiende las quirúrgicas y radiografías
UPDATE consultas_veterinarias SET veterinario_id = 2 WHERE id_consulta IN (3, 5, 9);
-- La Dra. Elena Costa (3) atiende la de la mascota con plumas
UPDATE consultas_veterinarias SET veterinario_id = 3 WHERE id_consulta = 6;
--- Comprueba que ya no quedan consultas sin veterinario:
SELECT COUNT(*) AS sin_veterinario
FROM consultas_veterinarias
WHERE veterinario_id IS NULL;
---  Ponle reglas de calidad: CHECK y DEFAULT --CHECK obliga a que una columna cumpla una condición. El costo nunca debería ser negativo:
ALTER TABLE consultas_veterinarias
ADD CONSTRAINT chk_costo_positivo CHECK (costo >= 0);
--- DEFAULT da un valor automático cuando no se especifica. Agreguemos si la consulta está pagada, que por defecto sea "no":
ALTER TABLE consultas_veterinarias
ADD COLUMN pagada BOOLEAN DEFAULT false;


