-- ============================================================
-- UNIVERSIDADE FEDERAL DO CARIRI - UFCA
-- CURSO DE TECNOLOGIA EM BANCO DE DADOS
--
-- PROJETO FINAL - Etapa 3: CARGA DE DADOS E CONSULTAS INICIAIS
-- TEMA 1: SISTEMA DE ADOÇÃO DE ANIMAIS
-- ALUNO: JOSE NATANIEL GOMES PEREIRA
-- ============================================================

-- ===============================
-- ETAPA 3 - PROJETO FINAL
-- Carga de dados (INSERTs)
-- ===============================

-- Inserindo animais
INSERT INTO ANIMAL (Especie, Raca, Nome, Sexo, IdadeMeses, Porte, Temperamento, Status) VALUES
('Cachorro', 'SRD', 'Rex', 'M', 24, 'M', 'Brincalhão', 'DISPONIVEL'),
('Gato', 'Persa', 'Mimi', 'F', 12, 'P', 'Calma', 'RESERVADO'),
('Cachorro', 'Labrador', 'Thor', 'M', 36, 'G', 'Amigável', 'ADOTADO');

-- Inserindo adotantes
INSERT INTO ADOTANTE (Nome, Idade, Moradia, AreaUtil, ExperienciaPets, Criancas, OutrosAnimais) VALUES
('Ana Silva', 30, 'apto', 70, TRUE, FALSE, FALSE),
('Carlos Souza', 45, 'casa', 120, TRUE, TRUE, TRUE),
('Mariana Lima', 28, 'apto', 60, FALSE, TRUE, FALSE);

-- Inserindo histórico de eventos
INSERT INTO HISTORICO_EVENTOS (ID_Animal, Evento, Data_Evento) VALUES
(1, 'Entrada no abrigo', '2026-01-15'),
(2, 'Vacinação', '2026-01-20'),
(3, 'Adotado', '2026-02-01');

-- Inserindo reservas
INSERT INTO RESERVA (ID_Animal, ID_Adotante, Dt_Reserva, Dt_Expiracao) VALUES
(2, 1, '2026-02-02', '2026-02-09');

-- Inserindo notificações
INSERT INTO NOTIFICACAO (ID_Reserva, Mensagem, Dt_Notificacao) VALUES
(1, 'Sua reserva expira em 7 dias', '2026-02-02');

-- Inserindo estratégias de taxa
INSERT INTO ESTRATEGIA_TAXA (Nome, Descricao) VALUES
('Taxa Básica', 'Taxa padrão para adoção'),
('Taxa Reduzida', 'Taxa para animais idosos'),
('Isenção', 'Adoção sem custo');

-- Inserindo adoções
INSERT INTO ADOTACAO (ID_Animal, ID_Adotante, Dt_Adocao, Taxa, Contrato, ID_Estrategia) VALUES
(3, 2, '2026-02-01', 200.00, 'Contrato digital assinado', 1);

-- Inserindo devoluções
INSERT INTO DEVOLUCAO (ID_Animal, ID_Adotante, Dt_Devolucao, Motivo) VALUES
(3, 2, '2026-02-05', 'Mudança de cidade');

-- Inserindo lista de espera
INSERT INTO LISTA_ESPERA (ID_Animal, ID_Adotante, Pontuacao, Dt_Entrada) VALUES
(1, 3, 85, '2026-02-03');

-- Inserindo compatibilidade
INSERT INTO COMPATIBILIDADE (ID_Animal, ID_Adotante, Pontuacao, Dt_Calculo) VALUES
(1, 3, 90, '2026-02-03');

-- Inserindo reavaliações
INSERT INTO REAVALIACAO (ID_Animal, Dt_Reavaliacao, Resultado, Observacoes) VALUES
(1, '2026-02-04', 'DISPONIVEL', 'Animal saudável e apto para adoção');

-- Inserindo configurações
INSERT INTO CONFIGURACAO (Nome_Politica, Valor) VALUES
('PrazoReservaDias', '7'),
('TaxaPadrao', '200'),
('PermitirDevolucao', 'TRUE');

-- ===============================
-- Consultas (SELECT)
-- ===============================

-- Consulta 1: Listar animais com seus eventos
SELECT a.Nome AS Animal, h.Evento, h.Data_Evento
FROM ANIMAL a
JOIN HISTORICO_EVENTOS h ON a.ID = h.ID_Animal;

-- Consulta 2: Listar reservas com dados do adotante e animal
SELECT r.ID AS ReservaID, a.Nome AS Animal, ad.Nome AS Adotante, r.Dt_Reserva, r.Dt_Expiracao
FROM RESERVA r
JOIN ANIMAL a ON r.ID_Animal = a.ID
JOIN ADOTANTE ad ON r.ID_Adotante = ad.ID;

-- Consulta 3: Listar adoções com estratégia de taxa aplicada
SELECT adt.Nome AS Adotante, an.Nome AS Animal, e.Nome AS Estrategia, a.Taxa
FROM ADOTACAO a
JOIN ADOTANTE adt ON a.ID_Adotante = adt.ID
JOIN ANIMAL an ON a.ID_Animal = an.ID
JOIN ESTRATEGIA_TAXA e ON a.ID_Estrategia = e.ID;

-- Consulta 4: Listar todos os animais e suas reservas (LEFT JOIN)
SELECT an.Nome AS Animal, r.ID AS ReservaID, ad.Nome AS Adotante
FROM ANIMAL an
LEFT JOIN RESERVA r ON an.ID = r.ID_Animal
LEFT JOIN ADOTANTE ad ON r.ID_Adotante = ad.ID;

-- Consulta 5: Listar animais disponíveis para adoção
SELECT Nome, Especie, Raca, Porte, Temperamento
FROM ANIMAL
WHERE Status = 'DISPONIVEL';
