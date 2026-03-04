from config import SessionLocal, engine
from models import Base, Animal, Reserva, Adocao, EstrategiaTaxa, Adotante
from datetime import date
from sqlalchemy import text
from tabulate import tabulate

# Criar tabelas que ainda não existirem
Base.metadata.create_all(bind=engine)

# Criar sessão
session = SessionLocal()

# -------------------------------
# Zerar tabelas antes de rodar
# -------------------------------
session.execute(text("TRUNCATE animal, adotante, estrategia_taxa, reserva, adocao RESTART IDENTITY CASCADE;"))
session.commit()
print("🗑️ Banco zerado antes da execução!")

# -------------------------------
# Inserções iniciais (3 de cada)
# -------------------------------

# Animais
session.add_all([
    Animal(nome="Luna", especie="Gato", raca="Siamês", porte="P", temperamento="Curiosa", status="DISPONIVEL"),
    Animal(nome="Rex", especie="Cachorro", raca="SRD", porte="M", temperamento="Brincalhão", status="DISPONIVEL"),
    Animal(nome="Thor", especie="Cachorro", raca="Labrador", porte="G", temperamento="Amigável", status="DISPONIVEL")
])

# Adotantes
session.add_all([
    Adotante(nome="Ana Silva"),
    Adotante(nome="Carlos Souza"),
    Adotante(nome="Mariana Lima")
])

# Estratégias de taxa
session.add_all([
    EstrategiaTaxa(nome="Taxa Fixa"),
    EstrategiaTaxa(nome="Taxa Variável"),
    EstrategiaTaxa(nome="Isenção")
])

session.commit()
print("✅ Inserção concluída!")

# -------------------------------
# UPDATE e DELETE (soft delete)
# -------------------------------
thor = session.query(Animal).filter_by(nome="Thor").first()
if thor:
    thor.status = "ADOTADO"
    session.commit()
    print(f"\n✏️ Atualizado: {thor.nome} agora está {thor.status}")

rex = session.query(Animal).filter_by(nome="Rex").first()
if rex:
    rex.status = "RESERVADO"
    session.commit()
    print(f"\n🗑️ Simulado como removido (status alterado): {rex.nome}")

# -------------------------------
# Inserção de reservas e adoções
# -------------------------------
luna = session.query(Animal).filter_by(nome="Luna").first()
ana = session.query(Adotante).filter_by(nome="Ana Silva").first()
carlos = session.query(Adotante).filter_by(nome="Carlos Souza").first()
mariana = session.query(Adotante).filter_by(nome="Mariana Lima").first()
taxa_fixa = session.query(EstrategiaTaxa).filter_by(nome="Taxa Fixa").first()
taxa_var = session.query(EstrategiaTaxa).filter_by(nome="Taxa Variável").first()
isen = session.query(EstrategiaTaxa).filter_by(nome="Isenção").first()

session.add_all([
    Reserva(id_animal=luna.id, id_adotante=ana.id, dt_reserva=date(2026,3,1), dt_expiracao=date(2026,3,10)),
    Reserva(id_animal=rex.id, id_adotante=carlos.id, dt_reserva=date(2026,3,2), dt_expiracao=date(2026,3,12)),
    Reserva(id_animal=thor.id, id_adotante=mariana.id, dt_reserva=date(2026,3,3), dt_expiracao=date(2026,3,13))
])

session.add_all([
    Adocao(id_animal=thor.id, id_adotante=ana.id, id_estrategia=taxa_fixa.id, taxa=150),
    Adocao(id_animal=rex.id, id_adotante=carlos.id, id_estrategia=taxa_var.id, taxa=200),
    Adocao(id_animal=luna.id, id_adotante=mariana.id, id_estrategia=isen.id, taxa=0)
])

session.commit()

# -------------------------------
# RELATÓRIO FINAL EM TABELAS
# -------------------------------
print("\n=== RELATÓRIO FINAL ===")

# Animais
animais = session.query(Animal).order_by(Animal.nome).all()
print("\nAnimais:")
print(tabulate([(a.id, a.nome, a.especie, a.raca, a.porte, a.temperamento, a.status) for a in animais],
               headers=["ID","Nome","Espécie","Raça","Porte","Temperamento","Status"], tablefmt="grid"))

# Adotantes
adotantes = session.query(Adotante).order_by(Adotante.nome).all()
print("\nAdotantes:")
print(tabulate([(ad.id, ad.nome) for ad in adotantes],
               headers=["ID","Nome"], tablefmt="grid"))

# Estratégias de taxa
estrategias = session.query(EstrategiaTaxa).order_by(EstrategiaTaxa.nome).all()
print("\nEstratégias de taxa:")
print(tabulate([(e.id, e.nome) for e in estrategias],
               headers=["ID","Nome"], tablefmt="grid"))

# Reservas
reservas = session.query(Reserva).join(Animal).join(Adotante).all()
print("\nReservas:")
print(tabulate([(r.id, r.animal.nome, r.animal.especie, r.adotante.nome, r.dt_reserva, r.dt_expiracao) for r in reservas],
               headers=["ID","Animal","Espécie","Adotante","Data Reserva","Expira"], tablefmt="grid"))

# Adoções
adocoes = session.query(Adocao).join(Animal).join(Adotante).join(EstrategiaTaxa).all()
print("\nAdoções:")
print(tabulate([(a.id, a.adotante.nome, a.animal.nome, a.estrategia.nome, a.taxa) for a in adocoes],
               headers=["ID","Adotante","Animal","Estratégia","Taxa"], tablefmt="grid"))
