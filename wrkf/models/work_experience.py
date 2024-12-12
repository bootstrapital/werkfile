from dataclasses import dataclass, field
from datetime import date
from typing import List, Optional
from .base import BaseModel

@dataclass
class WorkExperience(BaseModel):
    experience_id: Optional[int] = None
    user_id: int = 1
    company_id: int = None
    title: str = ''
    employment_type: str = ''
    start_date: Optional[date] = None
    end_date: Optional[date] = None
    is_current: bool = False
    department: str = ''
    location: str = ''
    responsibilities: List[str] = field(default_factory=list)
    technologies: List[dict] = field(default_factory=list)
    business_impacts: List[dict] = field(default_factory=list)
    company_name: str = ''