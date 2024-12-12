# repositories/__init__.py
from .work_experience_repository import WorkExperienceRepository
from .company_repository import CompanyRepository
from .technology_repository import TechnologyRepository
from .responsibility_repository import ResponsibilityRepository
from .business_impact_repository import BusinessImpactRepository

# Create singleton instances
work_experience_repo = WorkExperienceRepository()
company_repo = CompanyRepository()
technology_repo = TechnologyRepository()
responsibility_repo = ResponsibilityRepository()
business_impact_repo = BusinessImpactRepository()

__all__ = [
    'work_experience_repo',
    'company_repo',
    'technology_repo',
    'responsibility_repo',
    'business_impact_repo'
]