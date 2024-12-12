# routes/__init__.py
from .work_experiences import WorkExperienceRouter
from .companies import CompanyRouter
from .technologies import TechnologyRouter

def register_routes(rt):
    """Register all routes with the application"""
    WorkExperienceRouter(rt)
    CompanyRouter(rt)
    TechnologyRouter(rt)