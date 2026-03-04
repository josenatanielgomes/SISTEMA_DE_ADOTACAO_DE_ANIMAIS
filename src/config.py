from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# Ajuste a senha conforme seu PostgreSQL
DATABASE_URL = "postgresql://postgres:1234@localhost:5432/projeto_final2e3"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
