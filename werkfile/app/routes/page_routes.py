# werkfile/werkfile/routes/page_routes.py - Full page routes
from flask import Blueprint, render_template, redirect, url_for, g
# from kinde_sdk.decorators import login_required # Import Kinde decorator
from ..services import experience_service # Import services

bp = Blueprint('page', __name__)

# --- Authentication Routes (Handled by Kinde SDK/Redirects) ---
# Login, Logout, Callback routes are typically handled by the Kinde SDK setup in __init__.py
# Example placeholder if manual trigger needed:
# @bp.route('/login')
# def login():
#     return redirect(url_for('kinde.login')) # Assuming kinde blueprint is named 'kinde'

# @bp.route('/logout')
# def logout():
#     return redirect(url_for('kinde.logout'))

# --- Application Page Routes ---

@bp.route('/')
def index():
    """
    Renders the landing page for unauthenticated users,
    or the main application page for authenticated users.
    """
    user = None
    try:
        # ---> Check if user is authenticated using Kinde <---
        # user = get_user() # Attempt to get the logged-in user
        # Note: The get_user() might raise an exception if not logged in,
        # or return None. Adjust based on the SDK's behavior.
        g.user = user # Store user in request context (g) if needed elsewhere
    except Exception as e: # Catch potential exceptions from get_user if not logged in
        # print(f"User not logged in or Kinde error: {e}") # Optional logging
        user = None
        # g.user = None

    if user:
        # --- User is Logged In: Show Main App ---
        print(f"User {user.id} authenticated. Showing main app.") # Logging
        # Fetch user-specific data
        try:
            experiences = experience_service.get_experiences(user.id)
        except Exception as service_error:
            print(f"Error fetching experiences for user {user.id}: {service_error}")
            experiences = [] # Default to empty list on error
            # Maybe flash an error message to the user
        # Pass initial data for list, potentially first item for editor/preview
        return render_template('index.html', experiences=experiences)
    else:
        # --- User is Not Logged In: Show Landing Page ---
        print("User not authenticated. Showing landing page.") # Logging
        return render_template('landing.html')
    
@bp.route('/experiences')
# @login_required # Protect this route
def experiences():
    """Main application page showing the 3-column layout."""
    # user_id = get_kinde_user_id() # Function to get user ID from session/token
    user_id = 'user123' # Placeholder
    # experiences = experience_service.get_experiences(user_id)
    experiences = [] # Placeholder
    # Pass initial data for list, potentially first item for editor/preview
    return render_template('index.html', experiences=experiences)

@bp.route('/resumes')
# @login_required
def resumes():
    """Placeholder page for Resumes feature."""
    return render_template('resumes.html')

@bp.route('/search')
# @login_required
def search():
    """Placeholder page for Search feature."""
    return render_template('search.html')

@bp.route('/profile')
# @login_required
def profile():
    """Placeholder page for User Profile."""
    return render_template('profile.html')

# Helper to get user id (implement properly with Kinde)
# def get_kinde_user_id():
#     from kinde_sdk import get_user
#     user = get_user()
#     return user.id if user else None
