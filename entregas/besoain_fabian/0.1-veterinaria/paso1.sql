CREATE TABLE tutores (
    id_tutor SERIAL PRIMARY KEY,
    nombre   VARCHAR(50) NOT NULL,
    telefono VARCHAR(15)
);


INSERT INTO tutores (nombre, telefono) VALUES
('Carlos Mendoza', '555-1234'),
('Ana Gómez',      '555-5678');

SELECT * FROM tutores;

INSERT INTO tutores (nombre, telefono) VALUES
('Fabian', '333-4321'),
('pepe', '333-1234');

SELECT * FROM tutores;
