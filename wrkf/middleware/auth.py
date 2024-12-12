# middleware/auth.py
from functools import wraps
from repositories import user_repo

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session:
            return redirect('/login')
        return f(*args, **kwargs)
    return decorated_function

def get_current_user():
    """Get the current logged-in user"""
    user_id = session.get('user_id')
    if user_id:
        return user_repo.get_by_id(user_id)
    return None