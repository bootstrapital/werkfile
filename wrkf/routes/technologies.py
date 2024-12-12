# routes/technologies.py
from fasthtml.common import *
from wrkf.repositories import technology_repo
from wrkf.templates.technology import render_technology_list, render_technology_form
from .base import BaseRouter

class TechnologyRouter(BaseRouter):
    def __init__(self, rt):
        self.register_routes(rt)
    
    def register_routes(self, rt):
        @rt("/technologies")
        def list_technologies():
            technologies = technology_repo.get_all()
            return self.render(render_technology_list, technologies=technologies)
        
        @rt("/technologies/new")
        def new_technology():
            return self.render(render_technology_form)
        
        @rt("/technologies/{technology_id}/edit")
        def edit_technology(technology_id: int):
            technology = technology_repo.get_by_id(technology_id)
            if not technology:
                return self.not_found("Technology not found")
            return self.render(render_technology_form, technology=technology)
        
        @rt("/technologies/save", methods=["POST"])
        def save_technology(
            name: str,
            category: str,
            technology_id: Optional[int] = None
        ):
            data = {"name": name, "category": category}
            
            if technology_id:
                technology_repo.update(technology_id, data)
            else:
                technology_repo.create(data)
            
            return self.redirect("/technologies")
        
        @rt("/technologies/{technology_id}/delete")
        def delete_technology(technology_id: int):
            technology_repo.delete(technology_id)
            return self.redirect("/technologies")