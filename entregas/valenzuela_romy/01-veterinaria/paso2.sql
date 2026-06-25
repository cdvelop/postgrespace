-- Paso 2.1
CREATE TABLE mascotas (
    id_mascota SERIAL PRIMARY KEY,
    nombre     VARCHAR(50) NOT NULL,
    especie    VARCHAR(30),
    edad_meses INT,
    tutor_id   INT,
    CONSTRAINT fk_tutor
        FOREIGN KEY (tutor_id)
        REFERENCES tutores(id_tutor)
        ON DELETE CASCADE
);

-- Paso 2.2
INSERT INTO mascotas (nombre, especie, edad_meses, tutor_id) VALUES
('Tobby', 'Perro', 24, 1),
('Julieta', 'Gato', 36, 2);

-- Paso 2.3
SELECT * FROM mascotas;

-- Paso 2.4
INSERT INTO mascotas (nombre, especie, edad_meses, tutor_id) VALUES
('Fantasma', 'Perro', 12, 999);
