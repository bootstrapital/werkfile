# templates/auth.py
from fasthtml.common import *
from .base import BasePage
from .components import (
    Card, FormField, FormGrid, FormSection, 
    COMPONENT_STYLES
)

def render_login_form(error: str = None):
    """Render the login form"""
    form_content = Form(
        FormSection([
            FormField("email", "Email", field_type="email", required=True),
            FormField("password", "Password", field_type="password", required=True),
        ]),
        P(error, cls="error") if error else None,
        Div(
            Button("Log In", type="submit", cls="primary"),
            cls="grid"
        ),
        P(
            "Don't have an account? ",
            A("Sign up here", href="/signup"),
        ),
        action="/login",
        method="POST"
    )
    
    content = Div(
        H1("Log In", cls="text-center"),
        Card(form_content),
        COMPONENT_STYLES
    )
    
    return BasePage(content)

def render_signup_form(error: str = None):
    """Render the signup form"""
    form_content = Form(
        FormSection([
            FormGrid([
                FormField("email", "Email", field_type="email", required=True),
                FormField("username", "Username", required=True),
            ]),
            FormGrid([
                FormField("password", "Password", field_type="password", required=True),
                FormField("password_confirm", "Confirm Password", field_type="password", required=True),
            ]),
            FormField("personal_summary", "Personal Summary", field_type="textarea"),
        ]),
        P(error, cls="error") if error else None,
        Div(
            Button("Sign Up", type="submit", cls="primary"),
            cls="grid"
        ),
        P(
            "Already have an account? ",
            A("Log in here", href="/login"),
        ),
        action="/signup",
        method="POST"
    )
    
    content = Div(
        H1("Sign Up", cls="text-center"),
        Card(form_content),
        COMPONENT_STYLES
    )
    
    return BasePage(content)