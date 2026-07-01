SELECT * FROM tutores;

INSERT INTO tutores (nombre, telefono) VALUES
('Darío Valenzuela', '677-6076'),
('Felipe Aravena', '881-8811');

SELECT * FROM tutores;

UPDATE tutores
SET telefono = '424-2424'
WHERE nombre = 'Felipe Aravena';
