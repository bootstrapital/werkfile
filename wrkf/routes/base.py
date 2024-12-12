# routes/base.py
from fasthtml.common import *
from templates.base import BasePage
from typing import Any, Optional

class BaseRouter:
    """Base class for route handlers with common utilities"""
    @staticmethod
    def redirect(path: str, status_code: int = 303) -> RedirectResponse:
        return RedirectResponse(path, status_code=status_code)
    
    @staticmethod
    def render(template: Any, **kwargs) -> Any:
        return BasePage(template(**kwargs) if callable(template) else template)
    
    @staticmethod
    def not_found(message: Optional[str] = None) -> Any:
        return BasePage(
            Section(
                H1("404 - Not Found"),
                P(message or "The requested resource was not found.")
            )
        )