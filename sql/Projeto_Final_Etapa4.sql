-- ============================================================
-- UNIVERSIDADE FEDERAL DO CARIRI - UFCA
-- CURSO DE TECNOLOGIA EM BANCO DE DADOS
--
-- PROJETO FINAL - Etapa 4: Constraints e Regras de Integridade
-- TEMA 1: SISTEMA DE ADOÇÃO DE ANIMAIS
-- ALUNO: JOSE NATANIEL GOMES PEREIRA
-- ============================================================

-- =========================
-- CHECK Constraints
-- =========================

-- CHECK para impedir taxa negativa na adoção
ALTER TABLE ADOTACAO
ADD CONSTRAINT ck_taxa CHECK (Taxa >= 0);

-- CHECK para validar que a área útil da moradia seja positiva
ALTER TABLE ADOTANTE
ADD CONSTRAINT ck_area_util CHECK (AreaUtil >= 0);

-- =========================
-- UNIQUE Constraints
-- =========================

-- UNIQUE para garantir que o nome da política de configuração não se repita
ALTER TABLE CONFIGURACAO
ADD CONSTRAINT uq_nome_politica UNIQUE (Nome_Politica);

-- =========================
-- DEFAULT Constraints
-- =========================

-- DEFAULT para definir data de reserva como a data atual
ALTER TABLE RESERVA
ALTER COLUMN Dt_Reserva SET DEFAULT CURRENT_DATE;

-- DEFAULT para definir data de notificação como a data atual
ALTER TABLE NOTIFICACAO
ALTER COLUMN Dt_Notificacao SET DEFAULT CURRENT_DATE;

-- =========================
-- Regras ON DELETE / ON UPDATE
-- =========================

-- Nova FK em DEVOLUCAO: se um adotante for excluído, a devolução é mantida com adotante NULL
ALTER TABLE DEVOLUCAO
ADD CONSTRAINT fk_devolucao_adotante FOREIGN KEY (ID_Adotante)
REFERENCES ADOTANTE(ID)
ON DELETE SET NULL
ON UPDATE CASCADE;

-- Nova FK em ADOTACAO: se uma estratégia de taxa for excluída, a adoção é mantida com estratégia NULL
ALTER TABLE ADOTACAO
ADD CONSTRAINT fk_adocao_estrategia FOREIGN KEY (ID_Estrategia)
REFERENCES ESTRATEGIA_TAXA(ID)
ON DELETE SET NULL
ON UPDATE CASCADE;

-- ============================================================
-- Fim do Script - Etapa 4
-- ============================================================
