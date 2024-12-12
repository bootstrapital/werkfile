from dataclasses import dataclass, field
from typing import Optional
from datetime import datetime, timezone

@dataclass
class BaseModel:
    created_at: datetime = field(default_factory=lambda: datetime.now(timezone.utc))
    updated_at: Optional[datetime] = None