# models/__init__.py
from datetime import datetime
from typing import List, Optional, Dict, Any
from dataclasses import dataclass, field

# Import all models
from .base import BaseModel
from .company import Company
from .technology import Technology, ExperienceTechnology
from .work_experience import (
    WorkExperience,
    Responsibility,
    BusinessImpact
)
from .user import User
# from .education import Education
# from .certification import Certification

# Define what should be available when importing from models
__all__ = [
    # Base
    'BaseModel',
    
    # Main models
    'User',
    'Company',
    'Technology',
    'WorkExperience',
    
    # Junction/Related models
    'ExperienceTechnology',
    'Responsibility',
    'BusinessImpact',
    # 'Education',
    # 'Certification',
    
    # Type hints
    'List', 'Optional', 'Dict', 'Any',
    'datetime', 'field'
]

# Version info
__version__ = '0.1.0'

# Optional: Add some helper functions that work with multiple models
def create_werk_file(user: User) -> Dict[str, Any]:
    """
    Creates a complete werk file representation for a user,
    combining all relevant models into a single structure
    """
    return {
        'user': user,
        'experiences': WorkExperience.get_all_for_user(user.user_id),
        'education': Education.get_all_for_user(user.user_id),
        'certifications': Certification.get_all_for_user(user.user_id)
    }

def validate_model_relationships(model_instance: BaseModel) -> List[str]:
    """
    Validates relationships between models
    Returns list of validation errors if any
    """
    errors = []
    # Add validation logic here
    return errors

# Optional: Add model-specific exceptions
class ModelValidationError(Exception):
    """Raised when model validation fails"""
    pass

class RelationshipError(Exception):
    """Raised when there's an issue with model relationships"""
    pass

# Optional: Add model constants
MODEL_STATUS = {
    'ACTIVE': 'active',
    'INACTIVE': 'inactive',
    'DELETED': 'deleted'
}

EMPLOYMENT_TYPES = [
    'FULL_TIME',
    'PART_TIME',
    'CONTRACT',
    'INTERNSHIP',
    'FREELANCE'
]

# Optional: Add model metadata
MODEL_METADATA = {
    'WorkExperience': {
        'searchable_fields': ['title', 'department', 'location'],
        'required_fields': ['title', 'company_id', 'start_date'],
        'related_models': ['Company', 'Technology', 'Responsibility']
    },
    'Company': {
        'searchable_fields': ['name', 'industry'],
        'required_fields': ['name'],
        'related_models': ['WorkExperience']
    },
    'Technology': {
        'searchable_fields': ['name', 'category'],
        'required_fields': ['name'],
        'related_models': ['WorkExperience']
    }
}

# Optional: Add model initialization hooks
def initialize_models():
    """
    Perform any necessary model initialization
    This could include setting up indexes, validating schemas, etc.
    """
    pass

# Optional: Add model utilities
def serialize_model(model: BaseModel) -> Dict[str, Any]:
    """Convert any model instance to a dictionary"""
    return {
        key: getattr(model, key)
        for key in model.__dataclass_fields__
        if hasattr(model, key)
    }

def deserialize_model(model_class: type, data: Dict[str, Any]) -> BaseModel:
    """Create a model instance from a dictionary"""
    return model_class(**{
        k: v for k, v in data.items()
        if k in model_class.__dataclass_fields__
    })