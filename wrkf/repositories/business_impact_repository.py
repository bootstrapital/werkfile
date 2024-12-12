# repositories/business_impact_repository.py
from typing import List, Dict, Any
from .base import BaseRepository
from database.connection import business_impacts, db

class BusinessImpactRepository(BaseRepository):
    def __init__(self):
        super().__init__('business_impacts')
    
    def get_by_experience(self, experience_id: int) -> List[Dict[str, Any]]:
        return db.q(f"""
            SELECT * FROM {business_impacts}
            WHERE experience_id = ?
            ORDER BY created_at DESC
        """, [experience_id])
    
    def bulk_create(self, experience_id: int, impacts: List[Dict[str, Any]]) -> None:
        for impact in impacts:
            impact['experience_id'] = experience_id
            self.create(impact)
    
    def update_for_experience(self, experience_id: int, impacts: List[Dict[str, Any]]) -> None:
        with db:
            self.table.delete(experience_id=experience_id)
            self.bulk_create(experience_id, impacts)