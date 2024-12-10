from flask import Flask
from .extensions import db, migrate 


def create_app(config_class="app.config.DevelopmentConfig"):
    app = Flask(__name__)
    app.config.from_object(config_class)

    # Initialize extensions
    db.init_app(app)
    migrate.init_app(app, db)

    # Register blueprints or routes
    with app.app_context():
        from .routes import main_bp
        app.register_blueprint(main_bp)

    return app
