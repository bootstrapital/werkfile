# repositories/responsibility_repository.py
from typing import List
from .base import BaseRepository
from wrkf.database.connection import responsibilities, db

class ResponsibilityRepository(BaseRepository):
    def __init__(self):
        super().__init__('responsibilities')
    
    def get_by_experience(self, experience_id: int) -> List[str]:
        return [
            row['description'] 
            for row in db.q(
                f"SELECT description FROM {responsibilities} WHERE experience_id = ?",
                [experience_id]
            )
        ]
    
    def bulk_create(self, experience_id: int, descriptions: List[str]) -> None:
        for desc in descriptions:
            self.create({
                'experience_id': experience_id,
                'description': desc
            })
    
    def update_for_experience(self, experience_id: int, descriptions: List[str]) -> None:
        with db:  # Use fastlite's transaction context
            self.table.delete(experience_id=experience_id)
            self.bulk_create(experience_id, descriptions)