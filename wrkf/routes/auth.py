# routes/auth.py
from fasthtml.common import *
from repositories import user_repo
from templates.auth import render_login_form, render_signup_form
from utils.security import verify_password
from .base import BaseRouter

class AuthRouter(BaseRouter):
    def __init__(self, rt):
        self.register_routes(rt)
    
    def register_routes(self, rt):
        @rt("/login")
        def login():
            return self.render(render_login_form)
        
        @rt("/signup")
        def signup():
            return self.render(render_signup_form)
        
        @rt("/login", methods=["POST"])
        def process_login(email: str, password: str):
            user = user_repo.get_by_email(email)
            
            if not user or not verify_password(password, user.password_hash):
                return self.render(
                    render_login_form,
                    error="Invalid email or password"
                )
            
            if not user.is_active:
                return self.render(
                    render_login_form,
                    error="Account is inactive"
                )
            
            # Update last login time
            user_repo.update_last_login(user.id)
            
            # Set session
            self.session['user_id'] = user.id
            
            return self.redirect("/dashboard")
        
        @rt("/signup", methods=["POST"])
        def process_signup(
            email: str,
            username: str,
            password: str,
            password_confirm: str,
            personal_summary: str = ''
        ):
            # Validate passwords match
            if password != password_confirm:
                return self.render(
                    render_signup_form,
                    error="Passwords do not match"
                )
            
            # Check if email or username already exists
            if user_repo.get_by_email(email):
                return self.render(
                    render_signup_form,
                    error="Email already registered"
                )
            
            if user_repo.get_by_username(username):
                return self.render(
                    render_signup_form,
                    error="Username already taken"
                )
            
            # Create user
            user = user_repo.create({
                "email": email,
                "username": username,
                "password": password,
                "personal_summary": personal_summary
            })
            
            # Set session
            self.session['user_id'] = user.id
            
            return self.redirect("/dashboard")
        
        @rt("/logout")
        def logout():
            self.session.clear()
            return self.redirect("/login")