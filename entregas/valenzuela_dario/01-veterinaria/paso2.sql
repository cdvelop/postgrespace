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

INSERT INTO mascotas (nombre, especie, edad_meses, tutor_id) VALUES
('Almendra', 'Gata', 108, 1),
('Vanessa', 'Gata', 84, 2);
