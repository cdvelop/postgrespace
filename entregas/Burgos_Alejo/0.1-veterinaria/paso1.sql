-- Paso 1.1
SELECT * FROM tutores;

-- Paso 1.2
INSERT INTO tutores (nombre, telefono) VALUES
('Alejo Burgos', '+569 12345678'),
('Paula Labra', '+569 87654321');

-- Paso 1.3
SELECT * FROM tutores;

-- Paso 1.4
UPDATE tutores
SET telefono = '555-4321'
WHERE nombre = 'Carlos Mendoza';

-- Paso 1.5
SELECT * FROM tutores WHERE nombre = 'Carlos Mendoza';
