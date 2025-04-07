# werkfile/werkfile/__init__.py - Application Factory
import os
from flask import Flask
from dotenv import load_dotenv
# Import Kinde and Xata clients here when implemented

load_dotenv() # Load environment variables from .env

def create_app(config_object=None):
    """Application factory pattern"""
    app = Flask(__name__, instance_relative_config=True)

    # Load default config or from object
    # app.config.from_object('config.DefaultConfig')
    app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'default-fallback-secret-key')
    # Add other configurations (Kinde, Xata) here

    # Initialize extensions (Kinde, Xata) here
    # Example: kinde_client.init_app(app)
    # Example: xata_client = XataClient(...)

    with app.app_context():
        # Import and register blueprints
        from .routes import page_routes, htmx_routes
        app.register_blueprint(page_routes.bp)
        app.register_blueprint(htmx_routes.bp)

        # Add context processors if needed (e.g., make user info available)
        @app.context_processor
        def inject_user():
            # Replace with actual Kinde user fetching logic
            # from kinde_sdk import get_user
            user = None # Placeholder
            try:
                 # user = get_user()
                 pass # Replace with actual logic
            except Exception:
                 pass # Not logged in
            return dict(current_user=user)

    return app
