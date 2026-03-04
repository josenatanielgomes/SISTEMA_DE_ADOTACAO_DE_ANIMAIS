-- ============================
-- TABELAS
-- ============================

CREATE TABLE IF NOT EXISTS adotante (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS animal (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    especie VARCHAR(50) NOT NULL,
    raca VARCHAR(50),
    porte VARCHAR(2),
    temperamento VARCHAR(100),
    status VARCHAR(20) CHECK (status IN ('DISPONIVEL','RESERVADO','ADOTADO'))
);

CREATE TABLE IF NOT EXISTS estrategia_taxa (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS reserva (
    id SERIAL PRIMARY KEY,
    id_animal INT NOT NULL REFERENCES animal(id),
    id_adotante INT NOT NULL REFERENCES adotante(id),
    dt_reserva DATE NOT NULL,
    dt_expiracao DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS adocao (
    id SERIAL PRIMARY KEY,
    id_animal INT NOT NULL REFERENCES animal(id),
    id_adotante INT NOT NULL REFERENCES adotante(id),
    id_estrategia INT NOT NULL REFERENCES estrategia_taxa(id),
    taxa NUMERIC(10,2) NOT NULL
);

-- ============================
-- INSERÇÕES INICIAIS
-- ============================

-- Adotantes
INSERT INTO adotante (nome) VALUES
('Ana Silva'),
('Carlos Souza'),
('Mariana Lima');

-- Animais
INSERT INTO animal (nome, especie, raca, porte, temperamento, status) VALUES
('Luna', 'Gato', 'Siamês', 'P', 'Curiosa', 'DISPONIVEL'),
('Rex', 'Cachorro', 'SRD', 'M', 'Brincalhão', 'RESERVADO'),
('Thor', 'Cachorro', 'Labrador', 'G', 'Amigável', 'ADOTADO');

-- Estratégias de taxa
INSERT INTO estrategia_taxa (nome) VALUES
('Taxa Fixa'),
('Taxa Variável'),
('Isenção');

-- Reservas
INSERT INTO reserva (id_animal, id_adotante, dt_reserva, dt_expiracao) VALUES
(1, 1, '2026-03-01', '2026-03-10'),
(2, 2, '2026-03-02', '2026-03-12'),
(3, 3, '2026-03-03', '2026-03-13');

-- Adoções
INSERT INTO adocao (id_animal, id_adotante, id_estrategia, taxa) VALUES
(3, 1, 1, 150),
(2, 2, 2, 200),
(1, 3, 3, 0);
