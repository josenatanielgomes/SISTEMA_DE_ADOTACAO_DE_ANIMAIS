from sqlalchemy import Column, Integer, String, ForeignKey, Date
from sqlalchemy.orm import relationship, declarative_base

Base = declarative_base()

class Animal(Base):
    __tablename__ = "animal"
    id = Column(Integer, primary_key=True)
    nome = Column(String)
    especie = Column(String)
    raca = Column(String)
    porte = Column(String)
    temperamento = Column(String)
    status = Column(String)

    reservas = relationship("Reserva", back_populates="animal")
    adocoes = relationship("Adocao", back_populates="animal")

class Adotante(Base):
    __tablename__ = "adotante"
    id = Column(Integer, primary_key=True)
    nome = Column(String)

    reservas = relationship("Reserva", back_populates="adotante")
    adocoes = relationship("Adocao", back_populates="adotante")

class Reserva(Base):
    __tablename__ = "reserva"
    id = Column(Integer, primary_key=True)
    id_animal = Column(Integer, ForeignKey("animal.id"))
    id_adotante = Column(Integer, ForeignKey("adotante.id"))
    dt_reserva = Column(Date)
    dt_expiracao = Column(Date)

    animal = relationship("Animal", back_populates="reservas")
    adotante = relationship("Adotante", back_populates="reservas")

class Adocao(Base):
    __tablename__ = "adocao"
    id = Column(Integer, primary_key=True)
    id_animal = Column(Integer, ForeignKey("animal.id"))
    id_adotante = Column(Integer, ForeignKey("adotante.id"))
    id_estrategia = Column(Integer, ForeignKey("estrategia_taxa.id"))
    taxa = Column(Integer)

    animal = relationship("Animal", back_populates="adocoes")
    adotante = relationship("Adotante", back_populates="adocoes")
    estrategia = relationship("EstrategiaTaxa", back_populates="adocoes")

class EstrategiaTaxa(Base):
    __tablename__ = "estrategia_taxa"
    id = Column(Integer, primary_key=True)
    nome = Column(String)

    adocoes = relationship("Adocao", back_populates="estrategia")
