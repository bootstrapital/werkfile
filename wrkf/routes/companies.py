# routes/companies.py
from fasthtml.common import *
from wrkf.repositories import company_repo
from wrkf.templates.company import render_company_list, render_company_form
from .base import BaseRouter

class CompanyRouter(BaseRouter):
    def __init__(self, rt):
        self.register_routes(rt)
    
    def register_routes(self, rt):
        @rt("/companies")
        def list_companies():
            companies = company_repo.get_all()
            return self.render(render_company_list, companies=companies)
        
        @rt("/companies/new")
        def new_company():
            return self.render(render_company_form)
        
        @rt("/companies/{company_id}/edit")
        def edit_company(company_id: int):
            company = company_repo.get_by_id(company_id)
            if not company:
                return self.not_found("Company not found")
            return self.render(render_company_form, company=company)
        
        @rt("/companies/save", methods=["POST"])
        def save_company(
            name: str,
            industry: str,
            website: str = '',
            headquarters_location: str = '',
            company_size_range: str = '',
            company_id: Optional[int] = None
        ):
            data = {
                "name": name,
                "industry": industry,
                "website": website,
                "headquarters_location": headquarters_location,
                "company_size_range": company_size_range
            }
            
            if company_id:
                company_repo.update(company_id, data)
            else:
                company_repo.create(data)
            
            return self.redirect("/companies")
        
        @rt("/companies/{company_id}/delete")
        def delete_company(company_id: int):
            company_repo.delete(company_id)
            return self.redirect("/companies")