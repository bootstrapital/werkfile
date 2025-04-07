#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
PROJECT_NAME="werkfile"
APP_PACKAGE_NAME="werkfile" # Often the same as the project name for the main package

# --- Create Project Root ---
echo "Creating project directory: ${PROJECT_NAME}"
mkdir -p "${PROJECT_NAME}"
cd "${PROJECT_NAME}"

# --- Create Top-Level Files ---
echo "Creating top-level configuration and entrypoint files..."

# Flask app runner/entry point
touch app.py
echo "# ${PROJECT_NAME}/app.py - Flask application entry point" > app.py
echo "from ${APP_PACKAGE_NAME} import create_app" >> app.py
echo "" >> app.py
echo "app = create_app()" >> app.py
echo "" >> app.py
echo "if __name__ == '__main__':" >> app.py
echo "    # Note: Use a proper WSGI server like gunicorn or waitress for production" >> app.py
echo "    app.run(debug=True, port=5000) # Debug mode ON for development" >> app.py

# Python dependencies
touch requirements.txt
echo "# ${PROJECT_NAME}/requirements.txt - Python dependencies" > requirements.txt
echo "Flask" >> requirements.txt
echo "python-dotenv" >> requirements.txt # Highly recommended
echo "python-kinde-sdk" >> requirements.txt
echo "xata-py" >> requirements.txt
echo "PyYAML" >> requirements.txt
# Add other direct dependencies as needed

# Node.js dependencies (for frontend build)
touch package.json
echo '{
  "name": "'"${PROJECT_NAME}"'",
  "version": "1.0.0",
  "description": "Werkfile application frontend build setup",
  "scripts": {
    "build:css": "tailwindcss -i ./'${APP_PACKAGE_NAME}'/static/src/input.css -o ./'${APP_PACKAGE_NAME}'/static/css/output.css",
    "watch:css": "tailwindcss -i ./'${APP_PACKAGE_NAME}'/static/src/input.css -o ./'${APP_PACKAGE_NAME}'/static/css/output.css --watch"
  },
  "devDependencies": {
    "tailwindcss": "^3.0.0", # Use latest v3
    "daisyui": "^4.0.0" # Use latest v4+ compatible with Tailwind v3
    # Add autoprefixer if needed: "autoprefixer": "^10.0.0", "postcss": "^8.0.0"
  }
}' > package.json

# Tailwind CSS configuration
touch tailwind.config.js
echo '/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./'${APP_PACKAGE_NAME}'/templates/**/*.html", // Scan templates
    "./'${APP_PACKAGE_NAME}'/static/js/**/*.js",   // Scan custom JS if needed
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require("daisyui"), // Enable DaisyUI
  ],
  // Optional: DaisyUI configuration
  daisyui: {
    themes: ["light", "dark", "cupcake"], // Add desired themes
  },
}' > tailwind.config.js

# Git ignore file
touch .gitignore
echo "# ${PROJECT_NAME}/.gitignore" > .gitignore
echo ".env" >> .gitignore
echo "__pycache__/" >> .gitignore
echo "*.pyc" >> .gitignore
echo "*.pyo" >> .gitignore
echo "*.pyd" >> .gitignore
echo ".Python" >> .gitignore
echo "build/" >> .gitignore
echo "develop-eggs/" >> .gitignore
echo "dist/" >> .gitignore
echo "downloads/" >> .gitignore
echo "eggs/" >> .gitignore
echo ".eggs/" >> .gitignore
echo "lib/" >> .gitignore
echo "lib64/" >> .gitignore
echo "parts/" >> .gitignore
echo "sdist/" >> .gitignore
echo "var/" >> .gitignore
echo "wheels/" >> .gitignore
echo "*.egg-info/" >> .gitignore
echo ".installed.cfg" >> .gitignore
echo "*.egg" >> .gitignore
echo "instance/" >> .gitignore # Flask instance folder
echo ".webassets-cache/" >> .gitignore
echo ".pytest_cache/" >> .gitignore
echo ".coverage" >> .gitignore
echo "htmlcov/" >> .gitignore
echo ".tox/" >> .gitignore
echo ".nox/" >> .gitignore
echo ".hypothesis/" >> .gitignore
echo ".cache/" >> .gitignore
echo "" >> .gitignore
echo "# Node specific" >> .gitignore
echo "node_modules/" >> .gitignore
echo "npm-debug.log*" >> .gitignore
echo "yarn-debug.log*" >> .gitignore
echo "yarn-error.log*" >> .gitignore
echo "package-lock.json" >> .gitignore # Or keep if preferred
echo "" >> .gitignore
echo "# Editor/OS specific" >> .gitignore
echo ".vscode/" >> .gitignore
echo ".idea/" >> .gitignore
echo "*.iml" >> .gitignore
echo ".DS_Store" >> .gitignore
echo "Thumbs.db" >> .gitignore

# Example Environment variables file
touch .env.example
echo "# ${PROJECT_NAME}/.env.example - Copy to .env and fill in your credentials" > .env.example
echo "FLASK_APP=app.py" >> .env.example
echo "FLASK_DEBUG=1" >> .env.example
echo "" >> .env.example
echo "# Kinde Credentials" >> .env.example
echo "KINDE_DOMAIN=" >> .env.example
echo "KINDE_CLIENT_ID=" >> .env.example
echo "KINDE_CLIENT_SECRET=" >> .env.example
echo "KINDE_CALLBACK_URL=http://localhost:5000/callback" # Adjust if needed
echo "KINDE_LOGOUT_REDIRECT_URL=http://localhost:5000" # Adjust if needed
echo "" >> .env.example
echo "# Xata Credentials" >> .env.example
echo "XATA_API_KEY=" >> .env.example
echo "XATA_DB_URL=" # e.g., https://YourWorkspace-abc123.region.xata.sh/db/your-db-name
echo "" >> .env.example
echo "# Flask Secret Key (generate a strong random key)" >> .env.example
echo "SECRET_KEY='your-very-secret-and-random-key-here'" >> .env.example


# --- Create Main Application Package ---
echo "Creating main application package: ${APP_PACKAGE_NAME}/"
mkdir -p "${APP_PACKAGE_NAME}"

# App Factory and Initialization
touch "${APP_PACKAGE_NAME}/__init__.py"
echo "# ${PROJECT_NAME}/${APP_PACKAGE_NAME}/__init__.py - Application Factory" > "${APP_PACKAGE_NAME}/__init__.py"
echo "import os" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "from flask import Flask" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "from dotenv import load_dotenv" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "# Import Kinde and Xata clients here when implemented" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "load_dotenv() # Load environment variables from .env" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "def create_app(config_object=None):" >> "${APP_PACKAGE_NAME}/__init__.py"
echo '    """Application factory pattern"""' >> "${APP_PACKAGE_NAME}/__init__.py"
echo "    app = Flask(__name__, instance_relative_config=True)" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "    # Load default config or from object" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "    # app.config.from_object('config.DefaultConfig')" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "    app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'default-fallback-secret-key')" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "    # Add other configurations (Kinde, Xata) here" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "    # Initialize extensions (Kinde, Xata) here" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "    # Example: kinde_client.init_app(app)" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "    # Example: xata_client = XataClient(...)" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "    with app.app_context():" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "        # Import and register blueprints" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "        from .routes import page_routes, htmx_routes" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "        app.register_blueprint(page_routes.bp)" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "        app.register_blueprint(htmx_routes.bp)" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "        # Add context processors if needed (e.g., make user info available)" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "        @app.context_processor" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "        def inject_user():" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "            # Replace with actual Kinde user fetching logic" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "            # from kinde_sdk import get_user" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "            user = None # Placeholder" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "            try:" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "                 # user = get_user()" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "                 pass # Replace with actual logic" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "            except Exception:" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "                 pass # Not logged in" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "            return dict(current_user=user)" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "" >> "${APP_PACKAGE_NAME}/__init__.py"
echo "    return app" >> "${APP_PACKAGE_NAME}/__init__.py"

# Optional: Centralized config file (alternative/complement to .env)
# touch "${APP_PACKAGE_NAME}/config.py"
# echo "# ${PROJECT_NAME}/${APP_PACKAGE_NAME}/config.py - Configuration settings" > "${APP_PACKAGE_NAME}/config.py"

# Optional: Models (if data structures get complex beyond basic dicts)
# mkdir -p "${APP_PACKAGE_NAME}/models"
# touch "${APP_PACKAGE_NAME}/models/__init__.py"
# touch "${APP_PACKAGE_NAME}/models/experience.py" # Example model file

# Services / Business Logic / DB Interaction
echo "Creating services directory..."
mkdir -p "${APP_PACKAGE_NAME}/services"
touch "${APP_PACKAGE_NAME}/services/__init__.py"
touch "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "# ${PROJECT_NAME}/${APP_PACKAGE_NAME}/services/experience_service.py" > "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "# Handles CRUD operations for experience entries, interacting with Xata.io" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "# Important: All functions MUST scope queries by the authenticated user ID." >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "import yaml" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "# from flask import current_app # To access Xata client if initialized on app" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "# Placeholder for Xata client initialization" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "# xata = current_app.xata_client" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "def get_experiences(user_id):" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo '    """Fetch all experience entries for a given user."""' >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    print(f'SERVICE: Fetching experiences for user: {user_id}') # Replace with Xata call" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # Example Xata query: " >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # results = xata.data().query('experiences', {" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    #     'filter': {'userId': user_id}," >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    #     'sort': [{'createdAt': 'desc'}]" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # })" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # return results.get('records', [])" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    return [] # Placeholder" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "def get_experience(user_id, entry_id):" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo '    """Fetch a single experience entry by ID for a given user."""' >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    print(f'SERVICE: Fetching experience {entry_id} for user: {user_id}') # Replace with Xata call" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # Example Xata query:" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # record = xata.records().get('experiences', entry_id)" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # if record and record.get('userId') == user_id:" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    #    return record" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    return None # Placeholder" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "def create_experience(user_id, entry_name, yaml_data):" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo '    """Create a new experience entry for a given user."""' >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    print(f'SERVICE: Creating experience \"{entry_name}\" for user: {user_id}') # Replace with Xata call" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # Validate YAML?" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # try:" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    #     parsed_data = yaml.safe_load(yaml_data)" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # except yaml.YAMLError as e:" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    #     print(f'Invalid YAML: {e}')" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    #     return None # Or raise error" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # Example Xata insert:" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # record = xata.records().insert('experiences', {" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    #    'userId': user_id," >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    #    'entryName': entry_name," >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    #    'experienceData': yaml_data" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # })" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # return record" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    return {'id': 'new123', 'entryName': entry_name} # Placeholder" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "def update_experience(user_id, entry_id, entry_name, yaml_data):" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo '    """Update an existing experience entry for a given user."""' >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    print(f'SERVICE: Updating experience {entry_id} for user: {user_id}') # Replace with Xata call" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # First verify ownership (redundant if query below handles it, but good practice)" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # existing = get_experience(user_id, entry_id)" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # if not existing: return None" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # Example Xata update:" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # record = xata.records().update('experiences', entry_id, {" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    #    'entryName': entry_name," >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    #    'experienceData': yaml_data" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # }) # Note: Need Xata policies or backend check to ensure user_id matches" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # return record" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    return {'id': entry_id, 'entryName': entry_name} # Placeholder" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "def delete_experience(user_id, entry_id):" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo '    """Delete an experience entry for a given user."""' >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    print(f'SERVICE: Deleting experience {entry_id} for user: {user_id}') # Replace with Xata call" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # First verify ownership" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # existing = get_experience(user_id, entry_id)" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # if not existing: return False" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # Example Xata delete:" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # xata.records().delete('experiences', entry_id)" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    # return True" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    return True # Placeholder" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "def parse_yaml_safely(yaml_string):" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo '    """Safely parse YAML string, return data or None if invalid."""' >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    try:" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "        data = yaml.safe_load(yaml_string)" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "        # Basic check if it's a dictionary-like structure" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "        # You might add more specific validation here based on expected schema" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "        if isinstance(data, dict):" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "             return data" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "        else:" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "             # Handle cases where YAML is valid but not the expected type (e.g., just a string, list)" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "             print('Parsed YAML is not a dictionary.')" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "             return None" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "    except yaml.YAMLError as e:" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "        print(f'YAML parsing error: {e}')" >> "${APP_PACKAGE_NAME}/services/experience_service.py"
echo "        return None" >> "${APP_PACKAGE_NAME}/services/experience_service.py"


# Routes / Blueprints
echo "Creating routes directory and blueprint files..."
mkdir -p "${APP_PACKAGE_NAME}/routes"
touch "${APP_PACKAGE_NAME}/routes/__init__.py"

# Page Routes (Full page loads)
touch "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "# ${PROJECT_NAME}/${APP_PACKAGE_NAME}/routes/page_routes.py - Full page routes" > "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "from flask import Blueprint, render_template, redirect, url_for" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "# from kinde_sdk.decorators import login_required # Import Kinde decorator" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "# from ..services import experience_service # Import services" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "bp = Blueprint('page', __name__)" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "# --- Authentication Routes (Handled by Kinde SDK/Redirects) ---" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "# Login, Logout, Callback routes are typically handled by the Kinde SDK setup in __init__.py" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "# Example placeholder if manual trigger needed:" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "# @bp.route('/login')" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "# def login():" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "#     return redirect(url_for('kinde.login')) # Assuming kinde blueprint is named 'kinde'" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "# @bp.route('/logout')" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "# def logout():" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "#     return redirect(url_for('kinde.logout'))" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "# --- Application Page Routes ---" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "@bp.route('/')" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "# @login_required # Protect this route" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "def index():" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo '    """Main application page showing the 3-column layout."""' >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "    # user_id = get_kinde_user_id() # Function to get user ID from session/token" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "    user_id = 'user123' # Placeholder" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "    # experiences = experience_service.get_experiences(user_id)" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "    experiences = [] # Placeholder" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "    # Pass initial data for list, potentially first item for editor/preview" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "    return render_template('index.html', experiences=experiences)" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "@bp.route('/resumes')" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "# @login_required" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "def resumes():" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo '    """Placeholder page for Resumes feature."""' >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "    return render_template('resumes.html')" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "@bp.route('/search')" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "# @login_required" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "def search():" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo '    """Placeholder page for Search feature."""' >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "    return render_template('search.html')" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "@bp.route('/profile')" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "# @login_required" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "def profile():" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo '    """Placeholder page for User Profile."""' >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "    return render_template('profile.html')" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "# Helper to get user id (implement properly with Kinde)" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "# def get_kinde_user_id():" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "#     from kinde_sdk import get_user" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "#     user = get_user()" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"
echo "#     return user.id if user else None" >> "${APP_PACKAGE_NAME}/routes/page_routes.py"


# HTMX Fragment Routes
touch "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "# ${PROJECT_NAME}/${APP_PACKAGE_NAME}/routes/htmx_routes.py - Routes serving HTMX fragments" > "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "from flask import Blueprint, render_template, request, jsonify, make_response" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "# from kinde_sdk.decorators import login_required" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "# from .page_routes import get_kinde_user_id # Or centralize user fetching" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "# from ..services import experience_service" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "bp = Blueprint('htmx', __name__, url_prefix='/htmx')" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "# --- Experience List ---" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "@bp.route('/experiences', methods=['GET'])" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "# @login_required" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "def get_experience_list():" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo '    """Return the HTML fragment for the experience list."""' >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    # user_id = get_kinde_user_id()" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    user_id = 'user123' # Placeholder" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    # experiences = experience_service.get_experiences(user_id)" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    experiences = [{'id': '1', 'entryName': 'Sample Project'}, {'id': '2', 'entryName': 'Another Role'}] # Placeholder" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    return render_template('partials/experience_list.html', experiences=experiences)" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "# --- Experience Editor ---" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "@bp.route('/experiences/<entry_id>/edit', methods=['GET'])" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "# @login_required" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "def get_experience_editor(entry_id):" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo '    """Return the HTML fragment for the editor for a specific entry."""' >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    # user_id = get_kinde_user_id()" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    user_id = 'user123' # Placeholder" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    # experience = experience_service.get_experience(user_id, entry_id)" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    experience = {'id': entry_id, 'entryName': 'Sample Project', 'experienceData': 'key: value\\nanother_key: another_value'} # Placeholder" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    if not experience:" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "        return ('Entry not found or not authorized', 404)" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    return render_template('partials/experience_editor.html', experience=experience)" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "@bp.route('/experiences/new/edit', methods=['GET'])" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "# @login_required" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "def get_new_experience_editor():" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo '    """Return the HTML fragment for the editor for a new entry."""' >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    return render_template('partials/experience_editor.html', experience=None) # Pass None or empty dict" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "# --- Experience CRUD Operations (triggered by editor form submissions) ---" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "@bp.route('/experiences', methods=['POST'])" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "# @login_required" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "def create_experience_entry():" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo '    """Handle creation of a new experience entry."""' >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    # user_id = get_kinde_user_id()" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    user_id = 'user123' # Placeholder" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    entry_name = request.form.get('entryName', 'New Entry')" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    yaml_data = request.form.get('experienceData', '')" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    # new_experience = experience_service.create_experience(user_id, entry_name, yaml_data)" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    new_experience = {'id': 'new123', 'entryName': entry_name} # Placeholder" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    if new_experience:" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "        # Respond with updated list item fragment and potentially trigger other updates" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "        # Fetch the newly created item to render it" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "        # experience_for_render = experience_service.get_experience(user_id, new_experience['id'])" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "        experience_for_render = new_experience # Placeholder" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "        response = make_response(render_template('partials/experience_list_item.html', experience=experience_for_render))" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "        # Add HX-Trigger header to tell HTMX to reload the list, select the new item, load editor etc." >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "        response.headers['HX-Trigger'] = '{\"experienceListChanged\": null, \"loadEditor\": \"' + new_experience['id'] + '\"}'" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "        return response" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    else:" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "        # Handle error (e.g., invalid YAML)" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "        return ('Failed to create entry', 400)" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "@bp.route('/experiences/<entry_id>', methods=['PUT', 'POST']) # Use PUT or POST from form" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "# @login_required" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "def update_experience_entry(entry_id):" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo '    """Handle updating an existing experience entry."""' >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    # user_id = get_kinde_user_id()" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    user_id = 'user123' # Placeholder" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    entry_name = request.form.get('entryName')" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    yaml_data = request.form.get('experienceData')" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    # updated_experience = experience_service.update_experience(user_id, entry_id, entry_name, yaml_data)" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    updated_experience = {'id': entry_id, 'entryName': entry_name} # Placeholder" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    if updated_experience:" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "        # Respond potentially with updated list item or just confirmation/trigger" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "        # Fetch the updated item to render it in the list" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "        # experience_for_render = experience_service.get_experience(user_id, updated_experience['id'])" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "        experience_for_render = updated_experience # Placeholder" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "        response = make_response(render_template('partials/experience_list_item.html', experience=experience_for_render))" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "        # Trigger list item update (oob swap) and maybe preview update" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "        response.headers['HX-Trigger'] = '{\"previewNeedsUpdate\": \"' + entry_id + '\"}' # Assuming list item updates itself via oob swap" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "        # If list item isn't OOB swapped, trigger full list reload: 'experienceListChanged': null" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "        return response" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    else:" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "        return ('Failed to update entry or not authorized', 400) # Or 404" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "@bp.route('/experiences/<entry_id>', methods=['DELETE'])" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "# @login_required" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "def delete_experience_entry(entry_id):" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo '    """Handle deletion of an experience entry."""' >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    # user_id = get_kinde_user_id()" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    user_id = 'user123' # Placeholder" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    # success = experience_service.delete_experience(user_id, entry_id)" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    success = True # Placeholder" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    if success:" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "        # Respond with empty content, trigger list update and potentially clear editor/preview" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "        response = make_response('', 200)" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "        response.headers['HX-Trigger'] = '{\"experienceListChanged\": null, \"clearEditorPreview\": null}'" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "        return response" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    else:" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "        return ('Failed to delete entry or not authorized', 400) # Or 404" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "# --- Live Preview ---" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "@bp.route('/preview', methods=['POST'])" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "# @login_required" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "def update_preview():" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo '    """Generate and return the HTML fragment for the live preview based on submitted YAML."""' >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    yaml_data = request.form.get('experienceData', '')" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    # parsed_data = experience_service.parse_yaml_safely(yaml_data)" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    parsed_data = {'preview_key': 'preview_value'} if yaml_data else {} # Placeholder parsing" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    # Render a preview partial template with the parsed data" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "    return render_template('partials/experience_preview.html', data=parsed_data)" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"
echo "" >> "${APP_PACKAGE_NAME}/routes/htmx_routes.py"


# Static Files
echo "Creating static files directory structure..."
mkdir -p "${APP_PACKAGE_NAME}/static/css"
mkdir -p "${APP_PACKAGE_NAME}/static/js"
mkdir -p "${APP_PACKAGE_NAME}/static/src"
mkdir -p "${APP_PACKAGE_NAME}/static/vendor" # For downloaded libs if not using CDN

touch "${APP_PACKAGE_NAME}/static/css/.gitkeep" # Keep dir in git if empty
touch "${APP_PACKAGE_NAME}/static/css/output.css" # Placeholder for compiled CSS
touch "${APP_PACKAGE_NAME}/static/js/.gitkeep" # Keep dir in git if empty
touch "${APP_PACKAGE_NAME}/static/vendor/.gitkeep" # Keep dir in git if empty

# Basic Alpine.js initialization example (optional)
touch "${APP_PACKAGE_NAME}/static/js/alpine_init.js"
echo "// ${PROJECT_NAME}/${APP_PACKAGE_NAME}/static/js/alpine_init.js" > "${APP_PACKAGE_NAME}/static/js/alpine_init.js"
echo "// Example: Initialize Alpine.js data or components if needed" >> "${APP_PACKAGE_NAME}/static/js/alpine_init.js"
echo "document.addEventListener('alpine:init', () => {" >> "${APP_PACKAGE_NAME}/static/js/alpine_init.js"
echo "  console.log('AlpineJS Initialized');" >> "${APP_PACKAGE_NAME}/static/js/alpine_init.js"
echo "  // Alpine.data('dropdown', () => ({ open: false }))" >> "${APP_PACKAGE_NAME}/static/js/alpine_init.js"
echo "})" >> "${APP_PACKAGE_NAME}/static/js/alpine_init.js"

# Tailwind source CSS file
touch "${APP_PACKAGE_NAME}/static/src/input.css"
echo "/* ${PROJECT_NAME}/${APP_PACKAGE_NAME}/static/src/input.css */" > "${APP_PACKAGE_NAME}/static/src/input.css"
echo "@tailwind base;" >> "${APP_PACKAGE_NAME}/static/src/input.css"
echo "@tailwind components;" >> "${APP_PACKAGE_NAME}/static/src/input.css"
echo "@tailwind utilities;" >> "${APP_PACKAGE_NAME}/static/src/input.css"
echo "" >> "${APP_PACKAGE_NAME}/static/src/input.css"
echo "/* Add custom base styles or components here */" >> "${APP_PACKAGE_NAME}/static/src/input.css"


# Templates
echo "Creating templates directory and base files..."
mkdir -p "${APP_PACKAGE_NAME}/templates"
mkdir -p "${APP_PACKAGE_NAME}/templates/partials"

# Base Template
touch "${APP_PACKAGE_NAME}/templates/base.html"
echo '<!DOCTYPE html>
<html lang="en" data-theme="light"> {# Default theme, can be changed #}
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{% block title %}Werkfile{% endblock %}</title>
    {# Link to compiled Tailwind CSS #}
    <link href="{{ url_for('static', filename='css/output.css') }}" rel="stylesheet">
    {# HTMX via CDN #}
    <script src="https://unpkg.com/htmx.org@1.9.10" integrity="sha384-D1Kt99CQMDuVetoL1lrYwg5t+9QdHe7NLX/SoJYkXDFfX37iInKRy5xLSi8nO7UC" crossorigin="anonymous"></script>
    {# Alpine.js via CDN (include BEFORE your own scripts that might use Alpine) #}
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script> {# Use latest v3 #}
    {# Optional: Your custom Alpine init script #}
    {# <script src="{{ url_for('static', filename='js/alpine_init.js') }}"></script> #}
    {# Add meta tags for HTMX CSRF protection if using Flask-WTF CSRF #}
    {# <meta name="htmx-csrf-token" content="{{ csrf_token() }}"> #}
    <style>
        /* Minor style adjustments if needed */
        [hx-indicator] { opacity: 0; transition: opacity 300ms ease-in; }
        .htmx-request [hx-indicator] { opacity: 1; }
        .htmx-request.htmx-target [hx-indicator] { opacity: 1; }
    </style>
</head>
<body class="bg-base-200 min-h-screen">
    {# Optional: Include a navbar partial #}
    {% include "partials/_navbar.html" %}

    <main class="container mx-auto p-4">
        {% block content %}
        <p>Default Content</p>
        {% endblock %}
    </main>

    {# Optional: Footer #}
    <footer class="footer footer-center p-4 bg-base-300 text-base-content mt-10">
      <div>
        <p>Copyright © $(date +%Y) - Werkfile App</p>
      </div>
    </footer>

</body>
</html>' > "${APP_PACKAGE_NAME}/templates/base.html"

# Navbar Partial (Example)
touch "${APP_PACKAGE_NAME}/templates/partials/_navbar.html"
echo '{# ${PROJECT_NAME}/${APP_PACKAGE_NAME}/templates/partials/_navbar.html - Example Navbar #}
<div class="navbar bg-base-100 shadow-md">
  <div class="flex-1">
    <a href="{{ url_for('page.index') }}" class="btn btn-ghost normal-case text-xl">Werkfile</a>
  </div>
  <div class="flex-none">
    <ul class="menu menu-horizontal px-1">
      <li><a href="{{ url_for('page.index') }}">Experiences</a></li>
      <li><a href="{{ url_for('page.resumes') }}">Resumes</a></li>
      <li><a href="{{ url_for('page.search') }}">Search</a></li>
      {# Authentication state handled by Kinde - show login/logout #}
      {# {% if current_user %} #}
          {# Example: Assumes current_user is available via context processor #}
          {# <li tabindex="0"> #}
            {# <a> #}
              {# Profile #}
              {# <svg class="fill-current" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24"><path d="M7.41,8.58L12,13.17L16.59,8.58L18,10L12,16L6,10L7.41,8.58Z"/></svg> #}
            {# </a> #}
            {# <ul class="p-2 bg-base-100"> #}
              {# <li><a href="{{ url_for('page.profile') }}">My Profile</a></li> #}
              {# <li><a href="/logout">Logout</a></li> {# Use Kinde logout URL #}
            {# </ul> #}
          {# </li> #}
      {# {% else %} #}
          {# <li><a href="/login">Login</a></li> {# Use Kinde login URL #}
      {# {% endif %} #}
       <li><a href="/profile">Profile (Placeholder)</a></li>
       <li><a href="/logout">Logout (Placeholder)</a></li>
    </ul>
  </div>
</div>' > "${APP_PACKAGE_NAME}/templates/partials/_navbar.html"


# Main Index Page (3-column layout)
touch "${APP_PACKAGE_NAME}/templates/index.html"
echo '{% extends "base.html" %}

{% block title %}My Experiences - Werkfile{% endblock %}

{% block content %}
<div class="grid grid-cols-1 md:grid-cols-3 gap-4 h-[calc(100vh-10rem)]"> {# Adjust height as needed #}

  {# Column 1: List of Experiences #}
  <div id="experience-list-container" class="bg-base-100 rounded-lg shadow p-4 overflow-y-auto"
       hx-get="{{ url_for('htmx.get_experience_list') }}"
       hx-trigger="load, experienceListChanged from:body" {# Load on page load and when triggered #}
       hx-target="this">
    {# Initial loading state or content can go here #}
    <span class="loading loading-spinner loading-md">Loading experiences...</span>
    {# The actual list will be loaded by HTMX into this div #}
    {# {% include "partials/experience_list.html" %} <-- Or render initial list here if preferred #}
  </div>

  {# Column 2: Editor #}
  <div id="editor-container" class="bg-base-100 rounded-lg shadow p-4 overflow-y-auto">
    {# Placeholder - will be loaded via HTMX when an item is clicked or 'New' is pressed #}
    <div class="text-center text-gray-500 pt-10">
      Select an experience to edit or create a new one.
    </div>
    {# Target for loading the editor form #}
    <div id="editor-content"
         hx-target="this"
         hx-trigger="loadEditor from:body"> {# Triggered by custom event #}
         {# Content loaded here by HTMX - see partials/experience_editor.html #}
    </div>
    <div id="clear-editor-target"
         hx-target="this"
         hx-swap="innerHTML"
         hx-trigger="clearEditorPreview from:body">
         {# When triggered, replace content with nothing or placeholder #}
          <div class="text-center text-gray-500 pt-10">
            Select an experience to edit or create a new one.
          </div>
    </div>
  </div>

  {# Column 3: Preview #}
  <div id="preview-container" class="bg-base-100 rounded-lg shadow p-4 overflow-y-auto">
     {# Placeholder - will be updated live based on editor content #}
    <div class="text-center text-gray-500 pt-10">
      Preview will appear here.
    </div>
     {# Target for live preview updates #}
    <div id="preview-content"
         hx-target="this"
         hx-trigger="previewNeedsUpdate from:body"> {# Triggered by custom event when saved #}
         {# Content loaded here by HTMX - see partials/experience_preview.html #}
    </div>
     <div id="clear-preview-target"
         hx-target="this"
         hx-swap="innerHTML"
         hx-trigger="clearEditorPreview from:body">
          <div class="text-center text-gray-500 pt-10">
            Preview will appear here.
          </div>
    </div>
  </div>

</div>

{# Alpine.js component for handling cross-column interactions if needed #}
<script>
 document.addEventListener('alpine:init', () => {
    Alpine.data('experienceManager', () => ({
        selectedExperienceId: null,
        selectExperience(id) {
            console.log("Selected Experience ID:", id);
            this.selectedExperienceId = id;
            // Optionally trigger HTMX loads directly if needed, though custom events are often cleaner
            // htmx.trigger('#editor-content', 'loadEditor', { detail: { id: id } });
        },
        // Add other interaction logic here
    }))
 })

 // Listen for custom HTMX loadEditor event (if using that approach)
 /*
 document.body.addEventListener('loadEditor', function(evt){
    const editorTarget = document.getElementById('editor-content');
    if (editorTarget && evt.detail) {
        const experienceId = evt.detail; // Get ID from event detail
        if (experienceId) {
             // Construct URL and trigger HTMX GET request for the editor
             const url = `/htmx/experiences/${experienceId}/edit`;
             htmx.ajax('GET', url, {target: '#editor-content', swap: 'innerHTML'});
        } else {
             // Handle case for loading 'new' editor if needed
             const url = `/htmx/experiences/new/edit`;
             htmx.ajax('GET', url, {target: '#editor-content', swap: 'innerHTML'});
        }
    } else if (editorTarget && !evt.detail) {
        // Handle case for 'new' if evt.detail is null or undefined
        const url = `/htmx/experiences/new/edit`;
        htmx.ajax('GET', url, {target: '#editor-content', swap: 'innerHTML'});
    }
 })
 */
 // Listener for simpler loadEditor trigger carrying ID directly in event name (alternative)
 document.body.addEventListener('htmx:loadEditor', function(evt){
    console.log("htmx:loadEditor triggered", evt.detail);
    const editorTarget = document.getElementById('editor-content');
    if (editorTarget && evt.detail && evt.detail.value) { // evt.detail.value from HX-Trigger header
        const experienceId = evt.detail.value;
        const url = `/htmx/experiences/${experienceId}/edit`;
        htmx.ajax('GET', url, {target: '#editor-content', swap: 'innerHTML'});
    } else {
         console.log("No experience ID provided, loading new editor form.");
         const url = `/htmx/experiences/new/edit`;
         htmx.ajax('GET', url, {target: '#editor-content', swap: 'innerHTML'});
    }
 });

 // Listener for preview update trigger
 document.body.addEventListener('htmx:previewNeedsUpdate', function(evt){
    console.log("htmx:previewNeedsUpdate triggered", evt.detail);
    const previewTarget = document.getElementById('preview-content');
    const editorTextarea = document.querySelector('#editor-content textarea[name="experienceData"]'); // Find the textarea
    if (previewTarget && editorTextarea) {
        // We need the current *content* of the editor to generate the preview
        // Ideally, the SAVE action that *triggers* this should also pass the necessary data
        // or the preview route should fetch the latest saved data for that ID.
        // For *live* preview on type, the textarea itself triggers the POST to /htmx/preview
        console.log("Triggering preview update. Note: This event is best used *after* saving.");
        // Example: Trigger a fetch based on the saved ID (less ideal for live update)
        // if (evt.detail && evt.detail.value) {
        //     const experienceId = evt.detail.value;
        //     // Need a route like /htmx/experiences/{id}/preview
        //     // htmx.ajax('GET', `/htmx/experiences/${experienceId}/preview`, {target: '#preview-content', swap: 'innerHTML'});
        // }
    }
 });

 // Listener for clearing editor/preview
 document.body.addEventListener('htmx:clearEditorPreview', function(evt){
     console.log("htmx:clearEditorPreview triggered");
     // Use HTMX triggers defined on the target divs instead of manual clearing
     // const editorTarget = document.getElementById('editor-content');
     // const previewTarget = document.getElementById('preview-content');
     // if(editorTarget) editorTarget.innerHTML = '<div class="text-center text-gray-500 pt-10">Select an experience to edit or create a new one.</div>';
     // if(previewTarget) previewTarget.innerHTML = '<div class="text-center text-gray-500 pt-10">Preview will appear here.</div>';
 });


</script>
{% endblock %}
' > "${APP_PACKAGE_NAME}/templates/index.html"

# List Partial
touch "${APP_PACKAGE_NAME}/templates/partials/experience_list.html"
echo '{# ${PROJECT_NAME}/${APP_PACKAGE_NAME}/templates/partials/experience_list.html - Renders the list of experiences #}
<div class="flex justify-between items-center mb-4">
  <h2 class="text-xl font-semibold">Experiences</h2>
  <button class="btn btn-sm btn-primary"
          hx-get="{{ url_for('htmx.get_new_experience_editor') }}"
          hx-target="#editor-content"
          hx-swap="innerHTML"
          {# hx-trigger="click" #} {# Implicit trigger is click #}
          >
    New Entry
  </button>
</div>

<ul class="menu bg-base-100 w-full p-0">
  {% if experiences %}
    {% for experience in experiences %}
      {% include "partials/experience_list_item.html" %}
    {% endfor %}
  {% else %}
    <li class="p-4 text-center text-gray-500">No experiences found. Create one!</li>
  {% endif %}
</ul>
' > "${APP_PACKAGE_NAME}/templates/partials/experience_list.html"

# List Item Partial
touch "${APP_PACKAGE_NAME}/templates/partials/experience_list_item.html"
echo '{# ${PROJECT_NAME}/${APP_PACKAGE_NAME}/templates/partials/experience_list_item.html - Renders a single item in the list #}
{# Add oob="true" if this needs to be swapped out-of-band, e.g., after create/update #}
<li id="experience-item-{{ experience.id }}" {% if oob_swap %} hx-swap-oob="true" {% endif %} class="border-b border-base-300 last:border-b-0">
  <a href="#" class="block hover:bg-base-200 active:bg-primary active:text-primary-content focus:bg-primary focus:text-primary-content"
     hx-get="{{ url_for('htmx.get_experience_editor', entry_id=experience.id) }}"
     hx-target="#editor-content"
     hx-swap="innerHTML"
     {# Optional: Use Alpine to track selected state visually if needed #}
     {# x-on:click="selectExperience('{{ experience.id }}')" #}
     {# :class="{ 'bg-primary text-primary-content': selectedExperienceId === '{{ experience.id }}' }" #}
     >
    {{ experience.entryName | default('Untitled Entry') }}
    {# Add date or other info if available #}
    {# <span class="text-xs text-gray-500">{{ experience.updatedAt }}</span> #}
  </a>
</li>
' > "${APP_PACKAGE_NAME}/templates/partials/experience_list_item.html"


# Editor Partial
touch "${APP_PACKAGE_NAME}/templates/partials/experience_editor.html"
echo '{# ${PROJECT_NAME}/${APP_PACKAGE_NAME}/templates/partials/experience_editor.html - Renders the editor form #}
{% set is_new = experience is none or experience.id is none %}
<form hx-indicator="#editor-spinner"
      {% if is_new %}
        hx-post="{{ url_for('htmx.create_experience_entry') }}"
        {# Target the list item for swapping after creation #}
        {# This requires the response to be the new list item partial #}
        hx-target="#experience-list-container ul" {# Target the whole list ul #}
        hx-swap="beforeend" {# Append the new item #}
        {# Alternative: Target this form and replace on error? #}
      {% else %}
        hx-put="{{ url_for('htmx.update_experience_entry', entry_id=experience.id) }}" {# Or POST if preferred #}
        {# Target the specific list item to swap it out-of-band #}
        hx-target="#experience-item-{{ experience.id }}"
        hx-swap="outerHTML"
      {% endif %}
      class="space-y-4"
      >

  {# Add CSRF token if using Flask-WTF #}
  {# <input type="hidden" name="csrf_token" value="{{ csrf_token() }}"/> #}

  <h3 class="text-lg font-semibold mb-2">{{ "New Experience" if is_new else "Edit Experience" }}</h3>

  {# Hidden input for ID if editing #}
  {% if not is_new %}
    <input type="hidden" name="entry_id" value="{{ experience.id }}">
  {% endif %}

  {# Entry Name Input #}
  <div>
    <label for="entryName" class="label">
      <span class="label-text">Entry Name (Company/Project):</span>
    </label>
    <input type="text" id="entryName" name="entryName" placeholder="E.g., Acme Corp - Project X"
           class="input input-bordered w-full"
           value="{{ experience.entryName if experience else '' }}" required>
  </div>

  {# YAML Editor Textarea #}
  <div>
     <label for="experienceData" class="label">
        <span class="label-text">Experience Details (YAML):</span>
     </label>
    <textarea id="experienceData" name="experienceData" rows="15"
              class="textarea textarea-bordered w-full font-mono text-sm"
              placeholder="e.g.,&#10;role: Software Engineer&#10;start_date: 2022-01-15&#10;end_date: Present&#10;responsibilities:&#10;  - Developed feature Y&#10;  - Fixed bug Z"
              {# Live Preview Triggering #}
              hx-post="{{ url_for('htmx.update_preview') }}"
              hx-trigger="keyup changed delay:500ms" {# Update preview 500ms after typing stops #}
              hx-target="#preview-content"
              hx-swap="innerHTML"
              hx-indicator="#preview-spinner"
              >{{ experience.experienceData if experience else '' }}</textarea>
  </div>

  {# Action Buttons #}
  <div class="flex justify-between items-center pt-4">
    <div>
      <button type="submit" class="btn btn-primary">
        <span class="loading loading-spinner loading-xs" id="editor-spinner" style="display: none;"></span>
        {{ "Create Entry" if is_new else "Save Changes" }}
      </button>
      {# Add cancel button if needed #}
      {# <button type="button" class="btn btn-ghost" ...>Cancel</button> #}
    </div>
    {% if not is_new %}
    <button type="button" class="btn btn-error btn-outline btn-sm"
            hx-delete="{{ url_for('htmx.delete_experience_entry', entry_id=experience.id) }}"
            hx-target="closest li" {# Target the list item containing this form's trigger, indirectly #}
            {# Or target the list item directly by ID if easier: hx-target="#experience-item-{{ experience.id }}" #}
            hx-swap="outerHTML" {# Remove the list item #}
            hx-confirm="Are you sure you want to delete this entry?"
            {# No indicator needed usually for delete #}
            >
      Delete
    </button>
    {% endif %}
  </div>
</form>
' > "${APP_PACKAGE_NAME}/templates/partials/experience_editor.html"

# Preview Partial
touch "${APP_PACKAGE_NAME}/templates/partials/experience_preview.html"
echo '{# ${PROJECT_NAME}/${APP_PACKAGE_NAME}/templates/partials/experience_preview.html - Renders the preview #}
<div class="prose max-w-none"> {# Using Tailwind Typography plugin via DaisyUI prose class #}
  <h3 class="text-lg font-semibold mb-2 flex justify-between items-center">
    Preview
    <span id="preview-spinner" class="loading loading-spinner loading-xs" style="opacity: 0; transition: opacity 300ms ease-in;"></span> {# HTMX indicator #}
  </h3>

  {# Basic rendering of parsed YAML data - Customize heavily based on desired output format #}
  {% if data and data is mapping %}
    {# Example: Render key-value pairs #}
    {% for key, value in data.items() %}
      <div class="mb-2">
          <strong class="font-medium capitalize">{{ key.replace("_", " ") }}:</strong>
          {% if value is sequence and value is not string %}
              <ul class="list-disc list-inside pl-4">
              {% for item in value %}
                  <li>{{ item }}</li>
              {% endfor %}
              </ul>
          {% elif value is mapping %}
              {# Handle nested dictionaries if necessary #}
              <pre class="bg-base-200 p-2 rounded text-xs"><code>{{ value | tojson(indent=2) }}</code></pre>
          {% else %}
              <span class="ml-2">{{ value }}</span>
          {% endif %}
      </div>
    {% endfor %}
  {% elif data %}
     {# Handle non-dictionary but valid YAML? #}
     <p>Previewing raw content:</p>
     <pre class="bg-base-200 p-2 rounded text-xs"><code>{{ data }}</code></pre>
  {% else %}
     <p class="text-gray-500 italic">Enter valid YAML in the editor to see a preview.</p>
  {% endif %}
</div>
' > "${APP_PACKAGE_NAME}/templates/partials/experience_preview.html"


# Placeholder Pages
touch "${APP_PACKAGE_NAME}/templates/resumes.html"
echo '{% extends "base.html" %}
{% block title %}Resumes - Werkfile{% endblock %}
{% block content %}
  <h1 class="text-2xl font-bold mb-4">Resumes</h1>
  <p class="text-gray-600">This feature is coming soon! Manage and generate resumes based on your experience entries.</p>
  {# Add placeholder content or design #}
{% endblock %}
' > "${APP_PACKAGE_NAME}/templates/resumes.html"

touch "${APP_PACKAGE_NAME}/templates/search.html"
echo '{% extends "base.html" %}
{% block title %}Search - Werkfile{% endblock %}
{% block content %}
  <h1 class="text-2xl font-bold mb-4">Search</h1>
  <p class="text-gray-600">This feature is coming soon! Search across all your experience entries.</p>
  {# Add placeholder content or design #}
{% endblock %}
' > "${APP_PACKAGE_NAME}/templates/search.html"

touch "${APP_PACKAGE_NAME}/templates/profile.html"
echo '{% extends "base.html" %}
{% block title %}Profile - Werkfile{% endblock %}
{% block content %}
  <h1 class="text-2xl font-bold mb-4">User Profile</h1>
  <p class="text-gray-600">This feature is coming soon! Manage your profile settings.</p>
  {# Add placeholder content or design - likely Kinde handles most of this #}
{% endblock %}
' > "${APP_PACKAGE_NAME}/templates/profile.html"


# Tests Directory (Optional but Recommended)
echo "Creating tests directory..."
mkdir -p tests
touch tests/__init__.py
touch tests/test_experiences.py # Example test file
echo "# ${PROJECT_NAME}/tests/test_experiences.py" > tests/test_experiences.py
echo "import pytest" >> tests/test_experiences.py
echo "# from ${APP_PACKAGE_NAME} import create_app # Import your app factory" >> tests/test_experiences.py
echo "" >> tests/test_experiences.py
echo "# @pytest.fixture" >> tests/test_experiences.py
echo "# def app():" >> tests/test_experiences.py
echo "#     app = create_app({'TESTING': True, 'SECRET_KEY': 'test'})" >> tests/test_experiences.py
echo "#     # Setup database connections for testing if needed" >> tests/test_experiences.py
echo "#     yield app" >> tests/test_experiences.py
echo "#     # Teardown database connections" >> tests/test_experiences.py
echo "" >> tests/test_experiences.py
echo "# @pytest.fixture" >> tests/test_experiences.py
echo "# def client(app):" >> tests/test_experiences.py
echo "#     return app.test_client()" >> tests/test_experiences.py
echo "" >> tests/test_experiences.py
echo "def test_placeholder():" >> tests/test_experiences.py
echo '    """Remove this placeholder test."""' >> tests/test_experiences.py
echo "    assert True" >> tests/test_experiences.py
echo "" >> tests/test_experiences.py
echo "# Add tests for services, routes, etc." >> tests/test_experiences.py

# --- Final Message ---
cd .. # Go back to the directory where the script was run
echo ""
echo "--------------------------------------------------"
echo " Werkfile project structure created successfully! "
echo "--------------------------------------------------"
echo ""
echo "Next steps:"
echo "1.  cd ${PROJECT_NAME}"
echo "2.  Create and activate a Python virtual environment (e.g., python -m venv venv && source venv/bin/activate)"
echo "3.  Install Python dependencies: pip install -r requirements.txt"
echo "4.  Install Node.js dependencies: npm install"
echo "5.  Copy .env.example to .env and fill in your Kinde and Xata credentials: cp .env.example .env"
echo "6.  Run the Tailwind CSS build/watch process: npm run watch:css (in a separate terminal)"
echo "7.  Run the Flask development server: flask run"
echo "8.  Start implementing the logic in '${APP_PACKAGE_NAME}/services/', '${APP_PACKAGE_NAME}/routes/', and templates."
echo "9.  Configure Kinde and Xata SDKs in '${APP_PACKAGE_NAME}/__init__.py'."
echo ""

exit 0