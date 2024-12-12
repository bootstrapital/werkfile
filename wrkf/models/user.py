# models/user.py
from dataclasses import dataclass
from datetime import datetime
from typing import Optional

@dataclass
class User:
    id: Optional[int]
    email: str
    username: str
    password_hash: str
    created_at: datetime
    last_login: Optional[datetime]
    is_active: bool
    personal_summary: Optional[str]