# SISTEMA_DE_ADOTACAO_DE_ANIMAIS
Projeto Final Etapa 7 — ORM com SQLAlchemy e PostgreSQL

## 📂 Estrutura do Repositório

## 📌 Objetivo
Este projeto conecta uma aplicação Python ao banco PostgreSQL criado nas etapas anteriores.  
Utiliza o **ORM SQLAlchemy** para mapear tabelas em classes e executar operações no banco sem precisar escrever SQL manual.  
O foco é trabalhar com **mapeamento ORM, relacionamentos, operações CRUD e consultas com filtros e JOIN**.

---

## 📂 Estrutura do Repositório

```
SISTEMA-DE-ADOTACAO-DE-ANIMAIS/
│
├── src/                  # Código-fonte principal
│   ├── config.py         # Configuração da conexão com PostgreSQL
│   ├── models.py         # Classes ORM (Animal, Adotante, Reserva, Adocao, EstrategiaTaxa)
│   └── main.py           # Script principal com CRUD e relatórios
│
├── sql/                  # Scripts SQL atual e anteriores
│   └── script.sql        # Script DDL/DML resumido (CREATE TABLE + INSERTs)
│
├── docs/                 # Documentação e evidências
│   ├── README.md         # Explicação do projeto
│   └── evidencias/       # Prints de execução no terminal
│       ├── Banco_de_dados.png
│       ├── main.py.png
│       ├── Terminal_executado_1ª_parte.png
│       └── Terminal_executado_2ª_parte.png
│
└── requirements.txt      # Dependências do projeto
```

---

## ⚙️ Configuração

### Pré-requisitos
- Python 3.13 instalado  
- PostgreSQL instalado e rodando  
- Banco de dados criado conforme etapas anteriores (`projeto_final2e3`)  
- Script DDL/DML das etapas anteriores já aplicado  

### Dependências
Instale as bibliotecas necessárias com:

```bash
pip install -r requirements.txt
```

*(requirements.txt inclui: sqlalchemy, psycopg2-binary, tabulate)*

### Conexão
No arquivo `src/config.py`:

```python
DATABASE_URL = "postgresql://postgres:1234@localhost:5432/projeto_final2e3"
```

---

## ▶️ Execução
Dentro da pasta do projeto:

```bash
python src/main.py
```

---

## 🔧 Funcionalidades

### Parte 1 — Configuração
- Conexão com PostgreSQL via SQLAlchemy.

### Parte 2 — Mapeamento ORM
- Classes: `Animal`, `Adotante`, `Reserva`, `Adocao`, `EstrategiaTaxa`.  
- Relacionamentos 1–N implementados entre entidades.

### Parte 3 — CRUD
- **CREATE**: inserção de 3 registros em cada tabela.  
- **READ**: listagem de animais ordenados por nome.  
- **UPDATE**: alteração de status (Thor → ADOTADO).  
- **DELETE (soft delete)**: simulação de remoção (Rex → RESERVADO).  

### Parte 4 — Consultas
- Reservas com dados do adotante e animal (JOIN).  
- Adoções filtradas por taxa > 100 (JOIN + filtro).  
- Animais disponíveis ordenados por porte (filtro + ordenação).  

---

## 📊 Saída (relatório)

Execução do programa `main.py` no terminal:

```
🗑️ Banco zerado antes da execução!
✅ Inserção concluída!

✏️ Atualizado: Thor agora está ADOTADO

🗑️ Simulado como removido (status alterado): Rex

=== RELATÓRIO FINAL ===

Animais:
+------+--------+-----------+----------+---------+----------------+------------+
|   ID | Nome   | Espécie   | Raça     | Porte   | Temperamento   | Status     |
+======+========+===========+==========+=========+================+============+
|    1 | Luna   | Gato      | Siamês   | P       | Curiosa        | DISPONIVEL |
+------+--------+-----------+----------+---------+----------------+------------+
|    2 | Rex    | Cachorro  | SRD      | M       | Brincalhão     | RESERVADO  |
+------+--------+-----------+----------+---------+----------------+------------+
|    3 | Thor   | Cachorro  | Labrador | G       | Amigável       | ADOTADO    |
+------+--------+-----------+----------+---------+----------------+------------+

Adotantes:
+------+--------------+
|   ID | Nome         |
+======+==============+
|    1 | Ana Silva    |
+------+--------------+
|    2 | Carlos Souza |
+------+--------------+
|    3 | Mariana Lima |
+------+--------------+

Estratégias de taxa:
+------+---------------+
|   ID | Nome          |
+======+===============+
|    3 | Isenção       |
+------+---------------+
|    1 | Taxa Fixa     |
+------+---------------+
|    2 | Taxa Variável |
+------+---------------+

Reservas:
+------+----------+-----------+--------------+----------------+------------+
|   ID | Animal   | Espécie   | Adotante     | Data Reserva   | Expira     |
+======+==========+===========+==============+================+============+
|    1 | Luna     | Gato      | Ana Silva    | 2026-03-01     | 2026-03-10 |
+------+----------+-----------+--------------+----------------+------------+
|    2 | Rex      | Cachorro  | Carlos Souza | 2026-03-02     | 2026-03-12 |
+------+----------+-----------+--------------+----------------+------------+
|    3 | Thor     | Cachorro  | Mariana Lima | 2026-03-03     | 2026-03-13 |
+------+----------+-----------+--------------+----------------+------------+

Adoções:
+------+--------------+----------+---------------+--------+
|   ID | Adotante     | Animal   | Estratégia    |   Taxa |
+======+==============+==========+===============+========+
|    1 | Ana Silva    | Thor     | Taxa Fixa     |    150 |
+------+--------------+----------+---------------+--------+
|    2 | Carlos Souza | Rex      | Taxa Variável |    200 |
+------+--------------+----------+---------------+--------+
|    3 | Mariana Lima | Luna     | Isenção       |      0 |
+------+--------------+----------+---------------+--------+
```

---

## 📷 Evidências

### Banco de Dados
![Banco de Dados](docs/evidencias/Banco_de_dados.png)

### Código main.py em execução
![main.py](docs/evidencias/main.py.png)

### Terminal executado - 1ª parte
![Terminal executado 1ª parte](docs/evidencias/Terminal_executado_1ª_parte.png)

### Terminal executado - 2ª parte
![Terminal executado 2ª parte](docs/evidencias/Terminal_executado_2ª_parte.png)

---

## 📑 Entregáveis
- Código-fonte (`src/config.py`, `src/models.py`, `src/main.py`).  
- Script SQL (`sql/script.sql`).  
- Documentação (`docs/README.md`).  
- Evidências (`docs/evidencias/`).  
- Arquivo `requirements.txt`.
- ```
