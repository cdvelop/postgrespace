-- Paso 1.1
SELECT * FROM tutores;

-- Paso 1.2
INSERT INTO tutores (nombre, telefono) VALUES
('Pedro Valenzuela', '987654360'),
('Vicente Robles', '934567825');

-- Paso 1.3
SELECT * FROM tutores;

-- Paso 1.4
UPDATE tutores
SET telefono = '999'
WHERE nombre = 'Carlos Mendoza';

-- Paso 1.5
SELECT * FROM tutores WHERE nombre = 'Carlos Mendoza';