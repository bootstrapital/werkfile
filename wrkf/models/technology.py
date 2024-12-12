from dataclasses import dataclass
from datetime import datetime
from typing import Optional, List
from .base import BaseModel

@dataclass
class Technology(BaseModel):
    """Technology model representing a programming language, framework, or tool"""
    technology_id: Optional[int] = None
    name: str = ''
    category: Optional[str] = None
    
    # Class-level constants for categories
    CATEGORIES = [
        'Programming Language',
        'Framework',
        'Database',
        'Tool',
        'Platform',
        'Cloud Service',
        'Library',
        'Other'
    ]

@dataclass
class ExperienceTechnology(BaseModel):
    """Junction model for many-to-many relationship between experiences and technologies"""
    experience_id: int = None
    technology_id: int = None
    proficiency_level: str = ''
    
    # Class-level constants for proficiency levels
    PROFICIENCY_LEVELS = [
        'Beginner',
        'Intermediate',
        'Advanced',
        'Expert'
    ]