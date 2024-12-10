"""
To prevent circular imports:

Define db and migrate in a dedicated module (e.g., app.extensions).
Import models only after db is initialized.
"""

from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate

db = SQLAlchemy()
migrate = Migrate()