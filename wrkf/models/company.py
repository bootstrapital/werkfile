from dataclasses import dataclass
from .base import BaseModel

@dataclass
class Company(BaseModel):
    company_id: int = None
    name: str = ''
    industry: str = ''
    website: str = ''
    headquarters_location: str = ''
    company_size_range: str = ''