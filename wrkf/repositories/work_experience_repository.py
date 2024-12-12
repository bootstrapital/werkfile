# repositories/work_experience_repository.py
from typing import List, Dict, Any, Optional
from .base import BaseRepository
from wrkf.database.connection import (
    db, work_experiences, WorkExperienceDB
)
from .responsibility_repository import ResponsibilityRepository
from .technology_repository import TechnologyRepository
from .business_impact_repository import BusinessImpactRepository

class WorkExperienceRepository(BaseRepository[WorkExperienceDB]):
    def __init__(self):
        super().__init__('work_experiences')
        self.responsibility_repo = ResponsibilityRepository()
        self.technology_repo = TechnologyRepository()
        self.business_impact_repo = BusinessImpactRepository()
    
    def get_all_with_details(self) -> List[Dict[str, Any]]:
        return db.q("""
            SELECT 
                we.*, 
                c.name as company_name,
                GROUP_CONCAT(r.description, '|') as responsibilities,
                GROUP_CONCAT(
                    t.name || ':' || et.proficiency_level, '|'
                ) as technologies
            FROM work_experiences we
            LEFT JOIN companies c ON we.company_id = c.company_id
            LEFT JOIN responsibilities r ON we.experience_id = r.experience_id
            LEFT JOIN experience_technologies et 
                ON we.experience_id = et.experience_id
            LEFT JOIN technologies t ON et.technology_id = t.technology_id
            GROUP BY we.experience_id
            ORDER BY we.start_date DESC
        """)
    
    def get_by_id_with_details(self, experience_id: int) -> Optional[Dict[str, Any]]:
        results = db.q("""
            SELECT 
                we.*, 
                c.name as company_name
            FROM work_experiences we
            LEFT JOIN companies c ON we.company_id = c.company_id
            WHERE we.experience_id = ?
        """, [experience_id])
        
        if not results:
            return None
            
        experience = dict(results[0])
        experience['responsibilities'] = self.responsibility_repo.get_by_experience(experience_id)
        experience['technologies'] = self.technology_repo.get_by_experience(experience_id)
        experience['business_impacts'] = self.business_impact_repo.get_by_experience(experience_id)
        
        return experience
    
    def create_with_relations(self, data: Dict[str, Any]) -> WorkExperienceDB:
        with db:  # Use fastlite's transaction context
            # Create main record
            experience = self.create(data)
            
            # Create related records
            if 'responsibilities' in data:
                self.responsibility_repo.bulk_create(
                    experience.experience_id,
                    data['responsibilities']
                )
            
            if 'technologies' in data:
                for tech in data['technologies']:
                    db.t.experience_technologies.insert({
                        'experience_id': experience.experience_id,
                        'technology_id': tech['id'],
                        'proficiency_level': tech['level']
                    })
            
            if 'business_impacts' in data:
                self.business_impact_repo.bulk_create(
                    experience.experience_id,
                    data['business_impacts']
                )
            
            return experience
    
    def update_with_relations(self, experience_id: int, data: Dict[str, Any]) -> Optional[WorkExperienceDB]:
        with db:
            # Update main record
            experience = self.update(experience_id, data)
            if not experience:
                return None
            
            # Update related records
            if 'responsibilities' in data:
                self.responsibility_repo.update_for_experience(
                    experience_id,
                    data['responsibilities']
                )
            
            if 'technologies' in data:
                db.t.experience_technologies.delete(experience_id=experience_id)
                for tech in data['technologies']:
                    db.t.experience_technologies.insert({
                        'experience_id': experience_id,
                        'technology_id': tech['id'],
                        'proficiency_level': tech['level']
                    })
            
            if 'business_impacts' in data:
                self.business_impact_repo.update_for_experience(
                    experience_id,
                    data['business_impacts']
                )
            
            return experience