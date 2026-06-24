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

UPDATE tutores
SET telefono = '111-1234'
WHERE nombre = 'Carlos Mendoza';

SELECT * FROM tutores WHERE nombre = 'Carlos Mendoza';

CREATE TABLE mascotas (
    id_mascota SERIAL PRIMARY KEY,
    nombre     VARCHAR(50) NOT NULL,
    especie    VARCHAR(30),      
    edad_meses INT,
    tutor_id   INT,              

    CONSTRAINT fk_tutor
        FOREIGN KEY (tutor_id)
        REFERENCES  tutores(id_tutor)
);

INSERT INTO mascotas (nombre, especie, edad_meses, tutor_id) VALUES
('tomi', 'gato', 3, 3),
('murano', 'perro', 5, 1);

SELECT * FROM mascotas;

INSERT INTO mascotas (nombre, especie, edad_meses, tutor_id) VALUES
('Fantasma', 'Perro', 10, 999);
