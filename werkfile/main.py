# werkfile/app.py - Flask application entry point
from app import create_app

app = create_app()

if __name__ == '__main__':
    # Note: Use a proper WSGI server like gunicorn or waitress for production
    app.run(debug=True, port=5000) # Debug mode ON for development
