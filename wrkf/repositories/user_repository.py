# repositories/user_repo.py
from datetime import datetime
from typing import Optional, List

from fastlite import *

from .base import BaseRepository
from database.connection import users, UserDB
from models.user import User
from utils.security import hash_password


class UserRepository(BaseRepository[UserDB]):
    def __init__(self):
        super().__init__('users')

    def create(self, data: dict) -> User:
        # Prepare user data
        user_data = {
            "email": data['email'],
            "username": data['username'],
            "password_hash": hash_password(data['password']),
            "personal_summary": data.get('personal_summary'),
            "created_at": datetime.now(),
            "is_active": True
        }
        
        # Insert and return the created user
        return db.insert(user_data)

    def get_by_id(self, user_id: int) -> Optional[User]:
        try:
            return self.table[user_id]
        except NotFoundError:
            return None

    def get_by_email(self, email: str) -> Optional[User]:
        # Set extra filter for email
        self.table.xtra(email=email)
        results = self.table(limit=1)
        return results[0] if results else None

    def get_by_username(self, username: str) -> Optional[User]:
        # Set extra filter for username
        self.table.xtra(username=username)
        results = self.table(limit=1)
        return results[0] if results else None

    def update_last_login(self, user_id: int):
        user = self.get_by_id(user_id)
        if user:
            user_dict = {
                "user_id": user_id,
                "last_login": datetime.now()
            }
            self.table.update(user_dict)

    def update(self, user_id: int, data: dict):
        user = self.get_by_id(user_id)
        if user:
            update_data = {
                "user_id": user_id,
                **data
            }
            return self.table.update(update_data)
        return None

    def delete(self, user_id: int):
        self.table.delete(user_id)

    def get_all(self) -> List[User]:
        return self.table()
