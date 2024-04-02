from flask import Flask
from .db import init_app as init_db_app

def create_app():
    app = Flask(__name__)

    from .routes.auth import auth as auth_blueprint
    app.register_blueprint(auth_blueprint)

    from .routes.dashboard import dashboard as dashboard_blueprint
    app.register_blueprint(dashboard_blueprint)

    from .routes.content_management import content as content_blueprint
    app.register_blueprint(content_blueprint)

    app.config.from_object('config.Config')
    
    init_db_app(app)  # Initialize the database app

    return app