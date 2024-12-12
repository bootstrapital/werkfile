import os

DATABASE_PATH = os.getenv('/database', 'werkfile.db')
DEFAULT_USER_ID = 1  # For development