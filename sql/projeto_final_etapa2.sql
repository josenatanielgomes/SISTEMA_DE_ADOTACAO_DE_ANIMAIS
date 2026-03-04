-- ============================================================
-- UNIVERSIDADE FEDERAL DO CARIRI - UFCA
-- CURSO DE TECNOLOGIA EM BANCO DE DADOS
--
-- PROJETO FINAL - Etapa 2: SCRIPT SQL COM PK, FK E INTEGRIDADE
-- TEMA 1: SISTEMA DE ADOÇÃO DE ANIMAIS
-- ALUNO: JOSE NATANIEL GOMES PEREIRA
-- ============================================================

-- =========================
-- TABELAS PRINCIPAIS
-- =========================

CREATE TABLE ANIMAL (
    ID SERIAL PRIMARY KEY,
    Especie VARCHAR(50) NOT NULL,
    Raca VARCHAR(50),
    Nome VARCHAR(50),
    Sexo CHAR(1) CHECK (Sexo IN ('M','F')),
    IdadeMeses INT CHECK (IdadeMeses >= 0),
    Porte CHAR(1) CHECK (Porte IN ('P','M','G')),
    Temperamento VARCHAR(100),
    Status VARCHAR(20) CHECK (Status IN ('DISPONIVEL','RESERVADO','ADOTADO','DEVOLVIDO','QUARENTENA','INADOTAVEL'))
);

CREATE TABLE ADOTANTE (
    ID SERIAL PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Idade INT CHECK (Idade >= 0),
    Moradia VARCHAR(10) CHECK (Moradia IN ('casa','apto')),
    AreaUtil INT,
    ExperienciaPets BOOLEAN,
    Criancas BOOLEAN,
    OutrosAnimais BOOLEAN
);

-- =========================
-- HISTÓRICO E EVENTOS
-- =========================

CREATE TABLE HISTORICO_EVENTOS (
    ID SERIAL PRIMARY KEY,
    ID_Animal INT NOT NULL,
    Evento VARCHAR(100) NOT NULL,
    Data_Evento DATE NOT NULL,
    FOREIGN KEY (ID_Animal) REFERENCES ANIMAL(ID) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- =========================
-- PROCESSO DE RESERVA
-- =========================

CREATE TABLE RESERVA (
    ID SERIAL PRIMARY KEY,
    ID_Animal INT NOT NULL,
    ID_Adotante INT NOT NULL,
    Dt_Reserva DATE NOT NULL,
    Dt_Expiracao DATE NOT NULL,
    FOREIGN KEY (ID_Animal) REFERENCES ANIMAL(ID) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (ID_Adotante) REFERENCES ADOTANTE(ID) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE (ID_Animal) -- garante 1 reserva ativa por animal
);

CREATE TABLE NOTIFICACAO (
    ID SERIAL PRIMARY KEY,
    ID_Reserva INT NOT NULL,
    Mensagem VARCHAR(200) NOT NULL,
    Dt_Notificacao DATE NOT NULL,
    FOREIGN KEY (ID_Reserva) REFERENCES RESERVA(ID) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- =========================
-- ADOÇÃO E TAXAS
-- =========================

CREATE TABLE ESTRATEGIA_TAXA (
    ID SERIAL PRIMARY KEY,
    Nome VARCHAR(50) NOT NULL,
    Descricao VARCHAR(200)
);

CREATE TABLE ADOTACAO (
    ID SERIAL PRIMARY KEY,
    ID_Animal INT NOT NULL UNIQUE, -- 1:1 com ANIMAL
    ID_Adotante INT NOT NULL,
    Dt_Adocao DATE NOT NULL,
    Taxa NUMERIC(10,2),
    Contrato TEXT,
    ID_Estrategia INT NOT NULL,
    FOREIGN KEY (ID_Animal) REFERENCES ANIMAL(ID) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (ID_Adotante) REFERENCES ADOTANTE(ID) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (ID_Estrategia) REFERENCES ESTRATEGIA_TAXA(ID) 
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE DEVOLUCAO (
    ID SERIAL PRIMARY KEY,
    ID_Animal INT NOT NULL,
    ID_Adotante INT NOT NULL,
    Dt_Devolucao DATE NOT NULL,
    Motivo VARCHAR(200),
    FOREIGN KEY (ID_Animal) REFERENCES ANIMAL(ID) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (ID_Adotante) REFERENCES ADOTANTE(ID) 
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- =========================
-- FILA DE ESPERA E COMPATIBILIDADE
-- =========================

CREATE TABLE LISTA_ESPERA (
    ID SERIAL PRIMARY KEY,
    ID_Animal INT NOT NULL,
    ID_Adotante INT NOT NULL,
    Pontuacao INT CHECK (Pontuacao BETWEEN 0 AND 100),
    Dt_Entrada DATE NOT NULL,
    FOREIGN KEY (ID_Animal) REFERENCES ANIMAL(ID) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ID_Adotante) REFERENCES ADOTANTE(ID) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE (ID_Animal, ID_Adotante) -- evita duplicidade na fila
);

CREATE TABLE COMPATIBILIDADE (
    ID SERIAL PRIMARY KEY,
    ID_Animal INT NOT NULL,
    ID_Adotante INT NOT NULL,
    Pontuacao INT CHECK (Pontuacao BETWEEN 0 AND 100),
    Dt_Calculo DATE NOT NULL,
    FOREIGN KEY (ID_Animal) REFERENCES ANIMAL(ID) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ID_Adotante) REFERENCES ADOTANTE(ID) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE (ID_Animal, ID_Adotante) -- garante 1 cálculo por par
);

-- =========================
-- REAVALIAÇÃO E CONFIGURAÇÕES
-- =========================

CREATE TABLE REAVALIACAO (
    ID SERIAL PRIMARY KEY,
    ID_Animal INT NOT NULL,
    Dt_Reavaliacao DATE NOT NULL,
    Resultado VARCHAR(20) CHECK (Resultado IN ('DISPONIVEL','INADOTAVEL')),
    Observacoes TEXT,
    FOREIGN KEY (ID_Animal) REFERENCES ANIMAL(ID) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE CONFIGURACAO (
    ID SERIAL PRIMARY KEY,
    Nome_Politica VARCHAR(50) NOT NULL,
    Valor VARCHAR(50) NOT NULL
);
