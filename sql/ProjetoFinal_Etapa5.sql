-- ============================================================
-- UNIVERSIDADE FEDERAL DO CARIRI - UFCA
-- CURSO DE TECNOLOGIA EM BANCO DE DADOS
--
-- PROJETO FINAL - Etapa 4: Views, Triggers e Procedure
-- TEMA 1: SISTEMA DE ADOÇÃO DE ANIMAIS
-- ALUNO: JOSE NATANIEL GOMES PEREIRA
-- ============================================================

-- ===============================
-- VIEW
-- ===============================
-- View para facilitar consulta de adoções com dados do adotante e animal
CREATE OR REPLACE VIEW vw_adocoes_detalhadas AS
SELECT a.ID AS AdocaoID,
       ad.Nome AS Adotante,
       an.Nome AS Animal,
       an.Especie,
       a.Dt_Adocao,
       a.Taxa,
       e.Nome AS Estrategia
FROM ADOTACAO a
JOIN ADOTANTE ad ON a.ID_Adotante = ad.ID
JOIN ANIMAL an ON a.ID_Animal = an.ID
JOIN ESTRATEGIA_TAXA e ON a.ID_Estrategia = e.ID;

-- ===============================
-- VIEW MATERIALIZADA
-- ===============================
-- View materializada para relatório de quantidade de animais por status
CREATE MATERIALIZED VIEW mv_animais_por_status AS
SELECT Status, COUNT(*) AS total
FROM ANIMAL
GROUP BY Status;

-- Para atualizar manualmente:
-- REFRESH MATERIALIZED VIEW mv_animais_por_status;

-- ===============================
-- TRIGGERS
-- ===============================

-- BEFORE Trigger: valida taxa de adoção (não pode ser negativa)
CREATE OR REPLACE FUNCTION fn_valida_taxa()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.Taxa < 0 THEN
        RAISE EXCEPTION 'Taxa de adoção não pode ser negativa';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_valida_taxa
BEFORE INSERT OR UPDATE ON ADOTACAO
FOR EACH ROW
EXECUTE FUNCTION fn_valida_taxa();

-- AFTER Trigger: registra log quando um animal é adotado
CREATE TABLE IF NOT EXISTS LOG_ADOCAO (
    ID SERIAL PRIMARY KEY,
    ID_Animal INT,
    Dt_Log TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Mensagem TEXT
);

CREATE OR REPLACE FUNCTION fn_log_adocao()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO LOG_ADOCAO (ID_Animal, Mensagem)
    VALUES (NEW.ID_Animal, 'Animal adotado com sucesso');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_adocao
AFTER INSERT ON ADOTACAO
FOR EACH ROW
EXECUTE FUNCTION fn_log_adocao();

-- ===============================
-- PROCEDURE
-- ===============================
-- Procedure para atualizar status de um animal
CREATE OR REPLACE PROCEDURE sp_atualiza_status_animal(
    p_id_animal INT,
    p_novo_status VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE ANIMAL
    SET Status = p_novo_status
    WHERE ID = p_id_animal;
END;
$$;

-- Exemplo de execução:
-- CALL sp_atualiza_status_animal(1, 'RESERVADO');

-- ============================================================
-- Fim do Script - Etapa 4
-- ============================================================
