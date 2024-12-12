# routes/work_experiences.py
from fasthtml.common import *
from typing import Optional
from repositories import work_experience_repo, company_repo, technology_repo
from templates.work_experience import (
    render_experience_list,
    render_experience_form,
    render_experience_detail
)
from .base import BaseRouter

class WorkExperienceRouter(BaseRouter):
    def __init__(self, rt):
        self.register_routes(rt)
    
    def register_routes(self, rt):
        # List view
        @rt("/")
        def list_experiences():
            experiences = work_experience_repo.get_all_with_details()
            return self.render(render_experience_list, experiences=experiences)
        
        # Detail view
        @rt("/experiences/{experience_id}")
        def get_experience(experience_id: int):
            experience = work_experience_repo.get_by_id_with_details(experience_id)
            if not experience:
                return self.not_found("Experience not found")
            return self.render(render_experience_detail, experience=experience)
        
        # Create form
        @rt("/experiences/new")
        def new_experience():
            companies = company_repo.get_all()
            technologies = technology_repo.get_all()
            return self.render(
                render_experience_form,
                companies=companies,
                technologies=technologies
            )
        
        # Edit form
        @rt("/experiences/{experience_id}/edit")
        def edit_experience(experience_id: int):
            experience = work_experience_repo.get_by_id_with_details(experience_id)
            if not experience:
                return self.not_found("Experience not found")
            
            companies = company_repo.get_all()
            technologies = technology_repo.get_all()
            return self.render(
                render_experience_form,
                experience=experience,
                companies=companies,
                technologies=technologies
            )
        
        # Create/Update handler
        @rt("/experiences/save", methods=["POST"])
        def save_experience(
            title: str,
            company_id: int,
            employment_type: str,
            start_date: str,
            department: str = '',
            location: str = '',
            end_date: Optional[str] = None,
            is_current: bool = False,
            responsibilities: Optional[str] = None,
            experience_id: Optional[int] = None,
            **tech_levels  # Captures all tech_* form fields
        ):
            # Prepare data
            data = {
                "title": title,
                "company_id": company_id,
                "employment_type": employment_type,
                "start_date": start_date,
                "end_date": None if is_current else end_date,
                "is_current": is_current,
                "department": department,
                "location": location,
                "responsibilities": responsibilities.split('\n') if responsibilities else [],
                "technologies": [
                    {"id": int(k.split('_')[1]), "level": v}
                    for k, v in tech_levels.items()
                    if k.startswith('tech_') and v
                ]
            }
            
            if experience_id:
                work_experience_repo.update_with_relations(experience_id, data)
            else:
                work_experience_repo.create_with_relations(data)
            
            return self.redirect("/")
        
        # Delete handler
        @rt("/experiences/{experience_id}/delete")
        def delete_experience(experience_id: int):
            work_experience_repo.delete(experience_id)
            return self.redirect("/")