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

@dataclass
class Responsibility(BaseModel):
    """Model representing a job responsibility"""
    responsibility_id: Optional[int] = None
    experience_id: Optional[int] = None
    description: str = ''
    tags: str = ''  # Comma-separated tags for search optimization
    
    @property
    def tag_list(self) -> List[str]:
        """Convert comma-separated tags string to list"""
        return [tag.strip() for tag in self.tags.split(',') if tag.strip()] if self.tags else []
    
    @classmethod
    def from_description(cls, experience_id: int, description: str, tags: str = ''):
        """Factory method to create a Responsibility from description"""
        return cls(
            experience_id=experience_id,
            description=description.strip(),
            tags=tags.strip()
        )

@dataclass
class BusinessImpact(BaseModel):
    """Model representing a quantifiable business impact"""
    impact_id: Optional[int] = None
    experience_id: Optional[int] = None
    metric_description: str = ''
    metric_value: Optional[str] = None
    metric_type: Optional[str] = None
    
    # Class-level constants for metric types
    METRIC_TYPES = [
        'PERCENTAGE',
        'CURRENCY',
        'QUANTITY',
        'TIME',
        'COST_SAVING',
        'REVENUE',
        'EFFICIENCY',
        'OTHER'
    ]
    
    def __post_init__(self):
        """Validate metric type after initialization"""
        if self.metric_type and self.metric_type.upper() not in self.METRIC_TYPES:
            raise ValueError(f"Invalid metric type. Must be one of: {', '.join(self.METRIC_TYPES)}")
    
    @classmethod
    def create_percentage_impact(cls, experience_id: int, description: str, value: float):
        """Factory method for percentage-based impacts"""
        return cls(
            experience_id=experience_id,
            metric_description=description,
            metric_value=f"{value:.1f}%",
            metric_type='PERCENTAGE'
        )
    
    @classmethod
    def create_currency_impact(cls, experience_id: int, description: str, amount: float, currency: str = 'USD'):
        """Factory method for currency-based impacts"""
        return cls(
            experience_id=experience_id,
            metric_description=description,
            metric_value=f"{currency} {amount:,.2f}",
            metric_type='CURRENCY'
        )
    
    @classmethod
    def create_quantity_impact(cls, experience_id: int, description: str, quantity: int, unit: str = ''):
        """Factory method for quantity-based impacts"""
        return cls(
            experience_id=experience_id,
            metric_description=description,
            metric_value=f"{quantity:,}{f' {unit}' if unit else ''}",
            metric_type='QUANTITY'
        )