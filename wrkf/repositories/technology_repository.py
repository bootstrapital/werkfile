# repositories/technology_repository.py
from typing import List, Optional
from .base import BaseRepository
from database.connection import technologies, TechnologyDB

class TechnologyRepository(BaseRepository[TechnologyDB]):
    def __init__(self):
        super().__init__('technologies')
    
    def find_by_category(self, category: str) -> List[TechnologyDB]:
        return db.q(
            f"SELECT * FROM {technologies} WHERE category = ?",
            [category]
        )
    
    def get_categories(self) -> List[str]:
        return [
            row['category'] 
            for row in db.q(f"SELECT DISTINCT category FROM {technologies}")
        ]
    
    def get_by_experience(self, experience_id: int) -> List[dict]:
        return db.q("""
            SELECT t.*, et.proficiency_level
            FROM technologies t
            JOIN experience_technologies et ON t.technology_id = et.technology_id
            WHERE et.experience_id = ?
        """, [experience_id])