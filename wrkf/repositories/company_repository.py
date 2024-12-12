# repositories/company_repository.py
from typing import List, Optional
from .base import BaseRepository
from database.connection import companies, CompanyDB

class CompanyRepository(BaseRepository[CompanyDB]):
    def __init__(self):
        super().__init__('companies')
    
    def find_by_name(self, name: str) -> List[CompanyDB]:
        return db.q(
            f"SELECT * FROM {companies} WHERE name LIKE ?",
            [f"%{name}%"]
        )
    
    def get_by_industry(self, industry: str) -> List[CompanyDB]:
        return db.q(
            f"SELECT * FROM {companies} WHERE industry = ?",
            [industry]
        )
    
    def get_industries(self) -> List[str]:
        return [
            row['industry'] 
            for row in db.q(f"SELECT DISTINCT industry FROM {companies}")
        ]