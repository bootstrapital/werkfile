# repositories/base.py
from typing import TypeVar, Generic, Optional, List, Dict, Any
from database.connection import db

T = TypeVar('T')

class BaseRepository(Generic[T]):
    def __init__(self, table_name: str):
        self.table = getattr(db.t, table_name)
        self.model = self.table.dataclass()
    
    def get_all(self) -> List[T]:
        return self.table()
    
    def get_by_id(self, id_val: int) -> Optional[T]:
        try:
            return self.table[id_val]
        except KeyError:
            return None
    
    def create(self, data: Dict[str, Any]) -> T:
        return self.table.insert(self.model(**data))
    
    def update(self, id_val: int, data: Dict[str, Any]) -> Optional[T]:
        data['id'] = id_val
        return self.table.update(self.model(**data))
    
    def delete(self, id_val: int) -> bool:
        try:
            self.table.delete(id_val)
            return True
        except KeyError:
            return False